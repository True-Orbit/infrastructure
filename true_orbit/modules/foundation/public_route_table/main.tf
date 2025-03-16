locals {
  subnet_name = var.subnet_tags["Name"]
  sector      = var.subnet_tags["sector"]
  environment = var.subnet_tags["environment"]
  app         = var.subnet_tags["app"]
  az          = var.subnet_tags["az"]
}

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.cidr_block
    gateway_id = var.gateway_id
  }

  tags = {
    Name        = "${local.sector}-route-table-${local.subnet_name}"
    sector      = local.sector
    environment = local.environment
    app         = local.app
    az          = local.az
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.this.id
}
