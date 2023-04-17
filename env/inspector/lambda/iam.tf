module "lambda_role"{
  source = "../../../modules/iam/sts_role"
  name = "lambda"
  service_name = "lambda.amazonaws.com"
}

data "aws_iam_policy" "lambda_basic_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_policy" {
  source_policy_documents = [data.aws_iam_policy.lambda_basic_execution.policy]

  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name = "LambdaPolicy"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role = module.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
