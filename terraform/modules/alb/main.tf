resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  description = "Security group for ALB instance"
  vpc_id      = var.vpc_id

  tags = {
    name = "core-alb-sg"
    env  = var.environment
    app  = "true-orbit"
  }
}

resource "aws_security_group_rule" "alb_sg_ingress" {
  type              = "ingress"
  description       = "Allow inbound traffic to the app"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_lb" "main" {
  name               = "true-orbit-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    name = "true-orbit-alb"
    env  = var.environment
    app  = "true-orbit"
  }
}

resource "aws_route53_record" "true_orbit_alb" {
  zone_id = var.dns_zone_id
  name    = var.dns_name
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}