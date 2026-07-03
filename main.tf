resource "aws_ecs_cluster" "this" {
  count = var.create_cluster ? 1 : 0

  name = var.cluster_name
  tags = local.common_tags

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family != null ? var.task_family : var.service_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = tostring(var.task_cpu)
  memory                   = tostring(var.task_memory)
  execution_role_arn       = var.create_task_execution_role ? aws_iam_role.task_execution[0].arn : var.task_execution_role_arn
  task_role_arn            = var.create_task_role ? aws_iam_role.task[0].arn : var.task_role_arn

  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }

  container_definitions = jsonencode([local.container_definition])
  tags                  = local.common_tags
}

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = var.create_cluster ? aws_ecs_cluster.this[0].id : var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  platform_version                   = var.platform_version
  enable_execute_command             = var.enable_execute_command
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  health_check_grace_period_seconds  = var.target_group_arn == null ? null : var.health_check_grace_period_seconds
  propagate_tags                     = var.propagate_tags
  tags                               = local.common_tags

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.create_security_group ? [aws_security_group.service[0].id] : var.security_group_ids
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.target_group_arn == null ? [] : [var.target_group_arn]

    content {
      target_group_arn = load_balancer.value
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [
    aws_iam_role_policy_attachment.task_execution
  ]
}
