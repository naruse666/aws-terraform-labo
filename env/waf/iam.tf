module "kinesis_role" {
  source       = "../../modules/iam/sts_role"
  name         = "kinesis_role"
  service_name = "firehose.amazonaws.com"
}

resource "aws_iam_role_policy_attachment" "log" {
  role       = module.kinesis_role.name
  policy_arn = aws_iam_policy.log.arn
}

resource "aws_iam_policy" "log" {
  name = "kinesis_write_s3_policy"
  policy = templatefile("${path.module}/kinesis_role.json.tpl", {
    bucket_name = aws_s3_bucket.log.id,
    kinesis_arn = aws_kinesis_firehose_delivery_stream.log.arn
  })
}