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

// Instance variables for needed target groups
module "target_group_front" {
  source             = "./modules"
  target_group_name  = "front-tgn"
  target_port        = 4200
  aws_vpc_default_id = data.aws_vpc.default_vpc.id
}

module "target_group_back" {
  source             = "./modules"
  target_group_name  = "back-tgn"
  target_port        = 8080
  aws_vpc_default_id = data.aws_vpc.default_vpc.id
}

module "target_group_kong" {
  source             = "./modules"
  target_group_name  = "kong-tgn"
  target_port        = 8000
  aws_vpc_default_id = data.aws_vpc.default_vpc.id
}