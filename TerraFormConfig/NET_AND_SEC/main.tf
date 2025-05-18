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
