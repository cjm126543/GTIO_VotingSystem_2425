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

// Instance variables for needed task definitions
module "task_front" {
  source                    = "./modules"
  task_family_name          = "front-task"
  container_definition_name = "front-container"
  // this needs to be retrieved from CD
  container_image_uri = "468406663760.dkr.ecr.us-east-1.amazonaws.com/carlos/repo:front-latest"
  container_ports     = [4200, 4200]
  awslogs_group       = "/ecs"
}

module "task_back" {
  source                    = "./modules"
  task_family_name          = "back-task"
  container_definition_name = "back-container"
  // this needs to be retrieved from CD
  container_image_uri = "468406663760.dkr.ecr.us-east-1.amazonaws.com/carlos/repo:back-latest"
  container_ports     = [8080, 8080]
  awslogs_group       = "/ecs"
}

module "task_kong" {
  source                    = "./modules"
  task_family_name          = "kong-task"
  container_definition_name = "kong-container"
  // this needs to be retrieved from CD
  container_image_uri = "468406663760.dkr.ecr.us-east-1.amazonaws.com/carlos/repo:kong-latest"
  container_ports     = [8000, 8000]
  awslogs_group       = "/ecs"
}