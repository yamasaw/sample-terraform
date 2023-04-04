# 変数ファイル
variable "service" {
  description = "サービス識別用の文字列。英数字および`-`で記載する"
  type = string
}

variable "restraint_addresses" {
  description = "制限を行うIPアドレス"
  type = list
  default = []
}

variable "profile" {
  description = "AWSに接続を行うプロファイル"
  type = string
}

variable "tags" {
  description = "リソースに付帯するタグの一覧(Optional)"
  type = map
  default = {}
}
