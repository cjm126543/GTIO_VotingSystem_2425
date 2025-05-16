variable "load_balancer_name" {}
variable "security_group_id" {}
variable "subnet_ids" {
  type    = list(string)
}
variable "alb_arn" {}
variable "lb_port" {}
variable "target_group_arn" {}