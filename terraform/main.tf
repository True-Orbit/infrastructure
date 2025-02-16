terraform {
  required_version = ">= 1.10.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84.0"
    }
  }

  backend "s3" {
    bucket = "true-orbit-infrastructure"
    key    = "terraform.tfstate"
    region = "us-west-2"
    encrypt = true
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
  possible_core_server_image_tag = var.core_server_image_tag != "" ? "${module.ecr_core_server.repository_url}:${var.core_server_image_tag}" : var.old_core_server_image_tag
  core_server_image_tag = (local.possible_core_server_image_tag != null && trimspace(local.possible_core_server_image_tag) != "") ? local.possible_core_server_image_tag : error("core_server_image_tag is empty or null.")

  possible_web_image_tag         = var.web_service_image_tag != "" ? "${module.ecr_web.repository_url}:${var.web_service_image_tag}" : var.old_web_service_image_tag
  web_image_tag = (local.possible_web_image_tag != null && trimspace(local.possible_web_image_tag) != "") ? local.possible_web_image_tag : error("web_image_tag is empty or null.")
}

provider "aws" {
  region = var.aws_region
}

module "iam" {
  source = "./modules/iam"
}

module "s3" {
  source = "./modules/s3"
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
  logs_bucket = module.s3.alb_logs_bucket

  depends_on = [module.s3]
}

module "alb_waf" {
  source = "./modules/waf"
  alb_arn = module.alb.alb_arn
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
  image_tag        = local.core_server_image_tag
  vpc_id           = module.foundation.vpc_id
  ecs_cluster_id   = module.foundation.ecs_cluster_id
  subnet_id        = module.foundation.private_subnet_a_id
  ecs_iam_role_arn = module.iam.ecs_role_arn
}

module "web_service" {
  source           = "./modules/web"
  environment      = var.environment
  repository_url   = module.ecr_web.repository_url
  image_tag        = local.web_image_tag
  vpc_id           = module.foundation.vpc_id
  ecs_cluster_id   = module.foundation.ecs_cluster_id
  subnet_id        = module.foundation.private_subnet_a_id
  ecs_iam_role_arn = module.iam.ecs_role_arn
  target_group_arn = module.alb.web_target_group_arn
}