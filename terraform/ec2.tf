# Security group for the ALB accepting HTTP connections on port 80
#
# TODO: implement SSL encrypted traffic and redirect HTTP to HTTPS
resource "aws_security_group" "alb" {
  name   = "${local.namespace}-alb"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "alb_ingress_http" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow public HTTP traffic"
  from_port         = 80
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "alb_egress_all" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
  from_port         = 0
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = -1
  security_group_id = aws_security_group.alb.id
  to_port           = 0
  type              = "egress"
}

resource "aws_lb_target_group" "alb" {
  name        = local.namespace
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    # TODO: review health check
    enabled  = true
    path     = "/"
    port     = 80
    protocol = "HTTP"
  }

  vpc_id = aws_vpc.vpc.id
}

resource "aws_lb" "alb" {
  name               = local.namespace
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = local.public_subnet_ids
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