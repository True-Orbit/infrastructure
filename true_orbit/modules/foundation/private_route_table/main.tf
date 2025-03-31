locals {
  sector      = "private"
  subnet_name = var.subnet_tags["Name"]
  environment = var.subnet_tags["environment"]
  app         = var.subnet_tags["app"]
  az          = var.subnet_tags["az"]
}

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${local.sector}-route-table"
    sector      = local.sector
    environment = local.environment
    app         = local.app
    az          = local.az
  }
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = var.nat_instance_primary_network_interface_id
}

resource "aws_route_table_association" "private_subnet_association" {
  for_each       = { for id in var.subnet_ids : id => id }
  subnet_id      = each.value
  route_table_id = aws_route_table.this.id
}