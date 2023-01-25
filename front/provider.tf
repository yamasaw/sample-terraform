terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.18"
    }
  }
}

provider "aws" {
  alias = "default"
  region  = "ap-northeast-1"
  # IAM profile
  profile = var.profile
}

provider "aws" {
  alias = "global" # SSL証明書はバージニア北部のリージョンに存在しないとCloudFrontで参照できない
  region  = "us-east-1"
  # IAM profile
  profile = var.profile
}
