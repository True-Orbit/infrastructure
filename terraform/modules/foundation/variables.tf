variable "environment" {
  type        = string
  description = "Name of the environment (e.g. development, staging, production)"
  default     = "development"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}

variable "aws_az" {
  type        = string
  description = "AWS availability zone"
  default     = "us-west-2a"
}

variable "aws_az2" {
  type        = string
  description = "AWS availability zone"
  default     = "us-west-2b"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block1" {
  type        = string
  description = "CIDR block for the api gateway public subnet"
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_block2" {
  type        = string
  description = "CIDR block for the api gateway public subnet"
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_block1" {
  type        = string
  description = "CIDR block for the core services private subnet"
  default     = "10.0.16.0/24"
}

variable "private_subnet_cidr_block2" {
  type        = string
  description = "CIDR block for the core services private subnet"
  default     = "10.0.17.0/24"
}