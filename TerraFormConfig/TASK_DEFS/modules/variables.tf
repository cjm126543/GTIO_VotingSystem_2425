variable "task_family_name" {}
variable "container_definition_name" {}
variable "container_image_uri" {}
variable "container_ports" {
  type = list(number)
}
variable "awslogs_group" {}