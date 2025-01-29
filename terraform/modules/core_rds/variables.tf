variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
}

variable "rds_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
  default     = "core-rds-instance"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "Core"
}

variable "instance_class" {
  description = "The instance type for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
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

variable "core_rds_username" {
  description = "The database admin username"
  type        = string
}

variable "core_rds_password" {
  description = "The database admin password"
  type        = string
  sensitive   = true
}
