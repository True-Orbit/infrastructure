terraform {
  required_version = ">= 1.10.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84.0"
    }
  }
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
  source = "./modules/foundation"
  environment = var.environment
  aws_az      = var.aws_az
}

module "alb" {
  source = "./modules/alb"
  environment = var.environment
  vpc_id = module.foundation.vpc_id
  subnet_ids = [module.foundation.public_subnet_a_id, module.foundation.public_subnet_b_id]
  ecs_cluster_id = module.foundation.ecs_cluster_id
  dns_name = module.domain.dns_name
  dns_zone_id = module.domain.dns_zone_id
}

module "ecr_core_server" {
  source = "./modules/ecr/core_server"
}

module "ecr_web" {
  source = "./modules/ecr/web"
}

module "core_rds" {
  source = "./modules/core_rds"
  environment = var.environment
  vpc_id = module.foundation.vpc_id
  subnet_ids = [module.foundation.private_subnet_a_id, module.foundation.private_subnet_b_id]
  core_rds_username = var.core_rds_username
  core_rds_password = var.core_rds_password
}

module "core_server" {
  source           = "./modules/core_server"
  environment      = var.environment
  repository_url   = module.ecr_core_server.repository_url
  image_tag        = var.core_server_image_tag
  vpc_id           = module.foundation.vpc_id
  ecs_cluster_id   = module.foundation.ecs_cluster_id
  subnet_id        = module.foundation.private_subnet_a_id
  ecs_iam_role_arn = module.iam.ecs_role_arn
}

module "web_service" {
  source           = "./modules/web"
  environment      = var.environment
  repository_url   = module.ecr_web.repository_url
  image_tag        = var.core_server_image_tag
  vpc_id           = module.foundation.vpc_id
  ecs_cluster_id   = module.foundation.ecs_cluster_id
  subnet_id        = module.foundation.private_subnet_a_id
  alb_arn          = module.alb.alb_arn
  ecs_iam_role_arn = module.iam.ecs_role_arn
}