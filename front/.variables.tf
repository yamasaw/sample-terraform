# 変数ファイル
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