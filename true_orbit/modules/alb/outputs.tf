output "alb_id" {
  description = "The id of the main alb"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "The arn of the main alb"
  value       = aws_lb.main.arn
}

output "alb_listener_arn" {
  description = "The arn of the main alb listener"
  value       = aws_lb_listener.https.arn
}

output "web_target_group_arn" {
  description = "The ARN of the target group for the web service"
  value       = aws_lb_target_group.web_target_group.arn
}

output "core_server_target_group_arn" {
  description = "The ARN of the target group for the core server"
  value       = aws_lb_target_group.core_server_target_group.arn
}