resource "aws_security_group" "service" {
  count = var.create_security_group ? 1 : 0

  name        = "${local.name_prefix}-ecs-sg"
  description = "Security group for ECS Fargate service ${var.service_name}"
  vpc_id      = var.vpc_id
  tags        = merge(local.common_tags, { Name = "${local.name_prefix}-ecs-sg" })
}

resource "aws_security_group_rule" "ingress_from_allowed_sg" {
  count = var.create_security_group ? length(var.allowed_security_group_ids) : 0

  type                     = "ingress"
  from_port                = var.container_port
  to_port                  = var.container_port
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_group_ids[count.index]
  security_group_id        = aws_security_group.service[0].id
  description              = "Allow traffic from allowed security groups"
}

resource "aws_security_group_rule" "ingress_from_cidr" {
  for_each = var.create_security_group ? toset(var.allowed_cidr_blocks) : toset([])

  type              = "ingress"
  from_port         = var.container_port
  to_port           = var.container_port
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.service[0].id
  description       = "Allow traffic from allowed CIDR"
}

resource "aws_security_group_rule" "egress" {
  count = var.create_security_group ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.service[0].id
  description       = "Allow all outbound traffic"
}
