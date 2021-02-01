data "aws_region" "current" {}

data "aws_codecommit_repository" "source" {
  repository_name = "${var.source_codecommit_name}"
}
data "aws_iam_policy_document" "codebuild" {
  statement {
    sid    = "AllowToPushContainerImagesToECR"
    effect = "Allow"
    actions = [
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:BatchGetImage"
    ]
    resources = [
      var.ecr_repo_arn
    ]
  }
  statement {
    sid    = "AllowAccessToPushLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.codebuild.arn}/*"
    ]
  }
  statement {

  }
}

data "aws_iam_policy_document" "cloudwatch_event" {
  statement {
    sid    = "AllowToStartCodeBuild"
    effect = "Allow"
    actions = [
      "codebuild:StartBuild"
    ]
    resources = [
      aws_codebuild_project.sync.arn
    ]
  }
}
