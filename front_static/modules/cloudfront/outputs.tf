output "main" {
  value = {
    cloudfront_distribution_arn = aws_cloudfront_distribution.main.arn
  }
}
