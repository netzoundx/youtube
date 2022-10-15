provider "aws" {
  region  = "ap-southeast-2"
  profile = "lightnet-nonprod"
}

module "vpc" {
  source                = "./module/vpc"
  vpc_name              = "sydney-vpc"
  availability_zone     = "ap-southeast-2a"
  vpc_cidr              = "192.168.0.0/16"
  subnet_cidr_pub       = "192.168.0.0/24"
  subnet_cidr_priv      = "192.168.1.0/24"
}

