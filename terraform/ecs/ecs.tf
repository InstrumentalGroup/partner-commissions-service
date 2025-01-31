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
  description = "ID of the Security Group"
  type        = string
}

variable "task_definition_arn" {
  description = "ID of Subnet C"
  type        = string
}

variable "target_group_arn" {
  description = "ID of Subnet C"
  type        = string
}

resource "aws_ecs_cluster" "app_cluster" {
  name = "${var.app_name}-cluster"
}

resource "aws_ecs_service" "app_service" {
  name            = "${var.app_name}-svc"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = var.task_definition_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip   = true
    security_groups    = [var.security_group_id]
    subnets            = [var.subnet_a_id, var.subnet_b_id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.app_name}-container"
    container_port   = 3009
  }
}
