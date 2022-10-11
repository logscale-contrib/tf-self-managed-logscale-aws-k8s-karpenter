

module "karpenter_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                          = "${var.uniqueName}_karpenter_controller"
  attach_karpenter_controller_policy = true

  karpenter_tag_key               = "karpenter.sh/discovery/${var.uniqueName}"
  karpenter_controller_cluster_id = var.eks_cluster_id
  karpenter_controller_node_iam_role_arns = [
    var.eks_karpenter_iam_role_arn
  ]

  oidc_providers = {
    main = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["karpenter:karpenter"]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile-${var.uniqueName}"
  role = var.eks_karpenter_iam_role_name
}



resource "kubernetes_namespace" "karpenter" {

  metadata {
    name = "karpenter"
  }
}

resource "helm_release" "karpenter" {
  namespace        = kubernetes_namespace.karpenter.metadata[0].name
  create_namespace = false

  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "v0.15.0"

  values = [<<EOF
topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: DoNotSchedule
EOF 
  ]
  set {
    name  = "replicas"
    value = 2
  }


  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter_irsa.iam_role_arn
  }

  set {
    name  = "clusterName"
    value = var.eks_cluster_id
  }

  set {
    name  = "clusterEndpoint"
    value = var.eks_endpoint
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }
}

