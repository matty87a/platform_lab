data "aws_iam_policy_document" "s3_policy" {
  for_each = var.buckets

  statement {
    sid    = "s3"
    effect = "Allow"

    resources = [module.s3_bucket[each.key].s3_bucket_arn]

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]

    dynamic "principals" {
      for_each = [each.value]
      content {
        type = "AWS"
        identifiers = [
          # I've worked on the assumption that there are seperate IAM Roles for accessing pii/non-pii data in these buckets rather than create them as paert of this code.
          # Its also assumed that these roles will have the necessary KMS access included
          each.value.pii == true ? "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/pii_s3_access" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/s3_access"
        ]
      }
    }
  }

  dynamic "statement" {
    for_each = each.value.website == true ? [1] : []
    content {
      sid    = "cloudFront"
      effect = "Allow"

      resources = ["${module.s3_bucket[each.key].s3_bucket_arn}/*"]

      actions = [
        "s3:GetObject"
      ]

      principals {
        type        = "AWS"
        identifiers = ["aws_cloudfront_origin_access_identity.static_hosting.iam_arn"]
        # identifiers = [aws_cloudfront_origin_access_identity.static_hosting.iam_arn] # Localstack doesnt support this resource - left for visibility - see cloudfront.tf
      }
    }
  }
}