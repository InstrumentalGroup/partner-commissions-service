variable "app_name" {
  description = "Name of the app"
  type        = string
}

variable "aws_region" {
  description = "Name of the app"
  type        = string
}

variable "repository_url" {
  description = "ECR URI"
  type        = string
}

variable "env_file" {
  description = "ECR URI"
  type        = string
}

resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ecs/${var.app_name}-task"
  retention_in_days = 7
  tags = {
    Name = "${var.app_name}-log-group"
  }
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "${var.app_name}_task_definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = "arn:aws:iam::098922872245:role/ecsTaskExecutionRole" 
  task_role_arn            = "arn:aws:iam::098922872245:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "${var.app_name}-container"
      image     = "${var.repository_url}:latest"
      essential = true
      cpu       = 1024
      memory    = 3072

      portMappings = [
        {
          containerPort = 3009
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "APP_S3_BUCKET"
          value = "${var.env_file}"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.app_name}-task"
          "awslogs-region"        = "${var.aws_region}"
          "awslogs-stream-prefix" = "${var.app_name}"
        }
      }
    }
  ])
}

output "task_definition_arn" {
  value       = aws_ecs_task_definition.app_task.arn
  description = "ARN of the Task Definition"
}
