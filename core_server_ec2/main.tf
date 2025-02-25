terraform {
  required_version = ">= 1.10.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84.0"
    }
  }

  backend "s3" {
    bucket         = "core-ec2-state"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

locals {
  image_tag           = var.core_server_image_tag != "" ? var.core_server_image_tag : var.old_core_server_image_tag
  core_server_secrets = length(var.core_server_secrets) > 0 ? var.core_server_secrets : var.old_core_server_secrets
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "this" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_ecr_repository" "this" {
  name = "true-orbit/core-server"
}

data "aws_iam_role" "ec2_role" {
  name = "core_server_ec2_migrations"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = data.aws_iam_role.ec2_role.name
}

resource "aws_security_group" "this" {
  name   = "core_ec2_sg"
  vpc_id = data.aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "core_server" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  security_groups      = [aws_security_group.this.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
    #!/bin/bash

    # set logs
    exec > /var/log/user-data.log 2>&1
    set -x

    # Update and install Docker
    yum update -y
    amazon-linux-extras install docker -y
    yum install -y jq
    service docker start
    usermod -a -G docker ec2-user

    # Login to ECR (this command returns a Docker login command)
    $(aws ecr get-login --no-include-email --region ${var.region})

    ENV=""
    CMD="echo 'Starting Core Server'"

    %{for secret in local.core_server_secrets~}
    export ${secret.name}=$(aws secretsmanager get-secret-value --secret-id ${secret.valueFrom} --query SecretString --output text --region ${var.region})
    echo "Loaded secret ${secret.name}"
    for key in $(echo "$secret_json" | jq -r 'keys[]'); do
      value=$(echo "$secret_json" | jq -r --arg k "$key" '.[$k]')
      export "$key"="$value"
      ENV="$ENV --env $key=\"\$${key}\""
    done
    %{endfor~}
    
    if [ "${var.migrate}" = "true" ]; then
      CMD="$CMD && npm run migrate"
    fi
    if [ "${var.seed}" = "true" ]; then
      CMD="$CMD && npm run seed"
    fi

    # Pull and run the container image from ECR
    # Replace <repository_uri> and <tag> with your image details.
    CONTAINER_ID=$(docker run -d -p 4000:4000 $ENV --entrypoint /bin/sh ${local.image_tag} -c "$CMD")
  EOF

  tags = {
    Name = "EC2CoreServerMigrations"
  }
}
