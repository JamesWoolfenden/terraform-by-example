resource "aws_s3_bucket" "bucket" {
  acl    = private
  bucket = var.s3_bucket_name

  versioning {
    enabled = true
  }
}


variable "s3_bucket_name" {
  type=string
}
