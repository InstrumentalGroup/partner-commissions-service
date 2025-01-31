resource "aws_vpc" "vpc_general" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-general"
  }
}

output "vpc_id" {
  value = aws_vpc.vpc_general.id
  description = "The ID of the VPC"
}
