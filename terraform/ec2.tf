resource "aws_security_group" "web" {
  name = "${local.namespace}-web"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  vpc_id = aws_vpc.vpc.id
}

resource "aws_lb_target_group" "alb" {
  name = "${local.namespace}"
  port = 80
  protocol = "HTTP"
  target_type = "ip"

  health_check {
    # TODO: enable health check; off for testing
    enabled = true
    path = "/"
    port = 80
    protocol = "HTTP"
  }

  vpc_id = aws_vpc.vpc.id
}

resource "aws_lb" "alb" {
  name = local.namespace
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.web.id]
  subnets = local.public_subnet_ids
}

resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.alb.id
    type             = "forward"
  }
}
