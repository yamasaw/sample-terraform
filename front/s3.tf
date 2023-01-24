# バケットを作成
# 既にこの構成のTerraform以外でS3 Buketが作成されている場合以下のエラーになる
# bucket: BucketAlreadyOwnedByYou
resource "aws_s3_bucket" "s3-bucket" {
    bucket_prefix = var.domain
    tags = var.tags
}
# バケットを非公開設定に
resource "aws_s3_bucket_public_access_block" "bucket_publick-access" {
  bucket = aws_s3_bucket.s3-bucket.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


# OACを反映するためポリシー設定
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