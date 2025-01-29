locals { 
  port = 3000
}

resource "aws_security_group" "web_sg" {
  name        = "true-orbit-${var.environment}-web-sg"
  description = "web security group for ECS tasks"
  vpc_id      = var.vpc_id

  tags = {
    name = "web-sg"
    env  = var.environment
    app  = "true-orbit"
  }
}

resource "aws_security_group_rule" "http_ingress" {
  type              = "ingress"
  description       = "Allow inbound on port ${local.port} for the web service"
  from_port         = local.port
  to_port           = local.port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "http_egress" {
  type              = "egress"
  description       = "Allow outbound on port ${local.port} for the web service"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_ecs_task_definition" "web_task" {
  family                   = "web-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_iam_role_arn

  container_definitions = jsonencode([
    {
      name  = "web-container"
      image = "${var.repository_url}:${var.environment}-${var.image_tag}"
      portMappings = [
        {
          containerPort = local.port
        }
      ]
    }
  ])
}

resource "aws_lb_target_group" "web_target_group" {
  name        = "service-target"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = var.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn 
  }
}

resource "aws_ecs_service" "web_service" {
  name            = "web-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.web_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE" 

  network_configuration {
    subnets         = [var.subnet_id]
    security_groups = [aws_security_group.web_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web_target_group.arn
    container_name   = "web-container"
    container_port   = 80
  }
}
