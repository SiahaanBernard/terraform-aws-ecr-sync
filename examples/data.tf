data "aws_iam_policy_document" "default_ecr_repository_p_doc" {
  statement {
    sid    = "AllowPullAccessFomAWSOrg"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:ListImages",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"

      values = [
        "${local.aws_org_id}",
      ]
    }
  }
}
