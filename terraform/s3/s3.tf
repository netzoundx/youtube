# provider block
provider "aws" {
  region = "ap-southeast-1"
  profile = "default"
}

#s3 block
resource "aws_s3_bucket" "b" {
  bucket = "netzoundx-terraform"

  tags = {
    Name        = "netzoundx-terraform"
  }
}
