variable "app_name" {
  description = "Name of the app"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID for creating subnets"
  type        = string
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "${var.app_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = "HTTP"
  }
}

output "target_group_arn" {
  value       = aws_lb_target_group.ecs_tg.arn
  description = "ARN of the Target Group"
}
