output "main" {
  value = {
    s3_bucket = {
      id = aws_s3_bucket.main.id
      bucket_regional_domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    }
  }
}
