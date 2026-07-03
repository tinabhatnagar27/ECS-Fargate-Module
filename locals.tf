locals {
  name_prefix = var.name_prefix != null && var.name_prefix != "" ? var.name_prefix : var.service_name

  common_tags = merge(
    var.tags,
    {
      Terraform = "true"
      Module    = "terraform-aws-ecs-fargate"
    }
  )

  environment = [
    for key, value in var.environment : {
      name  = key
      value = value
    }
  ]

  secrets = [
    for key, value_from in var.secrets : {
      name      = key
      valueFrom = value_from
    }
  ]

  port_mappings = var.container_port == null ? [] : [
    {
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = var.container_protocol
    }
  ]

  log_configuration = var.enable_cloudwatch_logs ? {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.this[0].name
      awslogs-region        = data.aws_region.current.name
      awslogs-stream-prefix = var.container_name
    }
  } : null

  container_definition = merge(
    {
      name         = var.container_name
      image        = var.container_image
      essential    = true
      portMappings = local.port_mappings
      environment  = local.environment
      secrets      = local.secrets
    },
    var.container_cpu > 0 ? { cpu = var.container_cpu } : {},
    var.container_memory > 0 ? { memory = var.container_memory } : {},
    local.log_configuration == null ? {} : { logConfiguration = local.log_configuration },
    var.command == null ? {} : { command = var.command },
    var.entrypoint == null ? {} : { entryPoint = var.entrypoint },
    var.health_check == null ? {} : { healthCheck = var.health_check }
  )
}

data "aws_region" "current" {}
