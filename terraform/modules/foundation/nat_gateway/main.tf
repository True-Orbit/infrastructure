locals {
  sector = var.subnet_tags["sector"]
  environment = var.subnet_tags["environment"]
  app = var.subnet_tags["app"]
  az = var.subnet_tags["az"]
  subnet_name = var.subnet_tags["Name"]
}

resource "aws_eip" "this" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-${local.subnet_name}"
    sector = local.sector
    environment = local.environment
    app = local.app
    az = local.az
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = var.subnet_id

  tags = {
    Name = "nat-gateway-${local.subnet_name}"
    sector = local.sector
    environment = local.environment
    app = local.app
    az = local.az
  }
}