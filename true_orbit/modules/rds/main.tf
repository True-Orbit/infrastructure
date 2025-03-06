data "aws_secretsmanager_secret_version" "db_secret" {
  secret_id = var.secrets_arn
}

locals {
  secrets        = jsondecode(data.aws_secretsmanager_secret_version.db_secret.secret_string)
  db_name        = local.secrets.dbname
  rds_identifier = local.secrets.dbInstanceIdentifier
  port           = local.secrets.port
  db_user        = local.secrets.username
  db_password    = local.secrets.password
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-rds-subnet-group"
    app  = "true-orbit"
    env  = var.environment
  }
}

resource "aws_security_group" "this" {
  name        = "${var.environment}-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-rds-sg"
    env  = var.environment
    app  = "true-orbit"
  }
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  description       = "Allow inbound on port ${local.port} for ${var.name} server"
  from_port         = local.port
  to_port           = local.port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

resource "aws_db_instance" "this" {
  identifier             = local.rds_identifier
  engine                 = "postgres"
  engine_version         = "17.2"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = "gp2"
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  publicly_accessible    = false
  multi_az               = var.multi_az
  storage_encrypted      = var.storage_encrypted
  username               = local.db_user
  password               = local.db_password
  db_name                = local.db_name
  port                   = local.port
  skip_final_snapshot    = var.environment != "production"

  tags = {
    env  = var.environment
    app  = "true-orbit"
    Name = "${var.name}-rds-instance"
  }
}
