variable "vpc_id" {
  description = "The VPC ID for creating subnets"
  type        = string
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "internet-gateway-general"
  }
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
  description = "The ID of the Internet Gateway"
}