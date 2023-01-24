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
  region  = "ap-northeast-1"
  # IAM profile
  profile = "terraform"
}

provider "aws" {
  alias = "credentials" # SSL証明書はバージニア北部のリージョンに存在しないとCloudFrontで参照できない
  region  = "us-east-1"
  # IAM profile
  profile = "terraform"
}
