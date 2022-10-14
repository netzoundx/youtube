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

#Create Inter gateway and attach to vpc for public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc-main.id}"

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

#Create public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id     = "${aws_vpc.vpc-main.id}"
  cidr_block = var.subnet_cidr_pub
  availability_zone = "ap-south-1a"
  tags = {
    Name = "${var.vpc_name}-pub"
  }
}

#Create public subnet's route table and associate to public subnet
resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.vpc-main.id}"
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags = {
    Name = "${var.vpc_name}-pub-rt"
  }
}
resource "aws_route_table_association" "public-rt-assoc" {
  subnet_id      = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

#Create private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id     = "${aws_vpc.vpc-main.id}"
  cidr_block = var.subnet_cidr_priv
  availability_zone = "ap-south-1a"
  tags = {
    Name = "${var.vpc_name}-priv"
  }
}
#Create private subnet's route table and associate to private subnet
resource "aws_route_table" "private-rt" {
  vpc_id = "${aws_vpc.vpc-main.id}"
  route = []
  tags = {
    Name = "${var.vpc_name}-pri-rt"
  }
}
resource "aws_route_table_association" "private-rt-assoc" {
  subnet_id      = "${aws_subnet.private-subnet.id}"
  route_table_id = "${aws_route_table.private-rt.id}"
}

