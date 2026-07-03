# Terraform AWS ECS Fargate Module

This Terraform module creates an AWS ECS Fargate service with:

- ECS Cluster
- ECS Task Definition
- ECS Service using Fargate
- IAM Task Execution Role
- IAM Task Role
- CloudWatch Log Group
- ECS Service Security Group
- Optional ALB/NLB target group attachment
- Optional CPU/Memory autoscaling

## Architecture

```text
ECR/Docker Image
      ↓
ECS Task Definition
      ↓
ECS Service - Fargate
      ↓
Private/Public Subnets
      ↓
Optional ALB Target Group
      ↓
CloudWatch Logs
```

## Usage

```hcl
provider "aws" {
  region = "ap-south-1"
}

module "ecs_fargate" {
  source = "./terraform-aws-ecs-fargate"

  cluster_name    = "dev-ecs-cluster"
  service_name    = "nginx-service"
  container_name  = "nginx"
  container_image = "nginx:latest"
  container_port  = 80

  vpc_id     = "vpc-xxxxxxxx"
  subnet_ids = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]

  # For quick public subnet testing only.
  assign_public_ip     = true
  allowed_cidr_blocks  = ["YOUR_PUBLIC_IP/32"]

  task_cpu       = 256
  task_memory    = 512
  desired_count  = 1

  tags = {
    ENV     = "dev"
    OWNER   = "devops"
    PROJECT = "ecs-fargate"
  }
}
```

## Usage with existing ALB target group

> For Fargate, the target group must use `target_type = "ip"`.

```hcl
module "ecs_fargate" {
  source = "./terraform-aws-ecs-fargate"

  cluster_name    = "dev-ecs-cluster"
  service_name    = "app-service"
  container_name  = "app"
  container_image = "123456789012.dkr.ecr.ap-south-1.amazonaws.com/app:latest"
  container_port  = 8080

  vpc_id     = "vpc-xxxxxxxx"
  subnet_ids = ["subnet-private-1", "subnet-private-2"]

  assign_public_ip            = false
  target_group_arn            = "arn:aws:elasticloadbalancing:ap-south-1:123456789012:targetgroup/app-tg/abc123"
  allowed_security_group_ids  = ["sg-albxxxxxxxx"]

  task_cpu      = 512
  task_memory   = 1024
  desired_count = 2
}
```

## Test Commands

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

## Important Notes

1. For production, use private subnets with NAT Gateway and put ALB in public subnets.
2. For quick testing, you can use public subnets with `assign_public_ip = true`.
3. If using an ALB target group with Fargate, target group type must be `ip`, not `instance`.
4. Task CPU and memory must follow valid Fargate combinations.
5. If your app image is private ECR, the task execution role is required.

## Inputs

| Name | Description | Default |
|------|-------------|---------|
| cluster_name | ECS cluster name | required |
| create_cluster | Create ECS cluster | true |
| cluster_id | Existing ECS cluster ID/ARN if create_cluster=false | null |
| service_name | ECS service name | required |
| container_image | Docker image | required |
| container_port | Container port | 80 |
| task_cpu | Fargate task CPU | 256 |
| task_memory | Fargate task memory | 512 |
| desired_count | Desired task count | 1 |
| vpc_id | VPC ID | required |
| subnet_ids | ECS task subnet IDs | required |
| assign_public_ip | Assign public IP to task | false |
| target_group_arn | Optional ALB/NLB target group ARN | null |
| enable_autoscaling | Enable service autoscaling | false |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | ECS cluster ID |
| service_name | ECS service name |
| task_definition_arn | Task definition ARN |
| task_execution_role_arn | Execution role ARN |
| task_role_arn | Task role ARN |
| security_group_id | ECS service security group ID |
| cloudwatch_log_group_name | CloudWatch log group name |
