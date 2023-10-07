resource "aws_route53_zone" "app_route53_zone" {
  name = var.domain
}

resource "aws_route53_record" "app_route53_record" {
  zone_id = aws_route53_zone.app_route53_zone.zone_id
  name    = aws_route53_zone.app_route53_zone.name
  type    = "A"

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }
}
