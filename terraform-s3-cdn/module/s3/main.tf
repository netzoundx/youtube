resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"

  website {
    index_document = "index.html"
  }

  tags = {
    Name        = "${var.project}-${var.service_name}-${var.env}"
    project     = var.project
    environment = var.env
    terraform   = true
    component   = "frontend"
  }
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        }
    ]
}
POLICY
}
