variable "image_tag" {
  description = "The tag for the Docker image"
  type        = string
  default     = "latest"
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