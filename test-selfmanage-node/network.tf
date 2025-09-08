resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

resource "aws_subnet" "eks_subnets" {
  count                   = length(var.subnet_cidrs)
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name                        = "${var.cluster_name}-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_route_table" "eks_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = {
    Name = "${var.cluster_name}-rt"
  }
}

resource "aws_route_table_association" "eks_rta" {
  count          = length(aws_subnet.eks_subnets)
  subnet_id      = aws_subnet.eks_subnets[count.index].id
  route_table_id = aws_route_table.eks_rt.id
}

# provider "aws" {
#   region = "us-west-2"
# }

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_security_group" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

#######################
# 1. Internal Application Load Balancer
#######################
resource "aws_lb" "internal_alb" {
  name               = "test-internal-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = ["data.aws_security_group.default.id"]
}

resource "aws_lb_target_group" "alb_targets" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
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

#######################
# 2. Network Load Balancer
#######################
resource "aws_lb" "nlb" {
  name               = "public-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnets.default.ids
}

resource "aws_lb_target_group" "nlb_to_alb" {
  name        = "nlb-to-alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"
}

# Fetch ALB private IPs dynamically
data "aws_network_interface" "alb_eni" {
  for_each = toset(aws_lb.internal_alb.subnets)
  filter {
    name   = "subnet-id"
    values = [each.value]
  }
}

# Register ALB node IPs as NLB targets
resource "aws_lb_target_group_attachment" "nlb_to_alb_attachment" {
  for_each         = data.aws_network_interface.alb_eni
  target_group_arn = aws_lb_target_group.nlb_to_alb.arn
  target_id        = each.value.private_ip
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
