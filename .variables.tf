# 変数ファイル
variable "front_domain" {
    description = ""
    type = string
    default = "xxxx.com"
}

variable "s3_bucket" {
    description = "作成するS3バケット名"
    type = string
    default = "xxxxxx-bucket"
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