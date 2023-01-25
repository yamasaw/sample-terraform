# デフォルトで接続する AWS Regionを取得する
data "aws_region" "default" { }

# Route53ホストゾーンを取得
data "aws_route53_zone" "main" {
  name         = var.domain
  private_zone = false
}
