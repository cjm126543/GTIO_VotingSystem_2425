resource "aws_lb_target_group" "target_group" {
  name        = var.target_group_name
  port        = var.target_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.aws_vpc_default_id

  ip_address_type = "ipv4"
  protocol_version = "HTTP1"

  health_check {
    protocol = "HTTP"
    path     = "/alive"  # Puedes cambiarlo si tu contenedor usa otro path
    matcher  = "200"
    interval = 30
    timeout  = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}