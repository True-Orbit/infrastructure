resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.environment}-db-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.environment}-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow access from ECS tasks"
    from_port        = 4000
    to_port          = 4000
    protocol         = "tcp"
    security_groups  = var.allowed_security_group_ids
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "true-orbit-${var.environment}-rds-sg"
    Environment = var.environment
  }
}

resource "aws_db_instance" "core-rds" {
  identifier              = var.db_instance_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.security_group_ids
  publicly_accessible     = false
  multi_az                = var.multi_az
  storage_encrypted       = var.storage_encrypted
  username                = var.username
  password                = var.password
  db_name                 = var.db_name
  port                    = var.port
  skip_final_snapshot     = var.skip_final_snapshot

  tags = {
    Environment = var.environment
  }
}
