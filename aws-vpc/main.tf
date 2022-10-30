# Terraform script to create AWS-VPC with subnets and route table (single AZ)
# Written by Netzoundxchannel

provider "aws" {
  region  = "eu-west-3"
  profile = "love"
}

module "vpc" {
  source                = "./module/vpc"
  vpc_name              = "paris-vpc"
  availability_zone     = "eu-west-3a"
  vpc_cidr              = "192.168.0.0/16"
  subnet_cidr_pub       = "192.168.0.0/24"
  subnet_cidr_priv      = "192.168.1.0/24"
}

