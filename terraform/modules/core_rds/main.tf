locals {
  db_name = "${var.environment}-${var.db_name}"
  rds_identifier = "${var.environment}-${var.rds_identifier}"
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    name = "core-rds-subnet-group"
    app  = "true-orbit"
    env  = var.environment
  }
}

resource "aws_security_group" "core_rds_sg" {
  name        = "${var.environment}-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  tags = {
    name = "core-rds-sg"
    env  = var.environment
    app  = "true-orbit"
  }
}

resource "aws_security_group_rule" "core_rds_sg_ingress" {
  type              = "ingress"
  description       = "Allow inbound on port 5432 for core server"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.core_rds_sg.id
}

resource "aws_db_instance" "core-rds" {
  identifier              = local.rds_identifier
  engine                  = "postgres"
  engine_version          = "17.2"
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = "gp2"
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.core_rds_sg.id]
  publicly_accessible     = false
  multi_az                = var.multi_az
  storage_encrypted       = var.storage_encrypted
  username                = var.CORE_RDS_USERNAME
  password                = var.CORE_RDS_PASSWORD
  db_name                 = local.db_name
  port                    = var.port
  skip_final_snapshot     = var.environment == "production"

  tags = {
    env = var.environment
    app = "true-orbit"
    name = "core-rds-instance"
  }
}
