module "s3_bucket" {
  for_each = var.buckets
  source   = "terraform-aws-modules/s3-bucket/aws"

  bucket        = "${var.environment}-${each.value.bucket_name}"
  acl           = each.value.acl
  force_destroy = lookup(each.value, "force_destroy")
  versioning    = lookup(each.value, "versioning")
  website       = lookup(each.value, "website")

  block_public_acls = lookup(each.value, "block_public_acls")

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.objects[each.key].arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  lifecycle_rule          = lookup(each.value, "lifecycle_rules", )
  restrict_public_buckets = lookup(each.value, "restrict_public_buckets")
  allowed_kms_key_arn     = aws_kms_key.objects[each.key].arn
  tags = {
    managed-by = "terraform-aws-modules/s3-bucket/aws" # Allows you to see which TF module manages these resources, in addition to the repo
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  for_each = data.aws_iam_policy_document.s3_policy

  bucket = module.s3_bucket[each.key].s3_bucket_id
  policy = each.value.json
}