
# Workaround - https://github.com/hashicorp/terraform-provider-kubernetes/issues/1380#issuecomment-967022975
resource "kubectl_manifest" "karpenter_provisioner_general" {
  depends_on = [
    kubectl_manifest.app
  ]
  yaml_body = <<-YAML
  apiVersion: karpenter.sh/v1alpha5
  kind: Provisioner
  metadata:
    name: default
    namespace: ${kubernetes_namespace.karpenter.metadata[0].name}
  spec:
    labels:
        beta.humio.com/pool: "compute"
    requirements:
      - key: karpenter.sh/capacity-type
        operator: In
        values: ["spot", "on-demand"]
      - key: node.kubernetes.io/instance-type
        operator: In
        values: 
        # - m6i.large
        - m6i.xlarge
        # - m6a.large
        - m6a.xlarge
        # - m5.large
        - m5.xlarge
        # - m5a.large
        - m5a.xlarge
        # - m5n.large
        - m5n.xlarge
        # - m5zn.large
        - m5zn.xlarge
        # - m4.large
        - m4.xlarge



    limits:
      resources:
        cpu: 1000
    provider:
      subnetSelector:
        Name: "${var.uniqueName}-public*"
        karpenter.sh/discovery/${var.uniqueName}: ${var.eks_cluster_id}
      securityGroupSelector:
        karpenter.sh/discovery/${var.uniqueName}: ${var.eks_cluster_id}
      tags:
        karpenter.sh/discovery/${var.uniqueName}: ${var.eks_cluster_id}
    ttlSecondsAfterEmpty: 30
  YAML

}


# Workaround - https://github.com/hashicorp/terraform-provider-kubernetes/issues/1380#issuecomment-967022975
resource "kubectl_manifest" "karpenter_provisioner_nvme" {
  depends_on = [
    kubectl_manifest.app
  ]

  yaml_body = <<-YAML
  apiVersion: karpenter.sh/v1alpha5
  kind: Provisioner
  metadata:
    name: nvme
    namespace: karpenter
  spec:
    labels:
        beta.humio.com/pool: "nvme"
        beta.humio.com/humiocluster: "true"
        beta.humio.com/instance-storage: "true"
    requirements:
      - key: karpenter.sh/capacity-type
        operator: In
        values: ["spot", "on-demand"]
      - key: node.kubernetes.io/instance-type
        operator: In
        values: 
            - c5d.large
            
    taints:
        - key: beta.humio.com/humiocluster
          value: "true"
          effect: NoSchedule        
        - key: beta.humio.com/instance-storage
          value: "true"
          effect: NoSchedule        
    limits:
      resources:
        cpu: 32
    provider:
      subnetSelector:
        Name: "${var.uniqueName}-public*"
        karpenter.sh/discovery/${var.uniqueName}: ${var.eks_cluster_id}
      securityGroupSelector:
        karpenter.sh/discovery/${var.uniqueName}: ${var.eks_cluster_id}
      tags:
        karpenter.sh/discovery/${var.uniqueName}: ${var.eks_cluster_id}
    ttlSecondsAfterEmpty: 300
  YAML

}
