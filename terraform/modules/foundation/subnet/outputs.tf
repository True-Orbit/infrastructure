output "id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.this.id
}

output "tags" {
  description = "The tags of the private subnet"
  value       = aws_subnet.this.tags
}