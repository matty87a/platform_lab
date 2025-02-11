environment = "dev"
buckets = {
  bucket_a = {
    bucket_name = "bucket-a"
    website = {
      index_document = "index.html"
      error_document = "error.html"
    }
    force_destroy = true # This should be fine in a dev env and saves needing to manually clear out objects - have left as the default (false) in the stage and prod vars
    acl           = "private"
    tags = {
      usage = "static-hosting",
    }
  }
  bucket_b = {
    bucket_name = "bucket-b"
    website = {
      index_document = "index.html"
      error_document = "error.html"
    }
    force_destroy = true
    acl           = "private"
    tags = {
      usage = "static-hosting"
    }
  }
  bucket_c = {
    pii                     = true
    bucket_name             = "bucket-c"
    force_destroy           = true
    acl                     = "private"
    block_public_acls       = true
    restrict_public_buckets = true
    versioning = {
      enabled = true
    }
    tags = {
      usage = "pii-storage"
    }
  }
  bucket_d = {
    bucket_name   = "bucket-d"
    acl           = "private"
    force_destroy = true
    lifecycle_rules = [
      {
        id      = "expireDocs"
        enabled = true
        prefix  = ""
        transition = {
          days          = 1
          storage_class = "STANDARD_IA"
        }
        expiration = {
          days = 2
        }
      }
    ]
    tags = {
      usage = "temp-storage"
    }
  }
}
