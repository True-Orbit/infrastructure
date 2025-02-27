resource "aws_ecr_repository" "core_server" {
  name = "true-orbit/auth-service"
  tags = {
    Name = "auth-service-ecr"
    app  = "true-orbit"
  }
}