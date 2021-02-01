provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_ecr_repository" "dd_agent_ecr" {
  name                 = "docker-hub/datadog/agent"
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    ProductDomain = local.product_domain
    Name          = "docker-hub/datadog/agent"
    Environment   = local.environment
    ManagedBy     = "Terraform"
  }
}

resource "aws_ecr_repository_policy" "dd_agent_ecr_policy" {
  repository = aws_ecr_repository.dd_agent_ecr.name
  policy     = data.aws_iam_policy_document.default_ecr_repository_p_doc.json
}


module "ecr_sync" {
  source                        = "../"
  environment                   = local.environment
  product_domain                = local.product_domain
  source_codecommit_name        = local.source_codecommit_name
  ecr_repo_arn                  = aws_ecr_repository.dd_agent_ecr.arn
  container_image_name          = "datadog"
  codebuild_schedule_expression = "cron(0 22 ? * 1 *)" # every Monday at 05:00 AM UTC+7
}

output "repo_name" {
  value = aws_codecommit_repository.git.repository_id
}
