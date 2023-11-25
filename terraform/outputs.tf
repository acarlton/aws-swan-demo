output "alb_dns_name" {
  description = "The application load balancer DNS name."
  value       = aws_lb.alb.dns_name
}
