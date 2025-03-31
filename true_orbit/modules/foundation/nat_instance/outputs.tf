output "primary_network_interface_id" {
  description = "The ID of the NAT instance"
  value       = aws_instance.nat_instance.primary_network_interface_id
}

output "nat_instance_sg_id" {
  description = "The ID of the NAT instance security group"
  value       = aws_security_group.nat_sg.id
}