resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  tags = {
    name = "vpc"
    app = "true-orbit"
    env = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.aws_az
  map_public_ip_on_launch = true
  tags = {
    name = "public-subnet"
    app = "true-orbit"
    env = var.environment
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = var.aws_az  
  map_public_ip_on_launch = false

  tags = {
    name = "true-orbit-private-subnet"
    app = "true-orbit"
    environment = var.environment
  }
}

resource "aws_ecs_cluster" "this" {
  name = "true-orbit-${var.environment}-ecs-cluster"
  tags = {
    name = "ecs-cluster"
    app = "true-orbit"
    environment = var.environment
  }
}