variable "environment" {
  description = "Deployment environment (e.g., dev, stage, prod)"
  type        = string
}

variable "buckets" {
  description = "Map of S3 bucket configurations"
  type = map(object({
    bucket_name   = string
    force_destroy = optional(bool, false)
    website       = optional(object({}), {})

    acl = string

    pii = optional(bool)

    block_public_acls       = optional(bool, true)
    restrict_public_buckets = optional(bool, true)

    versioning = optional(object({
      enabled = bool
      }),
      {
        enabled = false
    })

    lifecycle_rules = optional(list(object({
      id      = string
      enabled = bool
      prefix  = string
      expiration = object({
        days = number
      })
    })), [])

    tags = map(string)
  }))

  default = {}
}
