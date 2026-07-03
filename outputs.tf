output "cluster_id" {
  description = "ECS cluster ID."
  value       = var.create_cluster ? aws_ecs_cluster.this[0].id : var.cluster_id
}

output "cluster_name" {
  description = "ECS cluster name."
  value       = var.cluster_name
}

output "service_id" {
  description = "ECS service ID."
  value       = aws_ecs_service.this.id
}

output "service_name" {
  description = "ECS service name."
  value       = aws_ecs_service.this.name
}

output "task_definition_arn" {
  description = "Task definition ARN."
  value       = aws_ecs_task_definition.this.arn
}

output "task_execution_role_arn" {
  description = "Task execution role ARN."
  value       = var.create_task_execution_role ? aws_iam_role.task_execution[0].arn : var.task_execution_role_arn
}

output "task_role_arn" {
  description = "Task role ARN."
  value       = var.create_task_role ? aws_iam_role.task[0].arn : var.task_role_arn
}

output "security_group_id" {
  description = "ECS service security group ID."
  value       = var.create_security_group ? aws_security_group.service[0].id : null
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group name."
  value       = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.this[0].name : null
}
