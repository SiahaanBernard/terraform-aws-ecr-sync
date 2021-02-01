locals {
  codebuild_name            = "tsiecrs-${var.container_image_name}"
  codebuild_log_group_name  = "/aws/codebuild/${local.codebuild_name}"
  cwr_event_name_prefix     = "${var.source_codecommit_name}-merge-to-master"
  cwr_scheduled_name_prefix = "${local.codebuild_name}-scheduled"
  codecommit_arn            = "arn:aws:codecommit::${data.aws_region.current.name}:${var.source_codecommit_name}"
}
