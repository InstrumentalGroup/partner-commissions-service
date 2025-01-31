variable "app_name" {
  description = "Name of the app"
  type        = string
}

variable "aws_region" {
  description = "Deployment target region"
  type        = string
}

resource "aws_ecr_repository" "app_ecr_repo" {
  name                 = "products-${var.app_name}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

resource "null_resource" "docker_build_push" {
  provisioner "local-exec" {
    command = <<EOC
      # Authenticate Docker to AWS ECR
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.app_ecr_repo.repository_url}

      # Build the Docker image
      docker build -f ${path.module}/../../Dockerfile --platform=linux/amd64 -t ${aws_ecr_repository.app_ecr_repo.repository_url}:latest ${path.module}/../../.

      # Tag the Docker image
      docker tag ${aws_ecr_repository.app_ecr_repo.repository_url}:latest ${aws_ecr_repository.app_ecr_repo.repository_url}:latest

      # Push the Docker image to ECR
      docker push ${aws_ecr_repository.app_ecr_repo.repository_url}:latest
    EOC
  }

  depends_on = [aws_ecr_repository.app_ecr_repo]
}

output "repository_url" {
  value = aws_ecr_repository.app_ecr_repo.repository_url
  description = "ECR Repository Url"
}