# Application Load Balancer
resource "aws_lb" "custom_alb" {
  name               = var.load_balancer_name
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids
  enable_deletion_protection = false
}