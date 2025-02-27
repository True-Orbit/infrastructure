output "alb_id" {
  description = "The id of the main alb"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "The arn of the main alb"
  value       = aws_lb.main.arn
}

output "sg_id" {
  description = "The id of the security group"
  value       = aws_security_group.this.id
}

output "auth_service_target_group_arn" {
  description = "The ARN of the target group for the auth service"
  value       = aws_lb_target_group.auth_service.arn
}
