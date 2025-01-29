output "alb_id" {
  description = "The id of the main alb"
  value = aws_lb.main.id
}

output "alb_arn" {
  description = "alb arn"
  value = aws_lb.main.arn
}