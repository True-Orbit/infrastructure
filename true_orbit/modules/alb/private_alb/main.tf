resource "aws_security_group" "this" {
  name        = "${var.environment}-alb-sg"
  description = "Security group for ALB instance"
  vpc_id      = var.vpc_id

  tags = {
    Name = "core-alb-sg"
    env  = var.environment
    app  = "true-orbit"
  }
}

resource "aws_security_group_rule" "private_alb_allow_auth" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = var.auth_service_sg_id
  description              = "Allow HTTP traffic from auth service"
}

resource "aws_security_group_rule" "alb_sg_egress" {
  type              = "egress"
  description       = "Allow outbound traffic from the alb"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

resource "aws_lb" "this" {
  name               = "true-orbit-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "true-orbit-alb"
    env  = var.environment
    app  = "true-orbit"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "web_target_group" {
  name        = "web-service-target"
  port        = 3001
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/api/web/health"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

resource "aws_lb_listener_rule" "web_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  tags = {
    Name = "web-service-redirect"
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/api/web/*"]
    }
  }
}

resource "aws_lb_target_group" "core_server_target_group" {
  name        = "core-server-target-group"
  port        = 4000
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

resource "aws_lb_listener_rule" "api_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  tags = {
    Name = "core-server-redirect"
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.core_server_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}