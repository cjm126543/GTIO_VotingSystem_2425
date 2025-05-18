# Listener HTTP en el puerto 80
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = var.alb_arn
  port              = var.lb_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}