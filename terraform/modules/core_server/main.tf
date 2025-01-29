locals { 
  port = 4000
}

resource "aws_security_group" "core_server_sg" {
  name        = "true-orbit-${var.environment}-core-server-sg"
  description = "core-server security group for ECS tasks"
  vpc_id      = var.vpc_id

  tags = {
    name = "core-server-sg"
    env  = var.environment
    app  = "true-orbit"
  }
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

resource "aws_security_group_rule" "http_egress" {
  type              = "egress"
  description       = "Allow outbount on any port"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.core_server_sg.id
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
      image = "${var.repository_url}:${var.environment}-${var.image_tag}"
      portMappings = [
        {
          containerPort = local.port
        }
      ]
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
  }
}
