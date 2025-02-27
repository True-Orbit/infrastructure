terraform {
  required_version = ">= 1.10.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84.0"
    }
  }

  backend "s3" {
    bucket         = "true-orbit-infrastructure"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

data "terraform_remote_state" "current_images" {
  backend = "s3"
  config = {
    bucket         = "true-orbit-infrastructure"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

locals {
  web_array_of_secrets     = jsondecode(var.web_service_secrets)
  old_web_array_of_secrets = jsondecode(var.old_web_service_secrets)
  web_image_tag            = var.web_service_image_tag != "" ? "${module.ecr_web.repository_url}:${var.web_service_image_tag}" : var.old_web_service_image_tag
  web_service_secrets      = local.web_array_of_secrets != null ? local.web_array_of_secrets : local.old_web_array_of_secrets
}

locals {
  core_array_of_secrets     = jsondecode(var.core_server_secrets)
  old_core_array_of_secrets = jsondecode(var.old_core_server_secrets)
  core_server_image_tag     = var.core_server_image_tag != "" ? "${module.ecr_core_server.repository_url}:${var.core_server_image_tag}" : var.old_core_server_image_tag
  core_server_secrets       = local.core_array_of_secrets != null ? local.core_array_of_secrets : local.old_core_array_of_secrets
}

locals {
  auth_array_of_secrets     = jsondecode(var.auth_service_secrets)
  old_auth_array_of_secrets = jsondecode(var.old_auth_service_secrets)
  auth_service_image_tag     = var.auth_service_image_tag != "" ? "${module.ecr_auth_service.repository_url}:${var.auth_service_image_tag}" : var.old_auth_service_image_tag
  auth_service_secrets       = local.auth_array_of_secrets != null ? local.auth_array_of_secrets : local.old_auth_array_of_secrets
}

provider "aws" {
  region = var.aws_region
}

module "iam" {
  source = "./modules/iam"
}

module "domain" {
  source = "./modules/route53"
}

module "foundation" {
  source      = "./modules/foundation"
  environment = var.environment
  aws_az      = var.aws_az
}

module "ecr_auth_service" {
  source = "./modules/ecr/auth_service"
}

module "ecr_core_server" {
  source = "./modules/ecr/core_server"
}

module "ecr_web" {
  source = "./modules/ecr/web"
}

module "public_alb" {
  source         = "./modules/alb/public_alb"
  environment    = var.environment
  vpc_id         = module.foundation.vpc_id
  subnet_ids     = [module.foundation.public_subnet_a_id, module.foundation.public_subnet_b_id]
  ecs_cluster_id = module.foundation.ecs_cluster_id
  dns_name       = module.domain.dns_name
  dns_zone_id    = module.domain.dns_zone_id
}

module "alb_waf" {
  source  = "./modules/waf"
  alb_arn = module.public_alb.alb_arn
}

module "auth_service" {
  source            = "./modules/ecs_service"
  name              = "Auth Service"
  environment       = var.environment
  repository_url    = module.ecr_auth_service.url
  image_tag         = local.auth_service_image_tag
  vpc_id            = module.foundation.vpc_id
  ecs_cluster_id    = module.foundation.ecs_cluster_id
  subnet_id         = module.foundation.private_subnet_a_id
  ecs_iam_role_arn  = module.iam.ecs_role_arn
  target_group_arn  = module.public_alb.auth_service_target_group_arn
  port              = 3000
  health_check_path = "/health"
  secrets           = local.auth_service_secrets
}

module "private_alb" {
  source         = "./modules/alb/private_alb"
  environment    = var.environment
  vpc_id         = module.foundation.vpc_id
  subnet_ids     = [module.foundation.private_subnet_a_id, module.foundation.private_subnet_b_id]
  ecs_cluster_id = module.foundation.ecs_cluster_id
  auth_service_sg_id = module.auth_service.sg_id
}

module "core_rds" {
  source      = "./modules/core_rds"
  environment = var.environment
  vpc_id      = module.foundation.vpc_id
  subnet_ids  = [module.foundation.private_subnet_a_id, module.foundation.private_subnet_b_id]
}

module "core_server" {
  source            = "./modules/ecs_service"
  name              = "Core Server"
  environment       = var.environment
  repository_url    = module.ecr_core_server.url
  image_tag         = local.core_server_image_tag
  vpc_id            = module.foundation.vpc_id
  ecs_cluster_id    = module.foundation.ecs_cluster_id
  subnet_id         = module.foundation.private_subnet_a_id
  ecs_iam_role_arn  = module.iam.ecs_role_arn
  target_group_arn  = module.private_alb.core_server_target_group_arn
  port              = 4000
  health_check_path = "/api/health"
  secrets           = local.core_server_secrets
}

module "web_service" {
  source            = "./modules/ecs_service"
  name              = "Web Service"
  environment       = var.environment
  repository_url    = module.ecr_web.url
  image_tag         = local.web_image_tag
  vpc_id            = module.foundation.vpc_id
  ecs_cluster_id    = module.foundation.ecs_cluster_id
  subnet_id         = module.foundation.private_subnet_a_id
  ecs_iam_role_arn  = module.iam.ecs_role_arn
  target_group_arn  = module.private_alb.web_target_group_arn
  port              = 3000
  health_check_path = "/api/web/health"
  secrets           = local.web_service_secrets
}