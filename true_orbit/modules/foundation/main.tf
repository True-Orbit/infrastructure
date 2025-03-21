resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "true-orbit-vpc"
    app  = "true-orbit"
    env  = var.environment
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "main-internet-gateway"
  }
}

module "public_subnet_a" {
  source      = "./subnet"
  name        = "a"
  cidr_block  = var.public_subnet_cidr_block1
  aws_az      = var.aws_az
  environment = var.environment
  aws_vpc_id  = aws_vpc.this.id
  public      = true
}

module "route_table_public_a" {
  source      = "./public_route_table"
  vpc_id      = aws_vpc.this.id
  gateway_id  = aws_internet_gateway.gw.id
  subnet_tags = module.public_subnet_a.tags
  subnet_id   = module.public_subnet_a.id
}

module "nat_gateway_a" {
  source      = "./nat_gateway"
  subnet_id   = module.public_subnet_a.id
  subnet_tags = module.public_subnet_a.tags
}

module "route_table_private_a" {
  source         = "./private_route_table"
  vpc_id         = aws_vpc.this.id
  nat_gateway_id = module.nat_gateway_a.id
  subnet_tags    = module.private_subnet_a.tags
  subnet_id      = module.private_subnet_a.id
}

module "private_subnet_a" {
  source      = "./subnet"
  name        = "a"
  cidr_block  = var.private_subnet_cidr_block1
  aws_az      = var.aws_az
  environment = var.environment
  aws_vpc_id  = aws_vpc.this.id
  public      = false
}

module "public_subnet_b" {
  source      = "./subnet"
  name        = "b"
  cidr_block  = var.public_subnet_cidr_block2
  aws_az      = var.aws_az2
  environment = var.environment
  aws_vpc_id  = aws_vpc.this.id
  public      = true
}

module "route_table_public_b" {
  source      = "./public_route_table"
  vpc_id      = aws_vpc.this.id
  gateway_id  = aws_internet_gateway.gw.id
  subnet_tags = module.public_subnet_b.tags
  subnet_id   = module.public_subnet_b.id
}

module "nat_gateway_b" {
  source      = "./nat_gateway"
  subnet_id   = module.public_subnet_b.id
  subnet_tags = module.public_subnet_b.tags
}

module "route_table_private_b" {
  source         = "./private_route_table"
  vpc_id         = aws_vpc.this.id
  nat_gateway_id = module.nat_gateway_b.id
  subnet_tags    = module.private_subnet_b.tags
  subnet_id      = module.private_subnet_b.id
}

module "private_subnet_b" {
  source      = "./subnet"
  name        = "b"
  cidr_block  = var.private_subnet_cidr_block2
  aws_az      = var.aws_az2
  environment = var.environment
  aws_vpc_id  = aws_vpc.this.id
  public      = false
}

resource "aws_ecs_cluster" "this" {
  name = "true-orbit-${var.environment}-ecs-cluster"

  tags = {
    Name        = "ecs-cluster"
    app         = "true-orbit"
    environment = var.environment
  }
}