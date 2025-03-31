output "primary_network_interface_id" {
  description = "The ID of the NAT instance"
  value       = aws_instance.nat_instance.primary_network_interface_id
}