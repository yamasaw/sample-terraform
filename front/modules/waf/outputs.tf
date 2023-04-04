output "main" {
  value = {
    wafv2_web_acl_arn = aws_wafv2_web_acl.main.arn
  }
}
