output "frontend_lb_dns" {
  value = module.frontend.lb_dns
}

output "backend_lb_dns" {
  value = module.backend.lb_dns
}