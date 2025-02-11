resource "aws_kms_key" "objects" {
  for_each                = var.buckets
  enable_key_rotation     = true
  rotation_period_in_days = 90
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "objects" {
  for_each      = aws_kms_key.objects
  name          = "alias/${var.environment}-${each.key}-object-key"
  target_key_id = aws_kms_key.objects[each.key].key_id
}