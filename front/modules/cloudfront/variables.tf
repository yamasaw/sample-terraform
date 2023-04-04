# 変数ファイル
variable "service" {
  description = "サービス識別用の文字列。英数字および`-`で記載する"
  type = string
}

variable "domain" {
  description = "コンテンツの配信を行うドメイン"
  type = string
}

variable "s3_bucket" {
  description = ""
  type = object({
    id = string
    bucket_regional_domain_name = string
  })
}

variable "acm_certificate_arn" {
  description = ""
  type = string
}

variable "wafv2_web_acl_arn" {
  description = ""
  type = string
}
