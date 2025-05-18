terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

// Declare AWS provider
provider "aws" {
  region = "us-east-1"
}

// Locate default VPC, subnets, security group and target group and alb ARNs
data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

data "aws_security_group" "default_sec_grp" {
  name = "default"
}

data "aws_lb_target_group" "front_tgn" {
  name = "front-tgn"
}

data "aws_lb_target_group" "back_tgn" {
  name = "back-tgn"
}

data "aws_lb_target_group" "kong_tgn" {
  name = "kong-tgn"
}

//data "aws_lb" "front_alb_data" {
//  name = "front-alb"
//}
//
//data "aws_lb" "back_alb_data" {
//  name = "back-alb"
//}

// Instance variables for needed ALB and listener instances
module "front_alb" {
  source             = "./modules/alb_config"
  load_balancer_name = "front-alb"
  security_group_id  = data.aws_security_group.default_sec_grp.id
  subnet_ids         = data.aws_subnets.default_vpc_subnets.ids
}

module "back_alb" {
  source             = "./modules/alb_config"
  load_balancer_name = "back-alb"
  security_group_id  = data.aws_security_group.default_sec_grp.id
  subnet_ids         = data.aws_subnets.default_vpc_subnets.ids
}

module "front_listener" {
  source           = "./modules/listener_config"
  alb_arn          = module.front_alb.arn
  lb_port          = 4200
  target_group_arn = data.aws_lb_target_group.front_tgn.arn
}

module "kong_listener" {
  source           = "./modules/listener_config"
  alb_arn          = module.front_alb.arn
  lb_port          = 8000
  target_group_arn = data.aws_lb_target_group.kong_tgn.arn
}

module "back_listener" {
  source           = "./modules/listener_config"
  alb_arn          = module.back_alb.arn
  lb_port          = 8080
  target_group_arn = data.aws_lb_target_group.back_tgn.arn
}