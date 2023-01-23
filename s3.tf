# Route53ホストゾーンを取得
data "aws_route53_zone" "route53_host_zone" {
  name         = var.front_domain
  private_zone = false
}

# バケットを作成
# 既にこの構成のTerraform以外でS3 Buketが作成されている場合以下のエラーになる
# bucket: BucketAlreadyOwnedByYou
resource "aws_s3_bucket" "s3-bucket" {
    bucket = var.s3_bucket

    tags = {
        Service = var.service_tag
        Enviroment = var.Enviroment
    }
}
# 公開設定を非公開設定に
resource "aws_s3_bucket_public_access_block" "bucket_publick-access" {
  bucket = aws_s3_bucket.s3-bucket.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# 証明書の発行
resource "aws_acm_certificate" "cert" {
  provider = "aws.credentials"
  domain_name = var.front_domain
  validation_method = "DNS"

  # 代替ドメインを複数設定する場合
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

# Cloud Front の作成
resource "aws_cloudfront_distribution" "bucket_distribution" {
  origin {
    domain_name = aws_s3_bucket.s3-bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id = aws_s3_bucket.s3-bucket.id
  }

  # comment = "" 

  default_root_object = "index.html"

  enabled = true
  is_ipv6_enabled = true

  aliases = [ var.front_domain ]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.s3-bucket.id

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
    acm_certificate_arn = aws_acm_certificate.cert.arn
    minimum_protocol_version = "TLSv1.2_2021" # 推奨値を指定
    # SNI(名前ベース)のSSL機能を使用する。
    # https://aws.amazon.com/jp/cloudfront/custom-ssl-domains/
    ssl_support_method = "sni-only"
  }
}

# CloudFront Origin Access Controlの設定
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = aws_s3_bucket.s3-bucket.arn
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# S3 ポリシー設定
resource "aws_s3_bucket_policy" "attach_s3-bucket_policy" {
  bucket = aws_s3_bucket.s3-bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid = "1"
    actions = [ "s3:GetObject" ]
    resources = [ "${aws_s3_bucket.s3-bucket.arn}/*" ]
    principals {
      type = "Service"
      identifiers = [ "cloudfront.amazonaws.com" ]
    }
    condition {
      test = "StringEquals"
      variable = "aws:SourceArn"
      values = [ aws_cloudfront_distribution.bucket_distribution.arn ]
    }
  }
}

# Aレコードを設定する
resource "aws_route53_record" "alias_record" {
   zone_id = data.aws_route53_zone.route53_host_zone.zone_id
   name = var.front_domain
   type = "A"
   alias {
    name = aws_cloudfront_distribution.bucket_distribution.domain_name
    zone_id = aws_cloudfront_distribution.bucket_distribution.hosted_zone_id
    evaluate_target_health = false
   }
}

# WAFの作成