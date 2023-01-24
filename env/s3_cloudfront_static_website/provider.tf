terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket         = "naruse-tf-backend"
    key            = "aws-labo/s3_cloudfront_static_website.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "naruse-tf-backend"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}