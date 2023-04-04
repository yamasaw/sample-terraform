# ディストリビューションの作成
resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = var.s3_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
    origin_id = var.s3_bucket.id
  }

  comment = "${var.service} frontend static content"

  # エラーページの指定
  custom_error_response {
    error_code = 403
    # エラーページの指定
    # response_code = 404
    # response_page_path = "/404/index.html"
  }

  default_root_object = "index.html"

  enabled = true
  is_ipv6_enabled = true

  aliases = [ var.domain ]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_bucket.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.main.arn
    }

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
    acm_certificate_arn = var.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021" # 推奨値を指定
    # SNI(名前ベース)のSSL機能を使用する。
    # https://aws.amazon.com/jp/cloudfront/custom-ssl-domains/
    ssl_support_method = "sni-only"
  }

  web_acl_id = var.wafv2_web_acl_arn
}

# S3 Origin Access Control
resource "aws_cloudfront_origin_access_control" "main" {
  name                              = var.s3_bucket.id
  description                       = "${var.service} Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Route53ホストゾーンを取得
data "aws_route53_zone" "main" {
  name         = var.domain
  private_zone = false
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

# index.htmlが省略されたときにindex.htmlを含めたurlにリダイレクトする
resource "aws_cloudfront_function" "main" {
  name    = "redirect-index"
  runtime = "cloudfront-js-1.0"
  comment = "redirect to index.html"
  publish = true
  code    = file("${path.module}/redirect.js")
}
