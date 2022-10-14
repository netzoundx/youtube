#Create main vpc
resource "aws_vpc" "vpc-main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}
#Create public 
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.vpc-main.id
  cidr_block = var.subnet_cidr_pub
  tags = {
    Name = "${var.vpc_name}-pub"
  }
}
#Create private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.vpc-main.id
  cidr_block = var.subnet_cidr_priv
  tags = {
    Name = "${var.vpc_name}-priv"
  }
}


