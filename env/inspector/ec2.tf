resource "aws_instance" "web" {
  ami                  = "ami-0bba69335379e17f8"
  instance_type        = "t2.micro"
  iam_instance_profile = data.aws_iam_role.test.name
  tags = {
    Name = "inspector_test"
  }
}

data "aws_iam_role" "test" {
  name = "ssm_managed_role"
}