# Route53ホストゾーンを取得
data "aws_route53_zone" "main" {
  name         = var.domain
  private_zone = false
}

# ディストリビューションの作成
resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id = aws_s3_bucket.main.id
  }

  # comment = ""

  default_root_object = "index.html"

  enabled = true
  is_ipv6_enabled = true

  aliases = [ var.domain ]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.main.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn = aws_acm_certificate.main.arn
    minimum_protocol_version = "TLSv1.2_2021" # 推奨値を指定
    # SNI(名前ベース)のSSL機能を使用する。
    # https://aws.amazon.com/jp/cloudfront/custom-ssl-domains/
    ssl_support_method = "sni-only"
  }
}

# S3 Origin Access Control
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = aws_s3_bucket.main.arn
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Aレコードにディストリビューションのドメインを指定
resource "aws_route53_record" "alias_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name = var.domain
  type = "A"
  alias {
  name = aws_cloudfront_distribution.main.domain_name
  zone_id = aws_cloudfront_distribution.main.hosted_zone_id
  evaluate_target_health = false
  }
}