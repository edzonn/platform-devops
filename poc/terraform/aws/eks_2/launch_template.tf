resource "aws_launch_template" "eks_nodes" {
  name                   = "${var.cluster_name}-node-template"
  instance_type          = "t3.medium"
  image_id               = data.aws_ssm_parameter.eks_ami.value
  vpc_security_group_ids = [aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id]

user_data = base64encode(<<-EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOUNDARY"

--BOUNDARY
Content-Type: application/node.eks.aws

---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${var.cluster_name}
    apiServerEndpoint: ${aws_eks_cluster.eks_cluster.endpoint}
    certificateAuthority: ${aws_eks_cluster.eks_cluster.certificate_authority[0].data}
    cidr: ${aws_eks_cluster.eks_cluster.kubernetes_network_config[0].service_ipv4_cidr}

--BOUNDARY--
EOF
)

  iam_instance_profile {
    name = aws_iam_instance_profile.eks_node_instance_profile.name
  }

  lifecycle {
    create_before_destroy = true
  }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp2"
      delete_on_termination = true
      encrypted = true
      kms_key_id = data.aws_kms_alias.ebs.target_key_arn
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-node"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${var.cluster_name}-node-volume"
    }
  }
}

resource "aws_autoscaling_group" "eks_nodes" {
  name                = "${var.cluster_name}-nodes"
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1
  target_group_arns   = []
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.private_subnets

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }
  termination_policies = ["OldestInstance","OldestLaunchTemplate"]
  wait_for_capacity_timeout = "1m"

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
