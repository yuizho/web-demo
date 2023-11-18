resource "aws_lb" "app_alb" {
  name                       = "app-alb"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  # FIXME:
  # ご操作によるALB削除防止のため、本番運用ではtrueにするのが良いと思う
  # destroy前にfalseにする必要があるので、ガシガシdestroyする場合はfalseが良いと思う
  enable_deletion_protection = false

  subnets = [ for value in var.public_subnets : aws_subnet.app_subnet_public[value.az].id ]

  access_logs {
    bucket = aws_s3_bucket.app_alb_log.id
    enabled = true
  }

  security_groups = [
    module.alb_sg.security_group_id
  ]
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

resource "aws_lb_target_group" "app_tg" {
  name                 = "app-tg"
  vpc_id               = aws_vpc.app_vpc.id
  target_type          = "ip"
  port                 = 8080
  protocol             = "HTTP"
  deregistration_delay = 300

  health_check {
    path                = "/actuator/health"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.app_alb]
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = length(data.aws_acm_certificate.app_acm_certificate) == 0 ? 80 : 443
  protocol          = length(data.aws_acm_certificate.app_acm_certificate) == 0 ? "HTTP" : "HTTPS"
  ssl_policy        = length(data.aws_acm_certificate.app_acm_certificate) == 0 ? null : "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = one(data.aws_acm_certificate.app_acm_certificate[*].arn)

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_listener" "app_lb_http_listener" {
  # domainの設定があり、ACMの設定などが有効になるケースのみ
  # HTTPのHTTPSへのリダイレクト設定を入れる
  count = var.domain != null ? 1 : 0

  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
