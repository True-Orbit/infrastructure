resource "aws_ecr_repository" "core_server" {
  name = "true-orbit/core-server"
  tags = {
    name = "core-server-ecr"
    app = "true-orbit"
  }
}