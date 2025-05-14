resource "aws_launch_template" "eks_nodes" {
  name                   = "${var.cluster_name}-node-template"
  instance_type          = "t3.micro"
  image_id               = data.aws_ssm_parameter.eks_ami.value
  vpc_security_group_ids = [aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${var.cluster_name}
  EOF
  )

  iam_instance_profile {
    name = aws_iam_instance_profile.eks_node_instance_profile.name
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-node"
    }
  }
}

resource "aws_autoscaling_group" "eks_nodes" {
  name                = "${var.cluster_name}-nodes"
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1
  target_group_arns   = []
  vpc_zone_identifier = aws_subnet.eks_subnets[*].id

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }
  termination_policies = ["OldestInstance"]
  wait_for_capacity_timeout = "0"

  lifecycle {
    create_before_destroy = true
  }

  health_check_type = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}