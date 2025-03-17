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

variable "region" {
  default = "us-west-2"
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy the Core Server into"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to deploy the Core Server into"
  type        = string
}

variable "ami_id" {
  description = "The ID of the AMI to use for the Core Server"
  type        = string
  default     = "ami-000089c8d02060104"
}

variable "s3_bucket" {
  description = "The name of the S3 bucket to store the Terraform state file"
  type        = string
}

variable "repository_name" {
  description = "The name of the ECR repository to pull the Core Server image from"
  type        = string
}

variable "log_group" {
  description = "The name of the CloudWatch Log Group to use for the Core Server"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the Core Server"
  type        = string
  default     = "t3.micro"
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