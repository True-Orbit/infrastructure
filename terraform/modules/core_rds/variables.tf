variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
}

variable "db_instance_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "username" {
  description = "The database admin username"
  type        = string
}

variable "password" {
  description = "The database admin password"
  type        = string
  sensitive   = true
}

variable "engine" {
  description = "The database engine (e.g., mysql, postgres)"
  type        = string
}

variable "engine_version" {
  description = "The database engine version"
  type        = string
}

variable "instance_class" {
  description = "The instance type for the RDS instance"
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
}

variable "storage_type" {
  description = "The storage type (e.g., gp2, io1)"
  type        = string
  default     = "gp2"
}

variable "vpc_id" {
  description = "The VPC ID where RDS will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the RDS instance"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "List of security group IDs allowed to access the RDS instance"
  type        = list(string)
}

variable "multi_az" {
  description = "Whether to deploy the RDS instance across multiple availability zones"
  type        = bool
  default     = false
}

variable "storage_encrypted" {
  description = "Whether to enable storage encryption"
  type        = bool
  default     = true
}

variable "port" {
  description = "The port on which the database accepts connections"
  type        = number
  default     = 5432
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot before deletion"
  type        = bool
  default     = true
}
