variable "environment" {
  type        = string
  description = "Name of the environment (e.g. development, staging, production)"
  default     = "development"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}

variable "aws_az" {
  type        = string
  description = "AWS availability zone"
  default     = "us-west-2a"
}

variable "core_server_image_tag" {
  type        = string
  description = "The tag for the Docker image"
  default     = "latest"
}

variable "web_service_image_tag" {
  type        = string
  description = "The tag for the Docker image"
  default     = "latest"
}

variable "core_rds_username" {
  description = "The database admin username"
  type        = string
}

variable "core_rds_password" {
  description = "The database admin password"
  type        = string
  sensitive   = true
}
