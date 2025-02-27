output "sg_id" {
  description = "The id of the security group"
  value       = aws_security_group.this.id
}