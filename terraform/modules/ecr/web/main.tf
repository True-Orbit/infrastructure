resource "aws_ecr_repository" "web" {
  name = "true-orbit/web"
  tags = {
    name = "web-ecr"
    app = "true-orbit"
  }
}