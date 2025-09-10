# Launch Template (AL2023 bootstrap via NodeConfig MIME) new user-data method
resource "aws_launch_template" "nodes" {
  name          = "${var.cluster_name}-node-template"
  instance_type = var.instance_type
  image_id      = data.aws_ssm_parameter.eks_ami.value

  # vpc_security_group_ids = [aws_security_group.poc[*].id]

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
        apiServerEndpoint: ${aws_eks_cluster.this.endpoint}
        certificateAuthority: ${aws_eks_cluster.this.certificate_authority[0].data}
        cidr: ${aws_eks_cluster.this.kubernetes_network_config[0].service_ipv4_cidr}
    
    --BOUNDARY--
  EOF
  )

  iam_instance_profile { name = aws_iam_instance_profile.node.name }
  

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.node_disk_size
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    #   kms_key_id            = local.effective_kms_key_id
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, { Name = "${var.cluster_name}-node", VPC = var.vpc_id })
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(var.tags, { Name = "${var.cluster_name}-node-volume", VPC = var.vpc_id })
  }
}

