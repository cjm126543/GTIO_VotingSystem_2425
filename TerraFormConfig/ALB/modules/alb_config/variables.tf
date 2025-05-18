variable "load_balancer_name" {}
variable "security_group_id" {}
variable "subnet_ids" {
  type    = list(string)
}