

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
resource "kubectl_manifest" "app" {
  yaml_body = yamlencode({
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "finalizers" = [
        "resources-finalizer.argocd.argoproj.io",
      ]
      "name"      = var.chart
      "namespace" = "argocd"
    }
    "spec" = {
      "destination" = {
        "server"    = "https://kubernetes.default.svc"
        "namespace" = var.namespace
      }
      "project" = var.project
      "source" = {
        "chart" = var.chart
        "helm" = {
          "parameters" = [
            {
              "name"  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
              "value" = module.karpenter_irsa.iam_role_arn
            },
            {
              "name"  = "clusterName"
              "value" = var.eks_cluster_id
            },
          ]
          "releaseName" = var.release
          "values"      = yamldecode(var.values)
        }
        "repoURL"        = var.repository
        "targetRevision" = var.chart_version
      }
      "syncPolicy" = {
        "automated" = {
          "prune"    = true
          "selfHeal" = true
        }
        "syncOptions" = [
          "CreateNamespace=true"
        ]
      }
    }
  })
}

