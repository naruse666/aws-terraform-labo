terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }
  }
}

# arn_parse
output "vpc" {
  value = provider::aws::arn_parse("arn:aws:ec2:us-east-1:123456789012:vpc/vpc-12345sample")
}

output "vpc_region" {
  value = provider::aws::arn_parse("arn:aws:ec2:us-east-1:123456789012:vpc/vpc-12345sample").region
}

# arn_build

output "build" {
  value = provider::aws::arn_build("aws", "ec2", "us-east-1", "123456789012", "vpc/vpc-12345sample")
}
