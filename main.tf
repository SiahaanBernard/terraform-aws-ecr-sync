# Create codebuild resource
## Create codbuild IAM Role
module "aws-iam-role_codebuild" {
  source           = "github.com/traveloka/terraform-aws-iam-role//modules/service?ref=v2.0.2"
  role_identifier  = "service-role"
  role_description = "Service role for codebuild"
  aws_service      = "codebuild.amazonaws.com"
  product_domain   = var.product_domain
  environment      = var.environment
}

## Create codebuild log group
resource "aws_cloudwatch_log_group" "codebuild" {
  name              = local.codebuild_log_group_name
  retention_in_days = 14
  tags = {
    Name          = local.codebuild_log_group_name
    Description   = "Sync log of ${var.container_image_name}"
    Environment   = var.environment
    ProductDomain = var.product_domain
    ManagedBy     = "terraform"
  }
}

## Create codebuild project
resource "aws_codebuild_project" "sync" {
  name          = local.codebuild_name
  description   = "Codebuild to sync container image for ${var.container_image_name}."
  build_timeout = var.codebuild_timeout
  service_role  = module.aws-iam-role_codebuild.role_arn

  environment {
    compute_type                = var.codebuild_compute_type
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }
  artifacts {
    type = "NO_ARTIFACTS"
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.codebuild.id
    }
  }
  source {
    type            = "CODECOMMIT"
    location        = data.aws_codecommit_repository.source.clone_url_http
    buildspec       = "buildspec.yml"
    git_clone_depth = "0"

    insecure_ssl = "false"

  }
  tags = {
    Name          = module.resource-naming_cwr_scheduled.name
    Description   = "Codebuild to sync ${var.container_image_name} to ${var.ecr_repo_arn}"
    Environment   = var.environment
    ProductDomain = var.product_domain
    ManagedBy     = "terraform"
  }
}

## Create codebuild iam role policy
resource "aws_iam_role_policy" "codebuild" {
  role   = module.aws-iam-role_codebuild.role_name
  policy = data.aws_iam_policy_document.codebuild.json
}

## Create iam role for cloudwatch rule to trigger codebuild
module "aws-iam-role_cloudwatch" {
  source           = "github.com/traveloka/terraform-aws-iam-role//modules/service?ref=v2.0.2"
  role_identifier  = "service-role"
  role_description = "Service role for cloudwatch event"
  aws_service      = "events.amazonaws.com"
  product_domain   = var.product_domain
  environment      = var.environment
}

resource "aws_iam_role_policy" "cwrole_policy" {
  role   = module.aws-iam-role_cloudwatch.role_name
  policy = data.aws_iam_policy_document.cloudwatch_event.json
}

module "resource-naming_cwr_scheduled" {
  source        = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.19.1"
  name_prefix   = local.cwr_scheduled_name_prefix
  resource_type = "cloudwatch_event_rule"
}

resource "aws_cloudwatch_event_rule" "scheduled" {
  name                = module.resource-naming_cwr_scheduled.name
  description         = "event rule to run cdebuild ECR sync weekly"
  schedule_expression = var.codebuild_schedule_expression
  tags = {
    Name          = module.resource-naming_cwr_scheduled.name
    Description   = "Schedule event rule to sync ${var.container_image_name}"
    Environment   = var.environment
    ProductDomain = var.product_domain
    ManagedBy     = "terraform"
  }
}

resource "aws_cloudwatch_event_target" "scheduled" {
  rule     = module.resource-naming_cwr_scheduled.name
  role_arn = module.aws-iam-role_cloudwatch.role_arn
  arn      = aws_codebuild_project.sync.arn
}

# Create cloudwatch rule for event base merge
## Create cloudwatch rule event
module "resource-naming_cwr_event" {
  source        = "github.com/traveloka/terraform-aws-resource-naming?ref=v0.19.1"
  name_prefix   = local.cwr_event_name_prefix
  resource_type = "cloudwatch_event_rule"
}

resource "aws_cloudwatch_event_rule" "event" {
  name          = module.resource-naming_cwr_event.name
  description   = "Capture push event to code commit ${var.source_codecommit_name}"
  event_pattern = <<PATTERN
{
    "detail-type": [
        "CodeCommit Repository State Change"
    ],
    "source": [
        "aws.codecommit"
    ],
    "resources": [
        "${local.codecommit_arn}"
    ],
    "detail": {
        "event": [
            "referenceUpdated"
        ],
        "repositoryName": [
            "${var.source_codecommit_name}"
        ],
        "referenceType": [
            "branch"
        ],
        "referenceName": [
            "master"
        ],
        "referenceFullName": [
            "refs/heads/master"
        ]
    }
}
PATTERN

  tags = {
    Name          = module.resource-naming_cwr_event.name
    Description   = "Merge based event to sync ${var.container_image_name}"
    Environment   = var.environment
    ProductDomain = var.product_domain
    ManagedBy     = "terraform"
  }
}

resource "aws_cloudwatch_event_target" "event_base" {
  rule     = module.resource-naming_cwr_event.name
  role_arn = module.aws-iam-role_cloudwatch.role_arn
  arn      = aws_codebuild_project.sync.arn
}
