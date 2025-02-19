resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
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
  source = "./subnet"
  name = "a"
  cidr_block = var.public_subnet_cidr_block1
  aws_az = var.aws_az
  environment = var.environment
  aws_vpc_id = aws_vpc.this.id
  public = true
}

module "public_subnet_b" {
  source = "./subnet"
  name = "b"
  cidr_block = var.public_subnet_cidr_block2
  aws_az = var.aws_az2
  environment = var.environment
  aws_vpc_id = aws_vpc.this.id
  public = true
}

module "private_subnet_a" {
  source = "./subnet"
  name = "a"
  cidr_block = var.private_subnet_cidr_block1
  aws_az = var.aws_az
  environment = var.environment
  aws_vpc_id = aws_vpc.this.id
  public = false
}

module "private_subnet_b" {
  source = "./subnet"
  name = "b"
  cidr_block = var.private_subnet_cidr_block1
  aws_az = var.aws_az2
  environment = var.environment
  aws_vpc_id = aws_vpc.this.id
  public = false
}

resource "aws_ecs_cluster" "this" {
  name = "true-orbit-${var.environment}-ecs-cluster"

  tags = {
    Name        = "ecs-cluster"
    app         = "true-orbit"
    environment = var.environment
  }
}