module "cloudfront" {
  source = "./modules/cloudfront"

  service = var.service
  domain = var.domain

  s3_bucket = module.s3.main.s3_bucket
  acm_certificate_arn = aws_acm_certificate.main.arn
  wafv2_web_acl_arn = module.waf.main.wafv2_web_acl_arn
}

module "s3" {
  source = "./modules/s3"

  service = var.service

  cloudfront_distribution_arn = module.cloudfront.main.cloudfront_distribution_arn
}

module "waf" {
  source = "./modules/waf"

  service = var.service
  restraint_addresses = var.restraint_addresses
  profile = var.profile
  tags = var.tags
}
