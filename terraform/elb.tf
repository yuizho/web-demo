resource "aws_lb" "app_alb" {
  name                       = "app-alb"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = false

  subnets = [
    aws_subnet.app_subnet_public[0].id,
    aws_subnet.app_subnet_public[1].id,
  ]

  security_groups = [
    module.http_sg.security_group_id
  ]
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

resource "aws_lb_target_group" "app_tg" {
  name                 = "app-tg"
  vpc_id               = aws_vpc.app_vpc.id
  target_type          = "instance"
  port                 = 8080
  protocol             = "HTTP"
  deregistration_delay = 300

  health_check {
    path                = "/"
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

resource "aws_lb_target_group_attachment" "app_tg_attachment_0" {
  count = 4
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server_ec2[count.index].id
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

