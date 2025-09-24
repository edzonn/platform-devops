
resource "helm_release" "aws_load_balancer_controller" {
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "kube-system"
  version          = "1.8.1"
  create_namespace = false

  values = [
    yamlencode({
      clusterName = var.cluster_name
      region      = var.region
      vpcId       = data.terraform_remote_state.vpc.outputs.vpc_id
      serviceAccount = {
        create = true
        name   = "aws-load-balancer-controller"
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.aws-load-balancer-controller.arn
        }
      }
    })
  ]

  timeout    = 900
  depends_on = [aws_eks_cluster.eks_cluster]
}

resource "helm_release" "aws_ebs_csi_driver" {
  name       = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  version    = "2.32.0"

  values = [
    yamlencode({
      controller = {
        serviceAccount = {
          create = true
          name   = "ebs-csi-controller-sa"
          annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.eks_node_role.arn
          }
        }
        enableVolumeScheduling = true
        enableVolumeResizing   = true
        enableVolumeSnapshot   = true
      }
      storageClasses = [
        {
          name                = "ebs-sc"
          annotations = {
            "storageclass.kubernetes.io/is-default-class" = "true"
          }
          volumeBindingMode   = "WaitForFirstConsumer"
          provisioner         = "ebs.csi.aws.com"
          parameters = {
            type      = "gp3"
            encrypted = "true"
          }
          allowVolumeExpansion = true
          reclaimPolicy       = "Delete"
        }
      ]
    })
  ]

  depends_on = [aws_eks_cluster.eks_cluster]
}