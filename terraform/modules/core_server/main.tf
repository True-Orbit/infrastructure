locals { 
  port = 4000
}

resource "aws_security_group" "core_server_sg" {
  name        = "true-orbit-${var.environment}-core-server-sg"
  description = "core-server security group for ECS tasks"
  vpc_id      = var.vpc_id

  tags = {
    Name = "core-server-sg"
    env  = var.environment
    app  = "true-orbit"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.us-west-2.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [var.subnet_id]

  security_group_ids = [aws_security_group.core_server_sg.id]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.us-west-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [var.subnet_id]

  security_group_ids = [aws_security_group.core_server_sg.id]
}

resource "aws_security_group_rule" "http_ingress" {
  type              = "ingress"
  description       = "Allow inbound on port ${local.port} for core server"
  from_port         = local.port
  to_port           = local.port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.core_server_sg.id
}

resource "aws_security_group_rule" "https_ingress" {
  type              = "ingress"
  description       = "Allow inbound https traffic on port 433 for core server"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.core_server_sg.id
}

resource "aws_security_group_rule" "http_egress" {
  type              = "egress"
  description       = "Allow outbound on any port"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.core_server_sg.id
}

resource "aws_cloudwatch_log_group" "core_server_log_group" {
  name              = "/ecs/core-server"
  retention_in_days = 30
}

resource "aws_ecs_task_definition" "core_server_task" {
  family                   = "core-server-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_iam_role_arn

  container_definitions = jsonencode([
    {
      name  = "core-server"
      image = var.image_tag
      portMappings = [
        {
          containerPort = local.port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          "awslogs-group"         = aws_cloudwatch_log_group.core_server_log_group.name
          "awslogs-region"        = "us-west-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "core_server_service" {
  name            = "core-server-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.core_server_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE" 

  network_configuration {
    subnets         = [var.subnet_id]
    security_groups = [aws_security_group.core_server_sg.id]
    assign_public_ip = true
  }
}