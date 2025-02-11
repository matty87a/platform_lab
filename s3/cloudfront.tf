# Localstack doesnt support this resource unless you have the pro version - left for illustration
# See iam.tf:43

# resource "aws_cloudfront_origin_access_identity" "static_hosting" {
#   comment = "For use with static hosting buckets"
# }