variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  description = "Nombre de la clave SSH para acceso EC2"
  type        = string
}

variable "ecr_repo_front" {
  description = "Repositorio ECR para el frontend"
  type        = string
}

variable "ecr_repo_back" {
  description = "Repositorio ECR para el backend"
  type        = string
}