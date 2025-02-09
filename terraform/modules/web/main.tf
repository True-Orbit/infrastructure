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

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.us-west-2.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [var.subnet_id]

  security_group_ids = [aws_security_group.web_sg.id]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.us-west-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [var.subnet_id]

  security_group_ids = [aws_security_group.web_sg.id]
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

resource "aws_security_group_rule" "https_ingress" {
  type              = "ingress"
  description       = "Allow inbound https on port 443 for the web service"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "http_egress" {
  type              = "egress"
  description       = "Allow outbound on port ${local.port} for the web service"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_cloudwatch_log_group" "web_service_log_group" {
  name              = "/ecs/web-service"
  retention_in_days = 30
}

resource "aws_ecs_task_definition" "web_task" {
  family                   = "web-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_iam_role_arn
  task_role_arn            = var.ecs_iam_role_arn

  container_definitions = jsonencode([
    {
      name  = "web-container"
      image = var.image_tag
      portMappings = [
        {
          name          = "true-orbit-web-3000-tcp"
          appProtocol   = "http"
          containerPort = local.port
        }
      ]

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000/api/health || exit 1"]
        interval    = 30 
        timeout     = 5  
        retries     = 3  
        startPeriod = 60  
      }

      secrets = [
        {
          name      = "OAUTH_GITHUB_ID"
          valueFrom = "arn:aws:secretsmanager:us-west-2:267135861046:secret:true-orbit/web/development-3TtfMZ"
        },
        {
          name      = "OAUTH_GITHUB_SECRET"
          valueFrom = "arn:aws:secretsmanager:us-west-2:267135861046:secret:true-orbit/web/development-3TtfMZ"
        },
        {
          name      = "OAUTH_GOOGLE_CLIENT_ID"
          valueFrom = "arn:aws:secretsmanager:us-west-2:267135861046:secret:true-orbit/web/development-3TtfMZ"
        },
        {
          name      = "OAUTH_GOOGLE_CLIENT_SECRET"
          valueFrom = "arn:aws:secretsmanager:us-west-2:267135861046:secret:true-orbit/web/development-3TtfMZ"
        },
        {
          name      = "NEXTAUTH_SECRET"
          valueFrom = "arn:aws:secretsmanager:us-west-2:267135861046:secret:true-orbit/web/development-3TtfMZ"
        },
        {
          name      = "NEXTAUTH_URL"
          valueFrom = "arn:aws:secretsmanager:us-west-2:267135861046:secret:true-orbit/web/development-3TtfMZ"
        },
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          "awslogs-group"         = aws_cloudwatch_log_group.web_service_log_group.name
          "awslogs-region"        = "us-west-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_lb_target_group" "web_target_group" {
  name        = "web-service-target"
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

resource "aws_lb_listener" "web_service" {
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

resource "aws_lb_listener_rule" "web_rule" {
  listener_arn = aws_lb_listener.web_service.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/web*", "/web/*"]
    }
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
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web_target_group.arn
    container_name   = "web-container"
    container_port   = local.port
  }
}