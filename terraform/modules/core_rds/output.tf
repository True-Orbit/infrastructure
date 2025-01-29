output "rds_instance" {
  description = "The name of the RDS instance"
  value       = aws_db_instance.core-rds
}