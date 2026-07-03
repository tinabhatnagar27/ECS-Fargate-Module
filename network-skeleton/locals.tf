data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name_prefix = "${var.environment}-${var.project_name}"
  azs         = slice(data.aws_availability_zones.available.names, 0, 2)

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Terraform   = "true"
  }
}