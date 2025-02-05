# resource "aws_lb" "platform-alb" {
#   name                             = "platform-alb"
#   internal                         = true
#   load_balancer_type               = "application"
#   security_groups                  = [module.eks.node_security_group_id]
#   subnets                          = module.eks.public_subnet_ids
#   enable_deletion_protection       = false
#   enable_http2                     = true
#   idle_timeout                     = 60
#   enable_cross_zone_load_balancing = true
#   tags                             = local.tags
# }

# resource "aws_lb_listener" "platform-alb-listener" {
#   load_balancer_arn = aws_lb.platform-alb.arn
#   port              = 80
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.platform-alb-tg.arn
#   }
# }

# resource "aws_lb_target_group" "platform-alb-tg" {
#   name        = "platform-alb-tg-http"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "instance"
#   vpc_id      = [module.vpc.vpc_id]
#   health_check {
#     path                = "/"
#     port                = "traffic-port"
#     protocol            = "HTTP"
#     timeout             = 5
#     interval            = 30
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     matcher             = "200"
#   }
# }

# # resource "aws_lb_target_group_attachment" "platform-alb-tg-attachment" {
# #     target_group_arn = aws_lb_target_group.platform-alb-tg.arn
# #     target_id = module.eks.node_group_id
# #     port = 80
# # }

# resource "aws_lb_listener_rule" "platform-alb-listener-rule" {
#   listener_arn = aws_lb_listener.platform-alb-listener.arn
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.platform-alb-tg.arn
#   }
#   condition {
#     host_header {
#       values = ["*"]
#     }
#   }
# }