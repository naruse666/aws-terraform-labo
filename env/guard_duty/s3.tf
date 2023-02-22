resource "aws_s3_bucket" "gd_bucket" {
  bucket        = "gd-result-destination-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "gd_bucket_acl" {
  bucket = aws_s3_bucket.gd_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "gd_bucket_policy" {
  bucket = aws_s3_bucket.gd_bucket.id
  policy = data.aws_iam_policy_document.bucket_pol.json
}

resource "aws_s3_bucket_public_access_block" "gd_bucket" {
  bucket = aws_s3_bucket.gd_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}