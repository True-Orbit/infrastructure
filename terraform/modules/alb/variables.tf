variable "environment" {
  description = "The environment name"
}

variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "subnet_ids" {
  description = "subnet ids"
  type = list(string)
}

variable "ecs_cluster_id" {
  description = "ecs cluster id"
  type = string
}

variable "dns_name" {
  description = "dns name"
  type = string
}

variable "dns_zone_id" {
  description = "dns zone id"
  type = string
}