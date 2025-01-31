terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 1.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  vpc_id              = var.include_networking && length(module.vpc) > 0 ? module.vpc[0].vpc_id : var.vpc_id
  subnet_a_id         = var.include_networking && length(module.subnets) > 0 ? module.subnets[0].subnet_a_id : var.subnet_a_id
  subnet_b_id         = var.include_networking && length(module.subnets) > 0 ? module.subnets[0].subnet_b_id : var.subnet_b_id
  security_group_id   = var.include_networking && length(module.security_group) > 0 ? module.security_group[0].security_group_id : var.security_group_id
  internet_gateway_id = var.include_networking && length(module.internet_gateway) > 0 ? module.internet_gateway[0].internet_gateway_id : var.internet_gateway_id
}

module "s3" {
  source = "./s3"
  app_name = var.app_name
}

module "vpc" {
  source  = "./vpc"
  count   = var.include_networking ? 1 : 0
}

module "subnets" {
  source = "./subnet"
  vpc_id = local.vpc_id
  aws_region = var.aws_region
  count   = var.include_networking ? 1 : 0
}

module "internet_gateway" {
  source = "./igw"
  vpc_id = local.vpc_id
  count  = var.include_networking ? 1 : 0
}

module "route_table" {
  source = "./rts"
  vpc_id = local.vpc_id
  subnet_a_id = local.subnet_a_id
  subnet_b_id = local.subnet_b_id
  count = var.include_networking ? 1 : 0
  internet_gateway_id = local.internet_gateway_id
}

module "security_group" {
  source = "./sg"
  vpc_id = local.vpc_id
  count   = var.include_networking ? 1 : 0
}

module "ecr" {
  source = "./ecr"
  app_name = var.app_name
  aws_region = var.aws_region
}

module "task_definition" {
  source = "./td"
  app_name = var.app_name
  aws_region = var.aws_region
  env_file = module.s3.env_file
  repository_url = module.ecr.repository_url
  depends_on = [module.s3]
}

module target_group {
  source = "./tg"
  app_name = var.app_name
  vpc_id = local.vpc_id
}

module load_balancer {
  source = "./lb"
  app_name = var.app_name
  subnet_a_id = local.subnet_a_id
  subnet_b_id = local.subnet_b_id
  target_group_arn = module.target_group.target_group_arn
  security_group_id = local.security_group_id
}

module ecs {
  source = "./ecs"
  app_name = var.app_name
  subnet_a_id = local.subnet_a_id
  subnet_b_id = local.subnet_b_id
  target_group_arn = module.target_group.target_group_arn
  security_group_id = local.security_group_id
  task_definition_arn = module.task_definition.task_definition_arn
}
