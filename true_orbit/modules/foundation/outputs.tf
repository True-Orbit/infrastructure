output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_a_id" {
  description = "The ID of the public subnet"
  value       = module.public_subnet_a.id
}

output "public_subnet_b_id" {
  description = "The ID of the public subnet"
  value       = module.public_subnet_b.id
}

output "private_subnet_a_id" {
  description = "The ID of the private subnet"
  value       = module.private_subnet_a.id
}

output "private_subnet_b_id" {
  description = "The ID of the private subnet"
  value       = module.private_subnet_b.id
}

output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.this.id
}
