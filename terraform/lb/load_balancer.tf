variable "app_name" {
  description = "Name of the app"
  type        = string
}

variable "subnet_a_id" {
  description = "ID of Subnet A"
  type        = string
}

variable "subnet_b_id" {
  description = "ID of Subnet B"
  type        = string
}

variable "security_group_id" {
  description = "ID of Subnet C"
  type        = string
}

variable "target_group_arn" {
  description = "ID of Subnet C"
  type        = string
}

resource "aws_lb" "app_alb" {
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = [var.subnet_a_id, var.subnet_b_id]

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name = "${var.app_name}-alb"
  }
}

# ---- HTTP Listener (80) ----

# resource "aws_lb_listener" "http_listener" {
#   load_balancer_arn = aws_lb.app_alb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "forward"
#     target_group_arn = var.target_group_arn
#   }
# }

# ---- HTTP Listener (80) ----

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      protocol = "HTTPS"
      port     = "443"
      status_code = "HTTP_301"
    }
  }
}

# ---- 443 HTTPS Listener ----

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:098922872245:certificate/5cb522ff-8bfd-4384-9147-e543f2a851e1"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "502 Bad Gateway"
      status_code  = "502"
    }
  }
}

# ---- 443 HTTPS Rules ----

resource "aws_lb_listener_rule" "https_host_header_rule" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 1

  condition {
    host_header {
      values = ["pcs.instrumental.net"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}
