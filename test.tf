terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "naruse-tf-backend"
    key    = "aws-labo/test.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region  = "ap-northeast-1"
}