variable "core_server_image_tag" {
  description = "The tag of the Core Server image to deploy"
  type        = string
  default     = ""
}

variable "current_core_server_image_tag" {
  description = "The currently deployed Core Server image tag"
  type        = string
}

variable "core_server_secrets_arn" {
  description = "The secrets"
  type        = string
  default     = null
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
  default    = "ami-0c94855ba95c71c99"
}

variable "instance_type" {
  description = "The instance type to use for the Core Server"
  type        = string
  default     = "t3.micro"
}