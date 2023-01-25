# 変数ファイル
variable "profile" {
  description = "AWS CLIの接続を行うのに利用するプロファイル名"
  type = string
}

variable "service" {
  description = "サービス識別用の文字列。英数字および`-`で記載する"
  type = string
}

variable "domain" {
  description = "コンテンツの配信を行うドメイン"
  type = string
}

variable "addresses" {
  description = "制限を行うIPアドレス"
  type = list
  default = []
}

variable "tags" {
  description = "リソースに付帯するタグの一覧(Optional)"
  type = map
  default = {}
}
