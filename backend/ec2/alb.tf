resource "aws_lb" "platform-dev-test-nlb" {
  name               = "platform-dev-test-nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.platform-dev-test-lb.id]
  subnets            = data.terraform_remote_state.module_output.outputs.public_subnets
  tags = {
    Name = "platform-dev-test-nlb"
  }
}

resource "aws_lb_target_group" "platform-dev-test-nlb-tg" {
  name     = "platform-dev-test-nlb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = data.terraform_remote_state.module_output.outputs.vpc_id
  tags = {
    Name = "platform-dev-test-nlb-tg"
  }

  target_type = "alb"
}

resource "aws_lb_listener" "platform-dev-test-nlb-listener" {
  load_balancer_arn = aws_lb.platform-dev-test-nlb.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.platform-dev-test-nlb-tg.arn
  }
}

# attach target group to network load balancer

resource "aws_lb_target_group_attachment" "platform-dev-test-nlb-tg-attachment" {
  target_group_arn = aws_lb_target_group.platform-dev-test-nlb-tg.arn
  target_id        = aws_lb.platform-dev-test-lb.arn
  port             = 80
}

# resource "aws_lb_target_group_attachment" "da-mlops-test-tg-attachment" {
#   target_group_arn = aws_lb_target_group.da-mlops-test-tg.arn
#   target_id        = aws_instance.da-mlops-test-ec2-01.id
#   port             = 80
# }


resource "aws_lb" "platform-dev-test-lb" {
  name               = "platform-dev-test-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.platform-dev-test-lb.id]
  subnets            = data.terraform_remote_state.module_output.outputs.private_subnets
  tags = {
    Name = "platform-dev-test-lb"
  }
}

# create load balancer listener

resource "aws_lb_listener" "platform-dev-test-lb-listener" {
  load_balancer_arn = aws_lb.platform-dev-test-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.platform-dev-test-tg.arn
  }
}

# create target_group

resource "aws_lb_target_group" "platform-dev-test-tg" {
  name     = "platform-dev-test-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.module_output.outputs.vpc_id
  tags = {
    Name = "platform-dev-test-tg"
  }
}

resource "aws_lb_listener_rule" "platform-dev-test-lb-listener-rule" {
   listener_arn = aws_lb_listener.platform-dev-test-lb-listener.arn
  #listener_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:092744370500:loadbalancer/app/platform-dev-test-lb/1a8e296ccf8f1090"
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.platform-dev-test-tg.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }

  depends_on = [aws_lb_target_group.platform-dev-test-tg]
}

# create load balancer target group attachment

# resource "aws_lb_target_group_attachment" "platform-dev-test-tg-attachment" {
#   target_group_arn = aws_lb_target_group.platform-dev-test-tg.arn
#   target_id        = aws_instance.platform-dev-test-ec2-01.id
#   port             = 80
# }