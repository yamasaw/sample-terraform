# ドメインの証明書の発行
resource "aws_acm_certificate" "cert" {
  provider = aws.credentials
  domain_name = var.front_domain
  validation_method = "DNS"

  # サブドメインも含めた証明書を発行したい場合
  # subject_alternative_names = ["*.${var.front_domain}"]

  tags = {
    Environment = var.Enviroment
  }

  lifecycle {
    create_before_destroy = true
  }
}

# CNAMEレコードを作成
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = data.aws_route53_zone.route53_host_zone.zone_id
}