output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name."
  value       = aws_lb.this.dns_name
}

output "alb_url" {
  description = "Application URL."
  value       = "http://${aws_lb.this.dns_name}"
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = module.ecs_fargate.cluster_name
}

output "ecs_service_name" {
  description = "ECS service name."
  value       = module.ecs_fargate.service_name
}

output "ecs_task_definition_arn" {
  description = "ECS task definition ARN."
  value       = module.ecs_fargate.task_definition_arn
}
