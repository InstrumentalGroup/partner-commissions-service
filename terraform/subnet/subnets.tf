variable "aws_region" {
  description = "Deployment target region"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID for creating subnets"
  type        = string
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "subnet-a"
  }
}

output "subnet_a_id" {
  value = aws_subnet.subnet_a.id
  description = "ID of Subnet A"
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "subnet-b"
  }
}

output "subnet_b_id" {
  value = aws_subnet.subnet_b.id
  description = "ID of Subnet B"
}
