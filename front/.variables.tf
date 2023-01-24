# 変数ファイル
variable "profile" {
    description = "AWS CLIの接続を行うのに利用するプロファイル名"
    type = string
    default = "terraform"
}

variable "domain" {
    description = "コンテンツの配信を行うドメイン"
    type = string
    default = "xxxx.com"
}

variable "tags" {
    description = "リソースに付帯するタグの一覧"
    type = map
    default = {
        Service: "yamasaw_test"
        Enviroment: "dev"
    }
}