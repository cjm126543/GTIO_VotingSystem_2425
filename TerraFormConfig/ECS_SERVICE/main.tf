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

// Locate default VPC and security group
data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_security_group" "default_sec_grp" {
  name = "default"
}

// Default subnets
data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

// Locate ECS clusters
data "aws_ecs_cluster" "front_ecs" {
  cluster_name = "FrontCluster"
}

data "aws_ecs_cluster" "back_ecs" {
  cluster_name = "BackCluster"
}

data "aws_ecs_cluster" "kong_ecs" {
  cluster_name = "KongCluster"
}

// Locate target groups and listeners
data "aws_lb_target_group" "front_tgn" {
  name = "front-tgn"
}

data "aws_lb_target_group" "back_tgn" {
  name = "back-tgn"
}

data "aws_lb_target_group" "kong_tgn" {
  name = "kong-tgn"
}

data "aws_lb" "front_alb" {
  name = "front-alb"
}

data "aws_lb" "back_alb" {
  name = "back-alb"
}

data "aws_lb_listener" "front_listener" {
  load_balancer_arn = data.aws_lb.front_alb.arn
  port              = 4200
}

data "aws_lb_listener" "kong_listener" {
  load_balancer_arn = data.aws_lb.front_alb.arn
  port              = 8000
}

data "aws_lb_listener" "back_listener" {
  load_balancer_arn = data.aws_lb.back_alb.arn
  port              = 8080
}

// Declare ECS clusters services
module "front_service" {
  source           = "./modules"
  service_name     = "front-service"
  task_family_name = "front-task"
  //task_revision     = "LATEST"
  cluster_id        = data.aws_ecs_cluster.front_ecs.arn
  subnet_ids        = data.aws_subnets.default_subnets.ids
  security_group_id = data.aws_security_group.default_sec_grp.id
  target_group_arn  = data.aws_lb_target_group.front_tgn.arn
  container_name    = "front-container"
  container_port    = 4200
  alb_listener      = data.aws_lb_listener.front_listener
}

module "kong_service" {
  source           = "./modules"
  service_name     = "kong-service"
  task_family_name = "kong-task"
  //task_revision     = "LATEST"
  cluster_id        = data.aws_ecs_cluster.kong_ecs.arn
  subnet_ids        = data.aws_subnets.default_subnets.ids
  security_group_id = data.aws_security_group.default_sec_grp.id
  target_group_arn  = data.aws_lb_target_group.kong_tgn.arn
  container_name    = "kong-container"
  container_port    = 8000
  alb_listener      = data.aws_lb_listener.kong_listener
}

module "back_service" {
  source           = "./modules"
  service_name     = "back-service"
  task_family_name = "back-task"
  //task_revision     = "LATEST"
  cluster_id        = data.aws_ecs_cluster.back_ecs.arn
  subnet_ids        = data.aws_subnets.default_subnets.ids
  security_group_id = data.aws_security_group.default_sec_grp.id
  target_group_arn  = data.aws_lb_target_group.back_tgn.arn
  container_name    = "back-container"
  container_port    = 8080
  alb_listener      = data.aws_lb_listener.back_listener
}