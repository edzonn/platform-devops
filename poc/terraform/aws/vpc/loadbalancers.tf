
#Internal Application Load Balancer

resource "aws_lb" "internal_alb" {
  name               = "test-internal-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = module.vpc.private_subnets
  security_groups    = ["data.aws_security_group.default.id"]
}

resource "aws_lb_target_group" "alb_targets" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_listener" "alb_http" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_targets.arn
  }
}

# Network Load Balancer

resource "aws_lb" "nlb" {
  name               = "public-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_target_group" "nlb_to_alb" {
  name        = "nlb-to-alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
}

# Register ALB node IPs as NLB targets

resource "aws_lb_target_group_attachment" "nlb_to_alb_attachment" {
  count            = length(data.aws_network_interface.alb_eni)
  target_group_arn = aws_lb_target_group.nlb_to_alb.arn
  target_id        = data.aws_network_interface.alb_eni[count.index].private_ip
  port             = 80
}


resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_to_alb.arn
  }
}
