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

resource "aws_security_group_rule" "alb_sg_https_ingress" {
  type              = "ingress"
  description       = "Allow inbound traffic to the alb"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
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

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-west-2:267135861046:certificate/62020be6-6e65-4ef5-85cc-cd57381f7c9f"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth_service.arn
  }
}

resource "aws_lb_target_group" "auth_service" {
  name        = "auth-service-target"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

resource "aws_route53_record" "true_orbit_alb" {
  zone_id = var.dns_zone_id
  name    = var.dns_name
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}