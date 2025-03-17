output "id" {
  description = "The id of the this alb"
  value       = aws_lb.this.id
}

output "arn" {
  description = "The arn of the this alb"
  value       = aws_lb.this.arn
}

output "listener_arn" {
  description = "The arn of the this alb http listener"
  value       = aws_lb_listener.http.arn
}

output "dns_name" {
  value = aws_lb.this.dns_name
}

output "zone_id" {
  value = aws_lb.this.zone_id
}