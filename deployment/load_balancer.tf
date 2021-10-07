resource "aws_lb" "ytrd_alb" {
  
}

resource "aws_lb_target_group" "alb_web_tg" {
  name        = "ytrd_web_tg"
  target_type = "instance"
  port        = 3000
  vpc_id      = aws_vpc.ytrd_vpc.id
  protocol    = "tcp"

  depends_on = [
    aws_lb.ytrd_alb
  ]
}

resource "aws_lb_target_group" "alb_gql_tg" {
  name        = "ytrd_web_tg"
  target_type = "instance"
  port        = 4000
  vpc_id      = aws_vpc.ytrd_vpc.id
  protocol    = "tcp"

  depends_on = [
    aws_lb.ytrd_alb
  ]
}