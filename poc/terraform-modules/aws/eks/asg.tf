# Auto Scaling Group for nodes
resource "aws_autoscaling_group" "nodes" {
  name                = "${var.cluster_name}-nodes"
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.nodes.id
    version = "$Latest"
  }

  termination_policies        = ["OldestInstance","OldestLaunchTemplate"]
  wait_for_capacity_timeout   = "10m"
  health_check_type           = "EC2"
  health_check_grace_period   = 300

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = merge(var.tags, { VPC = var.vpc_id })
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  depends_on = [aws_eks_cluster.this]
}
