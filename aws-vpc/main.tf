# Terraform script to create AWS-VPC with subnets and route table (single AZ)
# Written by Netzoundxchannel

provider "aws" {
  region  = "ap-south-1"
  profile = "love"
}

module "vpc" {
  source                = "./module/vpc"
  vpc_name              = "mumbai-vpc"
  availability_zone     = "ap-south-1a"
  vpc_cidr              = "20.0.0.0/16"
  subnet_cidr_pub       = "20.0.0.0/24"
  subnet_cidr_priv      = "20.0.1.0/24"
}

