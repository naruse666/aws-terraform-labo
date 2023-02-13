resource "aws_instance" "web" {
  ami                  = "ami-0bba69335379e17f8"
  instance_type        = "t2.micro"
  iam_instance_profile = module.ssm_role.name
  tags = {
    Name = "inspector_test"
  }
}

module "ssm_role" {
  source = "../../../modules/iam/ssm_managed_instance_role"
  name = "SSMManagedInstanceProfileForInspector"
}
