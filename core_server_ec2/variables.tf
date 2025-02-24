variable "core_server_image_tag" {
  description = "The tag of the Core Server image to deploy"
  type        = string
  default     = ""
}

variable "old_core_server_image_tag" {
  description = "The currently deployed Core Server image tag"
  type        = string
}

variable "core_server_secrets" {
  description = "The secrets"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "old_core_server_secrets" {
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
  default     = "ami-027951e78de46a00e"
}

variable "instance_type" {
  description = "The instance type to use for the Core Server"
  type        = string
  default     = "t3.micro"
}

variable "migrate" {
  description = "Whether to run migrations on the Core Server"
  type        = bool
  default     = false
}

variable "seed" {
  description = "Whether to seed the Core Server"
  type        = bool
  default     = false
}