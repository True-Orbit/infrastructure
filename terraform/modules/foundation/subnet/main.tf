locals {
  sector = var.public ? "public" : "private"
}

resource "aws_subnet" "this" {
  vpc_id                  = var.aws_vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.aws_az
  map_public_ip_on_launch = var.public

  tags = {
    Name        = "true-orbit-${local.sector}-subnet-${var.name}"
    app         = "true-orbit"
    az          = var.aws_az
    environment = var.environment
    sector      = local.sector
  }
}