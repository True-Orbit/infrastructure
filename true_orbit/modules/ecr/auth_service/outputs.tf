output "id" {
  description = "The ID of the ECR registry"
  value       = aws_ecr_repository.core_server.id
}

output "url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.core_server.repository_url
}