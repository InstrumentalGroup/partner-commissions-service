variable "vpc_id" {
  description = "The VPC ID for creating subnets"
  type        = string
}

variable "internet_gateway_id" {
  description = "ID of Internet Gateway"
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

# Route table for Subnet A
resource "aws_route_table" "subnet_a_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "subnet-a-route-table"
  }
}

resource "aws_route_table_association" "subnet_a_association" {
  subnet_id      = var.subnet_a_id
  route_table_id = aws_route_table.subnet_a_route_table.id
}

# Route table for Subnet B
resource "aws_route_table" "subnet_b_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "subnet-b-route-table"
  }
}

resource "aws_route_table_association" "subnet_b_association" {
  subnet_id      = var.subnet_b_id
  route_table_id = aws_route_table.subnet_b_route_table.id
}
