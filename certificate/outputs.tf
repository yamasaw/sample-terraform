output "main" {
  value = {
    acm_certificate_arn = aws_acm_certificate.main.arn
  }
}
