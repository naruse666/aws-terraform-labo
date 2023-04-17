locals {
  function_name = "aws-labo-stop-ecs-service"
}

data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = "src"
  output_path = "archive/lambda_function.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = local.function_name
  role          = module.lambda_role.arn
  handler       = "main"
  runtime       = "go1.x"

  filename         = data.archive_file.function_source.output_path
  source_code_hash = data.archive_file.function_source.output_base64sha256

  kms_key_arn = aws_kms_key.lambda_key.arn

  depends_on = [aws_iam_role_policy_attachment.lambda_policy, aws_cloudwatch_log_group.lambda_log_group]
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${local.function_name}"
}

resource "aws_kms_key" "lambda_key" {
  description             = "Lambda Function CMK"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_lambda_permission" "allow_eventbridge_start" {
  statement_id  = "AllowExecutionFromEventBridgeStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_ecs_rule.arn
}

resource "aws_lambda_permission" "allow_eventbridge_stop" {
  statement_id  = "AllowExecutionFromEventBridgeStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_ecs_rule.arn
}
