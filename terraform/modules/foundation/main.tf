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

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_block1
  availability_zone       = var.aws_az
  map_public_ip_on_launch = true

  tags = {
    Name = "true-orbit-public-subnet-a"
    az   = var.aws_az
    app  = "true-orbit"
    env  = var.environment
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_block2
  availability_zone       = var.aws_az2
  map_public_ip_on_launch = true

  tags = {
    Name = "true-orbit-public-subnet-b"
    az   = var.aws_az2
    app  = "true-orbit"
    env  = var.environment
  }
}


resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidr_block1
  availability_zone       = var.aws_az
  map_public_ip_on_launch = false

  tags = {
    Name        = "true-orbit-private-subnet-a"
    app         = "true-orbit"
    az          = var.aws_az
    environment = var.environment
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidr_block2
  availability_zone       = var.aws_az2
  map_public_ip_on_launch = false

  tags = {
    Name        = "true-orbit-private-subnet-b"
    app         = "true-orbit"
    az          = var.aws_az2
    environment = var.environment
  }
}

resource "aws_ecs_cluster" "this" {
  name = "true-orbit-${var.environment}-ecs-cluster"

  tags = {
    Name        = "ecs-cluster"
    app         = "true-orbit"
    environment = var.environment
  }
}