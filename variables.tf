variable "source_codecommit_name" {
  description = "Name of the codecommit, which stre buildspec for codebuild."
  type        = string
}

variable "product_domain" {
  description = "Product domain who own this infrastructure."
  type        = string
}

variable "environment" {
  description = "Environment of the infrastructure"
  type        = string
}

variable "codebuild_timeout" {
  description = "Timeout for codebuild in minutes"
  type        = string
  default     = "120"
}

variable "codebuild_compute_type" {
  description = "Type of compute or spec for codebuild."
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_image" {
  description = "Type of image that will be used to run build job."
  type        = string
  default     = "aws/codebuild/standard:4.0"
}

variable "ecr_repo_arn" {
  description = "ARN of ECR Repository."
  type        = string
}

variable "container_image_name" {
  description = "Name of the container images to be sync."
  type        = string
}

variable "codebuild_schedule_expression" {
  description = "Cron expression to set scheduled trigger for codebuild. Leave it empty to disable"
  type        = string
  default     = ""
}
