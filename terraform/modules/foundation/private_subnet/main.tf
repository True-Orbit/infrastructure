resource "aws_subnet" "this" {
  vpc_id                  = var.aws_vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.aws_az
  map_public_ip_on_launch = false

  tags = {
    Name        = "true-orbit-private-subnet-${var.name}"
    app         = "true-orbit"
    az          = var.aws_az
    environment = var.environment
  }
}