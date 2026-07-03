resource "aws_cloudwatch_log_group" "this" {
  count = var.enable_cloudwatch_logs ? 1 : 0

  name              = var.cloudwatch_log_group_name != null ? var.cloudwatch_log_group_name : "/ecs/${local.name_prefix}"
  retention_in_days = var.cloudwatch_log_retention_in_days
  tags              = local.common_tags
}
