module "ecs_fargate" {
  source = "../"

  name_prefix = local.name_prefix

  cluster_name    = "${local.name_prefix}-cluster"
  service_name    = "${local.name_prefix}-service"
  container_name  = "app"
  container_image = var.container_image
  container_port  = var.container_port

  vpc_id     = aws_vpc.this.id
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  assign_public_ip = false

  target_group_arn           = aws_lb_target_group.app.arn
  allowed_security_group_ids = [aws_security_group.alb.id]

  task_cpu      = 256
  task_memory   = 512
  desired_count = 2

  enable_autoscaling       = true
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 3
  enable_cpu_autoscaling   = true
  cpu_target_value         = 70

  tags = local.common_tags

  depends_on = [aws_lb_listener.http]
}