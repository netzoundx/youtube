resource "aws_vpc" "vpc-main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_pvc.vpc-main.id
  cidr_block = var.subnet_cidr_pub
  tags = {
    Name = var.subnet_cidr_pub_name
  }
}
resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_pvc.vpc-main.id
  cidr_block = var.subnet_cidr_priv
  tags = {
    Name = var.subnet_cidr_priv_name
  }
}