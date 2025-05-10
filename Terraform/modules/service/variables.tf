variable "name" {}
variable "container_port" {}
variable "image" {}
variable "path" {}
variable "ecs_cluster_id" {}
variable "subnets" { type = list(string) }
variable "sg_id" {}
variable "role_arn" {}
variable "aws_region" {
  default = "us-east-1"
}
variable "vpc_id" {
  default = aws_vpc.main.id
}
