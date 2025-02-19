locals {
  kebab_name = trimspace(replace(lower(var.name), " ", "-"))
}

resource "aws_security_group" "this" {
  name        = "true-orbit-${var.environment}-${local.kebab_name}-sg"
  description = "${local.kebab_name} security group for ECS tasks"
  vpc_id      = var.vpc_id

  tags = {
    name = "${local.kebab_name}-sg"
    env  = var.environment
    app  = "true-orbit"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.us-west-2.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [var.subnet_id]

  security_group_ids = [aws_security_group.this.id]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.us-west-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [var.subnet_id]

  security_group_ids = [aws_security_group.this.id]
}

resource "aws_security_group_rule" "http_ingress" {
  type              = "ingress"
  description       = "Allow inbound on port ${var.port} for the ${var.name}"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.ingress_cidr_blocks
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "http_egress" {
  type              = "egress"
  description       = "Allow outbound on port ${var.port} for the ${var.name}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${local.kebab_name}"
  retention_in_days = 30
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${local.kebab_name}-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_iam_role_arn
  task_role_arn            = var.ecs_iam_role_arn

  container_definitions = jsonencode([
    {
      name  = "${local.kebab_name}-container"
      image = var.image_tag
      portMappings = [
        {
          name          = "true-orbit-${local.kebab_name}-tcp"
          appProtocol   = "http"
          containerPort = var.port
        }
      ]

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:${var.port}${var.health_check_path} || exit 1"]
        interval    = 30 
        timeout     = 5  
        retries     = 3  
        startPeriod = 60  
      }

      secrets = var.secrets

      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          "awslogs-group"         = aws_cloudwatch_log_group.this.name
          "awslogs-region"        = "us-west-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = local.kebab_name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE" 

  network_configuration {
    subnets         = [var.subnet_id]
    security_groups = [aws_security_group.this.id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${local.kebab_name}-container"
    container_port   = var.port
  }
}