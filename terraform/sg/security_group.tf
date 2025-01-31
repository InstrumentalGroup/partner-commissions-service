variable "vpc_id" {
  description = "The VPC ID for creating subnets"
  type        = string
}

resource "aws_security_group" "vpc_security_group" {

    name        = "vpc-general-security-group"
    description = "Security group for VPC General"
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 3009
        to_port     = 3009
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "vpc-general-security-group"
    }
}

output "security_group_id" {
  value = aws_security_group.vpc_security_group.id
  description = "Security Group ID"
}