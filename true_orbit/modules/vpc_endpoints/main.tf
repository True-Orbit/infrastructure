resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc-endpoint-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow inbound HTTPS from ECS tasks"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = var.sg_ids
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-endpoint-sg"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.us-west-2.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids

  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  tags = {
    Name = "ecr-api"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.us-west-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids

  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  tags = {
    Name = "ecr-dkr"
  }
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.us-west-2.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids

  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "secretsmanager"
  }
}