resource "aws_ecr_repository" "this" {
  name = "true-orbit/${var.name}"
  tags = {
    name = "${var.name}-ecr"
    app  = "true-orbit"
  }
}