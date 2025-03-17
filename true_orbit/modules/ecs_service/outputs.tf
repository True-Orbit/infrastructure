output "sg_id" {
  description = "The ID of the security group"
  value       = aws_security_group.this.id
}

output "target_group_arns" {
  value = aws_lb_target_group.this[*].arn
}