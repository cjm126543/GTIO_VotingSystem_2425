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

// Instance variables for needed ECS cluster instances
module "ecs_cluster_front" {
  source                 = "./modules"
  cluster_name           = "FrontCluster"
  ecs_prefix             = "ecs-launch-template-front"
  aws_ami_id             = "ami-05712a2b73d4ebafb"
  asg_name               = "ecs-asg-front"
  aws_subnets_ids        = data.aws_subnets.default_subnets.ids
  tag_name               = "ecs-instance-front"
  capacity_provider_name = "front-capacity-provider"
  security_group_id      = data.aws_security_group.default_sec_grp.id
}

module "ecs_cluster_back" {
  source                 = "./modules"
  cluster_name           = "BackCluster"
  ecs_prefix             = "ecs-launch-template-back"
  aws_ami_id             = "ami-05712a2b73d4ebafb"
  asg_name               = "ecs-asg-back"
  aws_subnets_ids        = data.aws_subnets.default_subnets.ids
  tag_name               = "ecs-instance-back"
  capacity_provider_name = "back-capacity-provider"
  security_group_id      = data.aws_security_group.default_sec_grp.id
}

module "ecs_cluster_kong" {
  source                 = "./modules"
  cluster_name           = "KongCluster"
  ecs_prefix             = "ecs-launch-template-kong"
  aws_ami_id             = "ami-05712a2b73d4ebafb"
  asg_name               = "ecs-asg-kong"
  aws_subnets_ids        = data.aws_subnets.default_subnets.ids
  tag_name               = "ecs-instance-kong"
  capacity_provider_name = "kong-capacity-provider"
  security_group_id      = data.aws_security_group.default_sec_grp.id
}