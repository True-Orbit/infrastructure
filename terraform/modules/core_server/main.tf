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
      image = var.image_tag
      portMappings = [
        {
          containerPort = local.port
        }
      ]
    }
  ])
}

resource "aws_lb_target_group" "core_server_target_group" {
  name        = "service-target"
  port        = local.port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/api/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "core_server" {
  load_balancer_arn = var.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "api_rule" {
  listener_arn = aws_lb_listener.core_server.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.core_server_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/api*", "/api/*"]
    }
  }
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