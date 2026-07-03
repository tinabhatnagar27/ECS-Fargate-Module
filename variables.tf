variable "name_prefix" {
  description = "Optional prefix for resource names. If empty, service_name will be used."
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "ECS cluster name. Required when create_cluster is true and also used for autoscaling resource id."
  type        = string
}

variable "create_cluster" {
  description = "Whether to create a new ECS cluster. If false, provide cluster_id."
  type        = bool
  default     = true
}

variable "cluster_id" {
  description = "Existing ECS cluster ID/ARN. Required when create_cluster is false."
  type        = string
  default     = null
}

variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights on ECS cluster."
  type        = bool
  default     = true
}

variable "service_name" {
  description = "ECS service name."
  type        = string
}

variable "task_family" {
  description = "Task definition family name. Defaults to service_name."
  type        = string
  default     = null
}

variable "container_name" {
  description = "Container name inside task definition."
  type        = string
  default     = "app"
}

variable "container_image" {
  description = "Docker image URL, for example nginx:latest or ECR image URI."
  type        = string
}

variable "container_port" {
  description = "Container port exposed by the application."
  type        = number
  default     = 80
}

variable "container_protocol" {
  description = "Container protocol."
  type        = string
  default     = "tcp"
}

variable "task_cpu" {
  description = "Fargate task CPU. Example: 256, 512, 1024."
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Fargate task memory in MiB. Example: 512, 1024, 2048."
  type        = number
  default     = 512
}

variable "container_cpu" {
  description = "Container-level CPU units."
  type        = number
  default     = 0
}

variable "container_memory" {
  description = "Container-level memory in MiB. Set 0 to omit hard reservation behavior at container level."
  type        = number
  default     = 0
}

variable "desired_count" {
  description = "Desired number of running tasks."
  type        = number
  default     = 1
}

variable "platform_version" {
  description = "Fargate platform version."
  type        = string
  default     = "LATEST"
}

variable "operating_system_family" {
  description = "Runtime operating system family for Fargate."
  type        = string
  default     = "LINUX"
}

variable "cpu_architecture" {
  description = "Runtime CPU architecture. Valid examples: X86_64, ARM64."
  type        = string
  default     = "X86_64"
}

variable "vpc_id" {
  description = "VPC ID for ECS service security group."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where ECS Fargate tasks will run. Prefer private subnets with NAT for production."
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign public IP to Fargate tasks. Use true only for public subnet testing."
  type        = bool
  default     = false
}

variable "create_security_group" {
  description = "Whether to create a security group for the ECS service."
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "Existing security group IDs when create_security_group is false."
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "Security group IDs allowed to access container_port. Usually ALB security group ID."
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access container_port. For quick testing use your IP/32, not 0.0.0.0/0 in production."
  type        = list(string)
  default     = []
}

variable "target_group_arn" {
  description = "Optional ALB/NLB target group ARN. If provided, service attaches to this target group. Target group target_type must be ip for Fargate."
  type        = string
  default     = null
}

variable "health_check_grace_period_seconds" {
  description = "Grace period for load balancer health checks."
  type        = number
  default     = 60
}

variable "deployment_minimum_healthy_percent" {
  description = "Lower limit on healthy tasks during deployment."
  type        = number
  default     = 50
}

variable "deployment_maximum_percent" {
  description = "Upper limit on running tasks during deployment."
  type        = number
  default     = 200
}

variable "enable_execute_command" {
  description = "Enable ECS Exec on the service."
  type        = bool
  default     = false
}

variable "propagate_tags" {
  description = "Whether to propagate tags from SERVICE or TASK_DEFINITION."
  type        = string
  default     = "SERVICE"
}

variable "environment" {
  description = "Environment variables for container as key-value map."
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secrets for container as key-value map. Value must be Secrets Manager or SSM Parameter ARN/name supported by ECS."
  type        = map(string)
  default     = {}
}

variable "command" {
  description = "Optional command override for container."
  type        = list(string)
  default     = null
}

variable "entrypoint" {
  description = "Optional entrypoint override for container."
  type        = list(string)
  default     = null
}

variable "health_check" {
  description = "Optional ECS container health check object."
  type = object({
    command     = list(string)
    interval    = optional(number)
    timeout     = optional(number)
    retries     = optional(number)
    startPeriod = optional(number)
  })
  default = null
}

variable "enable_cloudwatch_logs" {
  description = "Create CloudWatch log group and configure awslogs driver."
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_name" {
  description = "Optional CloudWatch log group name. Defaults to /ecs/name_prefix."
  type        = string
  default     = null
}

variable "cloudwatch_log_retention_in_days" {
  description = "CloudWatch log retention in days."
  type        = number
  default     = 7
}

variable "create_task_execution_role" {
  description = "Create ECS task execution IAM role."
  type        = bool
  default     = true
}

variable "task_execution_role_arn" {
  description = "Existing task execution role ARN when create_task_execution_role is false."
  type        = string
  default     = null
}

variable "create_task_role" {
  description = "Create ECS task role for application AWS permissions."
  type        = bool
  default     = true
}

variable "task_role_arn" {
  description = "Existing task role ARN when create_task_role is false."
  type        = string
  default     = null
}

variable "task_role_policy_json" {
  description = "Optional inline IAM policy JSON for created task role."
  type        = string
  default     = ""
}

variable "enable_autoscaling" {
  description = "Enable ECS service autoscaling."
  type        = bool
  default     = false
}

variable "autoscaling_min_capacity" {
  description = "Minimum task count for autoscaling."
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum task count for autoscaling."
  type        = number
  default     = 3
}

variable "enable_cpu_autoscaling" {
  description = "Enable CPU target tracking scaling policy."
  type        = bool
  default     = true
}

variable "cpu_target_value" {
  description = "Target average CPU utilization percentage."
  type        = number
  default     = 70
}

variable "enable_memory_autoscaling" {
  description = "Enable memory target tracking scaling policy."
  type        = bool
  default     = false
}

variable "memory_target_value" {
  description = "Target average memory utilization percentage."
  type        = number
  default     = 75
}

variable "scale_in_cooldown" {
  description = "Scale in cooldown in seconds."
  type        = number
  default     = 300
}

variable "scale_out_cooldown" {
  description = "Scale out cooldown in seconds."
  type        = number
  default     = 60
}

variable "tags" {
  description = "Common tags for all supported resources."
  type        = map(string)
  default     = {}
}
