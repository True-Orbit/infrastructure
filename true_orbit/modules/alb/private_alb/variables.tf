variable "environment" {
  description = "The environment name"
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "subnet_ids" {
  description = "subnet ids"
  type        = list(string)
}

variable "ecs_cluster_id" {
  description = "ecs cluster id"
  type        = string
}

variable "auth_service_sg_id" {
  description = "auth service security group id"
  type        = string
}