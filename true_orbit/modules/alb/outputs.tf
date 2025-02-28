output "alb_id" {
  description = "The id of the main alb"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "The arn of the main alb"
  value       = aws_lb.main.arn
}

output "listener_arn" {
  description = "The arn of the main alb listener"
  value       = aws_lb_listener.https.arn
}