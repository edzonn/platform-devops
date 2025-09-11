# resource "helm_release" "aws-load-balancer-controller" {
#   name             = "aws-load-balancer-controller"
#   repository       = "https://aws.github.io/eks-charts"
#   chart            = "aws-load-balancer-controller"
#   namespace        = "kube-system"
#   version          = "1.4.1"
#   create_namespace = true

#   values = [
#     file("./ingress.yaml")
#   ]
#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.aws-load-balancer-controller.arn
#   }
# }

# resource "helm_release" "aws_ebs_csi_driver" {
#   name       = "aws-ebs-csi-driver"
#   namespace  = "kube-system"
#   repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
#   chart      = "aws-ebs-csi-driver"
#   version    = "2.30.0" 

#   values = [
#     yamlencode({
#       storageClasses = [
#         {
#           name              = "local-agent-key"
#           volumeBindingMode = "WaitForFirstConsumer"
#           provisioner       = "ebs.csi.aws.com"
#         }
#       ]
#     })
#   ]

#   set {
#     name  = "enableVolumeScheduling"
#     value = "true"
#   }

#   set {
#     name  = "enableVolumeResizing"
#     value = "true"
#   }

#   set {
#     name  = "enableVolumeSnapshot"
#     value = "true"
#   }

#     depends_on = [aws_eks_cluster.eks_cluster]
# }
