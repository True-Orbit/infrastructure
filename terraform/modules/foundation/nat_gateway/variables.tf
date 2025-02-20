variable "subnet_id" {
  description = "The ID of the public subnet"
  type        = string
}

variable "subnet_tags" {
  description = "Tags to apply to the subnet"
  type        = map(string)
}