# ACL
resource "aws_wafv2_web_acl" "main" {
  provider = aws.global

  name = "${var.service}-acl"
  description = "Web ACL ${var.service}"
  scope       = "CLOUDFRONT"

  default_action {
    block {}
  }

  rule {
    name = "allow-ip-rule"
    priority = 1

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.main.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "allow-ip-rule"
      sampled_requests_enabled   = false
    }
  }


  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.service}-metric"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_ip_set" "main" {
  provider = aws.global

  name = var.service
  description = "IP set ${var.service}"
  scope = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses = var.restraint_addresses
}

# aws_cloudfront_distributionの web_acl_idで関連づけてるので実行しなくても良さげ
# むしろ名前のバリデーションで引っかかるため使えない
# https://github.com/hashicorp/terraform-provider-aws/issues/28753#issuecomment-1376943601
# resource "aws_wafv2_web_acl_association" "main" {
#   resource_arn = aws_cloudfront_distribution.main.arn
#   web_acl_arn = aws_wafv2_web_acl.main.arn
# }
