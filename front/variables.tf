# 変数ファイル
variable "profile" {
  description = "AWS CLIの接続を行うのに利用するプロファイル名"
  type = string
}

variable "domain" {
  description = "コンテンツの配信を行うドメイン"
  type = string
}

variable "tags" {
  description = "リソースに付帯するタグの一覧"
  type = map
}
