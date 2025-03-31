variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet"
  type        = string
}

variable "ami_id" {
  description = "The ID of the AMI to use for the NAT instance"
  type        = string
  default     = "ami-000089c8d02060104"
}

variable "instance_type" {
  description = "The instance type of the NAT instance"
  type        = string
  default     = "t3.micro"
}