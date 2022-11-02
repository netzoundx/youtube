provider "aws" {
  region  = "ap-southeast-1"
  profile = "netzoundx"
}

module "s3" {
  source       = "./module/s3"
  bucket_name  = "profile.netzoundx.cc"
  project      = "profile"
  env          = "production"
  service_name = "static-website"
}

module "cloudfront" {
  source       = "./module/cloudfront"
  bucket_name  = "profile.netzoundx.cc"
  project      = "profile"
  env          = "production"
  service_name = "cloudfront"
}