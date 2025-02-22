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
}

variable "old_core_server_image_tag" {
  type        = string
  description = "The tag for the old Docker image"
}

variable "core_server_secrets" {
  description = "The secrets to pass to the container"
  type = string
  default = null
}

variable "old_core_server_secrets" {
  description = "The secrets to pass to the container"
  type = string
  default = null
}

variable "web_service_image_tag" {
  type        = string
  description = "The tag for the Docker image"
}

variable "old_web_service_image_tag" {
  type        = string
  description = "The tag for the old Docker image"
}

variable "web_service_secrets" {
  description = "The secrets to pass to the container"
  type = string
  default = null
}

variable "old_web_service_secrets" {
  description = "The secrets to pass to the container"
  type = string
  default = null
}
