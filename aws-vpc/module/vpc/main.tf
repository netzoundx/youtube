# Create main vpc
resource "aws_vpc" "vpc-main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Create Inter gateway and attach to vpc for public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc-main.id}"

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Create public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id     = "${aws_vpc.vpc-main.id}"
  cidr_block = var.subnet_cidr_pub
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.vpc_name}-public-subnet"
  }
}

# Create public subnet's route table and associate to public subnet
resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.vpc-main.id}"
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}
resource "aws_route_table_association" "public-rt-assoc" {
  subnet_id      = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

# Create EIP and associate for NAT gateway
resource "aws_eip" "ip-for-nat" {
  vpc      = true
}
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.ip-for-nat.id}"
  subnet_id     = "${aws_subnet.public-subnet.id}"

  tags = {
    Name = "${var.vpc_name}-nat-gw"
  }
}

# Create private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id     = "${aws_vpc.vpc-main.id}"
  cidr_block = var.subnet_cidr_priv
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.vpc_name}-private-subnet"
  }
}
# Create private subnet's route table and associate to private subnet
resource "aws_route_table" "private-rt" {
  vpc_id = "${aws_vpc.vpc-main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat-gw.id}"
  }
  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}
resource "aws_route_table_association" "private-rt-assoc" {
  subnet_id      = "${aws_subnet.private-subnet.id}"
  route_table_id = "${aws_route_table.private-rt.id}"
}

# Create security group for vpc

# Public's SG
resource "aws_security_group" "public-sg" {
  name        = "${var.vpc_name}-public-sg"
  description = "Public security group"
  vpc_id      = "${aws_vpc.vpc-main.id}"

  ingress {
    description      = "SSH from internet"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow ICMP"
    from_port        = 8
    to_port          = 0
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    description      = "Allow HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.vpc_name}-public-sg"
  }
}

# Private's SG
resource "aws_security_group" "private-sg" {
  name        = "${var.vpc_name}-private-sg"
  description = "Private security group"
  vpc_id      = "${aws_vpc.vpc-main.id}"

  ingress {
    description      = "SSH from network"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
    #ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow ICMP from network"
    from_port        = 8
    to_port          = 0
    protocol         = "icmp"
    cidr_blocks      = [var.vpc_cidr]
    #ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.vpc_name}-private-sg"
  }
}