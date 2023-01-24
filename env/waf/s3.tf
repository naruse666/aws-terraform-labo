resource "aws_s3_bucket" "log" {
  bucket        = "naruse-waf-log-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "log" {
  bucket = aws_s3_bucket.log.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "log" {
  bucket = aws_s3_bucket.log.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log" {
  bucket = aws_s3_bucket.log.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}