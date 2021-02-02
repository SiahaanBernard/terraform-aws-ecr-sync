# Terraform AWS ECR Sync

## Table of Content

- [Terraform AWS ECR Sync](#terraform-aws-ecr-sync)
  - [Table of Content](#table-of-content)
  - [Dependencies](#dependencies)
  - [Quick Start](#quick-start)
    - [Examples](#examples)
  - [Requirements](#requirements)
  - [Providers](#providers)
  - [Inputs](#inputs)
  - [Outputs](#outputs)

## Dependencies
You need to create or have:
- [Codecommit Repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_repository)
- [Elastic Container Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository)


## Quick Start
Terraform module to create infrastructure system to automatically do synchronization between 3rd party container registry, with AWS Elastic Container Registry.

By default, this module create a codebuild and cloudwatch event. Cloudwatch event will trigger codebuild to do synchronization of container images, either regularly, or everytime master branch get a new update.

### Examples
- [Simple](examples/)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| codebuild\_compute\_type | Type of compute or spec for codebuild. | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| codebuild\_image | Type of image that will be used to run build job. | `string` | `"aws/codebuild/standard:4.0"` | no |
| codebuild\_schedule\_expression | Cron expression to set scheduled trigger for codebuild. Leave it empty to disable | `string` | `""` | no |
| codebuild\_timeout | Timeout for codebuild in minutes | `string` | `"120"` | no |
| container\_image\_name | Name of the container images to be sync. | `string` | n/a | yes |
| ecr\_repo\_arn | ARN of ECR Repository. | `string` | n/a | yes |
| environment | Environment of the infrastructure | `string` | n/a | yes |
| product\_domain | Product domain who own this infrastructure. | `string` | n/a | yes |
| source\_codecommit\_name | Name of the codecommit, which stre buildspec for codebuild. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| codebuild\_arn | The ARN of the codebuild project. |
| codebuild\_iam\_role\_arn | IAM Role ARN for the codebuild. |
| codebuild\_iam\_role\_name | IAM Role name for the codebuild. |
| codebuild\_id | The name of codebuild project. |
| codebuild\_log\_group\_arn | Log group for the codebuild. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->