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

module "foundation" {
  source = "./modules/foundation"
  environment = var.environment
  aws_az      = var.aws_az
}

module "ecr_core_server" {
  source = "./modules/ecr/core_server"
}

module "ecr_web" {
  source = "./modules/ecr/web"
}

module "core_server" {
  source         = "./modules/core_server"
  environment    = var.environment
  repository_url = module.ecr_core_server.repository_url
  image_tag      = var.core_server_image_tag
  vpc_id         = module.foundation.vpc_id
  ecs_cluster_id = module.foundation.ecs_cluster_id
  subnet_id      = module.foundation.private_subnet_id
}