# Brief

You’ve been tasked with helping a team at ~redacted~ who are new to AWS and Terraform. The team
manages four services and uses a multi-account, three-stage environment model (Dev, Stage,
Prod). Each service requires an S3 bucket with appropriate permissions and tags based on their
usage. The buckets have the following requirements:

1. Bucket A and Bucket B:
• Used to host Single Page Applications (SPAs) behind CloudFront.
• Requires permissions suitable for static website hosting.
2. Bucket C:
• Used to store objects like customer signature images.
• Requires permissions ensuring the secure handling of sensitive data.
3. Bucket D:
• Acts as a temporary store for text documents.
• Objects should be ingested after 24 hours and deleted automatically after 48
hours.

The team already has pipelines, access, Terraform configurations, and remote state
management (state buckets, locking, etc.) set up.
Task: Write Terraform code to provision

# Approach

The AWS S3 module has been used to create the buckets by looping through a variable block.

`cloudfront.tf` is included as reference for how ingress to the web buckets would be handled, however it is not supported in localstack (unless you pay!) which is what has been used for testing this deployment.

# Prerequisites

This repo utilises a number of pre-commit hooks as well as a .terraform-version file for use with TF Env, you should have the following configured:

- [Pre-commit](https://pre-commit.com/)
- [Trivy](https://github.com/aquasecurity/trivy)
- [Terraform Docs](https://github.com/terraform-docs/terraform-docs)
- [TFEnv](https://github.com/tfutils/tfenv)


# Terraform Resources
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.86.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.86.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.objects](https://registry.terraform.io/providers/hashicorp/aws/5.86.1/docs/resources/kms_alias) | resource |
| [aws_kms_key.objects](https://registry.terraform.io/providers/hashicorp/aws/5.86.1/docs/resources/kms_key) | resource |
| [aws_s3_bucket_policy.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/5.86.1/docs/resources/s3_bucket_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.86.1/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/5.86.1/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/5.86.1/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.86.1/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buckets"></a> [buckets](#input\_buckets) | Map of S3 bucket configurations | <pre>map(object({<br/>    bucket_name   = string<br/>    force_destroy = optional(bool, false)<br/>    website       = optional(object({}), {})<br/><br/>    acl = string<br/><br/>    pii = optional(bool)<br/><br/>    block_public_acls       = optional(bool, true)<br/>    restrict_public_buckets = optional(bool, true)<br/><br/>    versioning = optional(object({<br/>      enabled = bool<br/>      }),<br/>      {<br/>        enabled = false<br/>    })<br/><br/>    lifecycle_rules = optional(list(object({<br/>      id      = string<br/>      enabled = bool<br/>      prefix  = string<br/>      expiration = object({<br/>        days = number<br/>      })<br/>    })), [])<br/><br/>    tags = map(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment (e.g., dev, stage, prod) | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->