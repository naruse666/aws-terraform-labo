# aws-waf-logs ...で始まる名前じゃないとエラーとなる
resource "aws_kinesis_firehose_delivery_stream" "log" {
  name        = "aws-waf-logs-stream"
  destination = "extended_s3"
  extended_s3_configuration {
    bucket_arn = aws_s3_bucket.log.arn
    role_arn   = module.kinesis_role.arn
  }
}

