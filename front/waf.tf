# ACL
resource "aws_wafv2_web_acl" "main" {
  name = var.service
  description = "Web ACL ${var.service}"
  scope       = "CLOUDFRONT"
  provider = aws.credentials

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

  tags = var.tags
}

resource "aws_wafv2_ip_set" "main" {
  provider = aws.credentials

  name = var.service
  description = "IP set ${var.service}"
  scope = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses = var.addresses

  tags = var.tags
}