module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = "waf-vpc"
  azs                  = ["ap-northeast-1a", "ap-northeast-1d"]
  cidr                 = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnets      = ["10.0.10.0/24"]
  #デフォルトセキュリティグループのルール削除
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []
}