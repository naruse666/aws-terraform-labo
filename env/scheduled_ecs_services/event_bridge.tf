// JST 8:00  EventBridgeではUTC表現のみのためJSTに合わせている
resource "aws_cloudwatch_event_rule" "start_ecs_rule" {
  name                = "start-ecs-lambda-event-rule"
  description         = "Trigger lambda function at 8am daily"
  schedule_expression = "cron(0 23 ? * SUN-THU *)"
}

// JST 21:00
resource "aws_cloudwatch_event_rule" "stop_ecs_rule" {
  name                = "stop-ecs-lambda-event-rule"
  description         = "Trigger lambda function at 9pm daily"
  schedule_expression = "cron(0 12 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "start_ecs_target" {
  rule      = aws_cloudwatch_event_rule.start_ecs_rule.name
  target_id = "start-ecs-lambda-function-target"
  arn       = aws_lambda_function.lambda.arn
  input = jsonencode({
    "status" : "start"
  })
}

resource "aws_cloudwatch_event_target" "stop_ecs_target" {
  rule      = aws_cloudwatch_event_rule.stop_ecs_rule.name
  target_id = "stop-ecs-lambda-function-target"
  arn       = aws_lambda_function.lambda.arn
  input = jsonencode({
    "status" : "stop"
  })
}
