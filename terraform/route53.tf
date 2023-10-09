resource "aws_route53_zone" "app_route53_zone" {
  count = var.domain != null ? 1 : 0

  name = var.domain
}

resource "aws_route53_record" "app_route53_record" {
  count = var.domain != null ? 1 : 0

  zone_id = aws_route53_zone.app_route53_zone[0].zone_id
  name    = aws_route53_zone.app_route53_zone[0].name
  type    = "A"

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }
}
