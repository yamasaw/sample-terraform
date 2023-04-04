# 変数ファイル
variable "profile" {
  description = "AWSに接続を行うプロファイル"
  type = string
}

variable "domain" {
  description = "コンテンツの配信を行うドメイン"
  type = string
}
