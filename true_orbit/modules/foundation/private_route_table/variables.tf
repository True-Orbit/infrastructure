variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
  default     = "0.0.0.0/0"
}

variable "subnet_ids" {
  description = "The ID of the private subnet"
  type        = list(string)
}

variable "subnet_tags" {
  description = "Tags to apply to the private subnet"
  type        = map(string)
}

variable "nat_instance_primary_network_interface_id" {
  description = "The ID of the NAT instance"
  type        = string
}