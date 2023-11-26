resource "aws_route53_zone" "primary" {
  name = var.dns_name
}

resource "aws_route53_record" "alb" {
  alias {
    evaluate_target_health = true
    name = aws_lb.alb.dns_name
    zone_id = aws_lb.alb.zone_id
  }

  name = var.dns_name
  type = "A"
  zone_id = aws_route53_zone.primary.zone_id
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.primary.zone_id
}
