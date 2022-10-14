provider "aws" {
  region  = "ap-south-1"
  profile = "vero/lightnet-nonprod"
}

module "vpc" {
  source                = "./module/vpc"
  vpc_name              = "mumbai-vpc"
  vpc_cidr              = "192.168.0.0/16"
  subnet_cidr_pub       = "192.168.0.0/24"
  subnet_cidr_priv      = "192.168.1.0/24"
}

