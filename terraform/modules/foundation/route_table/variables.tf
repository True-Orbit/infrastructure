variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
  default    = "0.0.0.0/0"
}

variable "nat_gateway_id" {
  description = "The ID of the NAT gateway"
  type        = string
}

variable "private_subnet_id" {
  description = "The ID of the private subnet"
  type        = string
}

variable "subnet_tags" {
  description = "Tags to apply to the private subnet"
  type        = map(string)
}