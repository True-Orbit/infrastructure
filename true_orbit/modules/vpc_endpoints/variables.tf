variable "vpc_id" {
  description = "The VPC ID to create the endpoint in"
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets"
  type        = list(string)
}

variable "sg_ids" {
  description = "The IDs of the security groups"
  type        = list(string)
}