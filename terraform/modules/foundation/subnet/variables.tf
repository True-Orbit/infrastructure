variable "name" {
  type = string
  description = "name"
}

variable "cidr_block" {
  type = string
  description = "cidr block"
}

variable "aws_az" {
  type        = string
  description = "AWS availability zone"
}

variable "environment" {
  type = string
  description = "app environment"
}

variable "aws_vpc_id" {
  type = string
  description = "VPC ID"
}

variable "public" {
  type = bool
  description = "public"
}
