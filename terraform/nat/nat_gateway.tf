variable "subnet_a_id" {
  description = "The ID of subnet A"
}

variable "subnet_b_id" {
  description = "The ID of subnet B"
}

resource "aws_eip" "nat_eip_a" {
  vpc = true

  tags = {
    Name = "nat-eip-a"
  }
}

resource "aws_eip" "nat_eip_b" {
  vpc = true

  tags = {
    Name = "nat-eip-b"
  }
}

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_eip_a.id
  subnet_id     = var.subnet_a_id
  connectivity_type = "public"

  tags = {
    Name = "nat-gateway-a"
  }
}

resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = aws_eip.nat_eip_b.id
  subnet_id     = var.subnet_b_id
  connectivity_type = "public"

  tags = {
    Name = "nat-gateway-b"
  }
}