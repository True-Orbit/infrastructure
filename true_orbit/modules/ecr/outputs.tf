output "registry_id" {
  description = "The ID of the ECR registry"
  value       = aws_ecr_repository.this.id
}

output "repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.this.repository_url
}