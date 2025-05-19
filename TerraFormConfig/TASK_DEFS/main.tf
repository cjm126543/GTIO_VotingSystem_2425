
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

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

data "aws_iam_role" "labrole" {
  name = "LabRole"
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

variable "labrole_arn" {
  description = "ARN del IAM role para ECS tasks"
  type        = string
}

module "task_front" {
  source                    = "./modules/common"
  task_family_name          = "front-task"
  container_definition_name = "front-container"
  container_image_uri       = var.front_image
  container_ports           = [4200, 4200]
  awslogs_group             = "/ecs"
  labrole_arn = var.labrole_arn

}

module "task_back" {
  source                    = "./modules/common"
  task_family_name          = "back-task"
  container_definition_name = "back-container"
  container_image_uri       = var.back_image
  container_ports           = [8080, 8080]
  awslogs_group             = "/ecs"
  labrole_arn = var.labrole_arn
}

module "task_kong" {
  source                    = "./modules/kong"
  task_family_name          = "kong-task"
  container_definition_name = "kong-container"
  container_image_uri       = var.kong_image
  container_ports           = [8000, 8000]
  awslogs_group             = "/ecs"
  labrole_arn = var.labrole_arn
}
