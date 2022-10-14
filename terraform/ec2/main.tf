#provider block
provider "aws" {
  region = "ap-southeast-1"
  profile = "default"
}

# security group in vpc
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH from internet"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

#ec2 block
resource "aws_instance" "my-ec2" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  key_name = var.keypair
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  
  tags = {
    Name = "ec2-terraform"
  }
}

output "ip-public" {
  value = aws_instance.my-ec2.public_ip
}

