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

variable "front_image" {
  description = "URI completa de la imagen frontend"
  type        = string
}

variable "back_image" {
  description = "URI completa de la imagen backend"
  type        = string
}

variable "kong_image" {
  description = "URI completa de la imagen kong"
  type        = string
}

module "task_front" {
  source                    = "./modules"
  task_family_name          = "front-task"
  container_definition_name = "front-container"
  container_image_uri       = var.front_image
  container_ports           = [4200, 4200]
  awslogs_group             = "/ecs"
}

module "task_back" {
  source                    = "./modules"
  task_family_name          = "back-task"
  container_definition_name = "back-container"
  container_image_uri       = var.back_image
  container_ports           = [8080, 8080]
  awslogs_group             = "/ecs"
}

module "task_kong" {
  source                    = "./modules"
  task_family_name          = "kong-task"
  container_definition_name = "kong-container"
  container_image_uri       = var.kong_image
  container_ports           = [8000, 8000]
  awslogs_group             = "/ecs"
}
