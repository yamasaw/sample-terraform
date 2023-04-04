provider "aws" {
  alias = "global" # SSL証明書はバージニア北部のリージョンに存在しないとCloudFrontで参照できない
  region  = "us-east-1"
  # IAM profile
  profile = var.profile
}
