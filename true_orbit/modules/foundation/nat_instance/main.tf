resource "aws_security_group" "nat_sg" {
  name        = "nat-sg"
  description = "Security group for NAT instance"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nat_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.nat_sg.id]

  # Enable IP forwarding and set up NAT via user data script
  user_data = <<-EOF
    #!/bin/bash
    # Enable IP forwarding
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    sysctl -p /etc/sysctl.conf
    # Set up NAT via iptables
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  EOF

  tags = {
    Name = "NAT-Instance"
  }
}