# 変数ファイル
variable "service" {
  description = "サービス識別用の文字列。英数字および`-`で記載する"
  type = string
}

variable "cloudfront_distribution_arn" {
  description = ""
  type = string
}

