output "id" {
  description = "The ID of the NAT instance"
  value       = aws_instance.nat_instance.id
}