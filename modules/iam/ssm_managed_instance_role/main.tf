resource "aws_iam_instance_profile" "profile" {
  name = var.name
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "SSM-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.role.name
  policy_arn = data.aws_iam_policy.policy.arn
}

data "aws_iam_policy" "policy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}