variable "name" {
  description = "The name of the service"
  type        = string
}

variable "image_tag" {
  description = "The tag for the Docker image"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "repository_url" {
  description = "The URL of the ECR repository"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., development, production)"
  type        = string
}

variable "desired_count" {
  description = "The number of instances to launch"
  type        = number
  default     = 1
}

variable "ecs_iam_role_arn" {
  description = "The ARN of the ECS task execution role"
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the target group"
  type        = string
}

variable "port" {
  description = "The port the container listens on"
  type        = number
}

variable "ingress_cidr_blocks" {
  description = "The CIDR block to allow ingress from"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "secrets" {
  description = "The secrets to pass to the container"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "health_check_path" {
  description = "The path to use for the health check"
  type        = string
  default     = "/health"
}

variable "cpu" {
  description = "The amount of CPU to allocate to the container"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "The amount of memory to allocate to the container"
  type        = string
  default     = "512"
}

variable "alb_listener_arn" {
  description = "The listener for the load balancer"
  type        = string
}

variable "alb_priority" {
  description = "Where should this priority be placed in the listener"
  type        = string
}