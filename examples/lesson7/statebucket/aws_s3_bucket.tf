resource "aws_s3_bucket" "bucket" {
  #checkov:skip=CKV_AWS_52
  #checkov:skip=CKV_AWS_18
  acl    = private
  bucket = var.s3_bucket_name

  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}


variable "s3_bucket_name" {
  type = string
}
