# 変数ファイル
variable "front_domain" {
    description = ""
    type = string
    default = "xxxx.com"
}

variable "service_tag" {
    description = "リソースに付帯するサービスのタグ"
    type = string
    default = "SERVICE_NAME"
}

variable "Enviroment" {
    description = "開発環境タグ[dev, stg, prod]"
    type = string
    default = "dev"
}