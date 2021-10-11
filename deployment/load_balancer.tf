resource "aws_lb" "ytrd_alb" {
  name               = "ytrd-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ytrd_secgroup.id]

  # use dynamic mapping here instead
  subnets = [aws_subnet.ytrd_public_a.id, aws_subnet.ytrd_public_b.id]

  tags = {
    Name = "ytrd-dev-alb"
  }
  # may want to configure access logs
}

# Make it easier for a dev to access the UI after deploying it
output "ui-url" {
  value = "http://${aws_lb.ytrd_alb.dns_name}:3000"
}

resource "aws_lb_listener" "ytrd_gql_listener" {
  load_balancer_arn = aws_lb.ytrd_alb.arn
  port              = var.gql_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_gql_tg.arn
  }
}

resource "aws_lb_listener" "ytrd_web_listener" {
  load_balancer_arn = aws_lb.ytrd_alb.arn
  port              = var.web_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_web_tg.arn
  }
}

resource "aws_lb_target_group" "alb_web_tg" {
  name        = "ytrd-web-tg"
  target_type = "ip"
  port        = var.web_port
  vpc_id      = aws_vpc.ytrd_vpc.id
  protocol    = "HTTP"

  health_check {
      port = 3000
      path = "/"
      timeout = 10
      interval = 30
      unhealthy_threshold = 10
  }

  depends_on = [
    aws_lb.ytrd_alb
  ]
}

resource "aws_lb_target_group" "alb_gql_tg" {
  name        = "ytrd-gql-tg"
  target_type = "ip"
  port        = var.gql_port
  vpc_id      = aws_vpc.ytrd_vpc.id
  protocol    = "HTTP"

  depends_on = [
    aws_lb.ytrd_alb
  ]
}
