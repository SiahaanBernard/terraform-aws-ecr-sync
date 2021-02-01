output "codebuild_id" {
  description = "The name of codebuild project."
  value       = aws_codebuild_project.sync.id
}

output "codebuild_arn" {
  description = "The ARN of the codebuild project."
  value       = aws_codebuild_project.sync.arn
}

output "codebuild_iam_role_name" {
  description = "IAM Role name for the codebuild."
  value       = module.aws-iam-role_codebuild.role_name
}

output "codebuild_iam_role_arn" {
  description = "IAM Role ARN for the codebuild."
  value       = module.aws-iam-role_codebuild.role_arn
}

output "codebuild_log_group_arn" {
  description = "Log group for the codebuild."
  value       = aws_cloudwatch_log_group.codebuild.arn
}
