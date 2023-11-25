resource "aws_route53_zone" "primary" {
  name = var.dns_name
}

resource "aws_route53_record" "alb" {
  zone_id = aws_route53_zone.primary.zone_id
  name = var.dns_name
  type = "A"

  alias {
    evaluate_target_health = true
    name = aws_lb.alb.dns_name
    zone_id = aws_lb.alb.zone_id
  }
}
