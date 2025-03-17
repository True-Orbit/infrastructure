variable "name" {
  description = "The name of the Core Server"
  type        = string
}

variable "image_tag" {
  description = "The tag of the Core Server image to deploy"
  type        = string
  default     = ""
}

variable "secrets" {
  description = "The secrets"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy the Core Server into"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to deploy the Core Server into"
  type        = string
}

variable "port" {
  description = "The port the Core Server listens on"
  type        = number
}

variable "repository_name" {
  description = "The name of the ECR repository to pull the Core Server image from"
  type        = string
}

variable "migrate" {
  description = "Whether to run migrations on the Core Server"
  type        = bool
}

variable "seed" {
  description = "Whether to seed the Core Server"
  type        = bool
}

variable "rollback" {
  description = "Whether to rollback the migrations of the Core Server"
  type        = bool
}

variable "ami_id" {
  description = "The ID of the AMI to use for the Core Server"
  type        = string
  default     = "ami-000089c8d02060104"
}

variable "region" {
  default = "us-west-2"
}

variable "instance_type" {
  description = "The instance type to use for the Core Server"
  type        = string
  default     = "t3.micro"
}
