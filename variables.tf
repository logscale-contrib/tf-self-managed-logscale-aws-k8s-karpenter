variable "uniqueName" {
  type        = string
  description = "(optional) describe your variable"
}

variable "eks_cluster_id" {
  type        = string
  description = "(optional) describe your variable"
}
variable "eks_endpoint" {
  type        = string
  description = "(optional) describe your variable"
}

variable "eks_oidc_provider_arn" {
  type        = string
  description = "(optional) describe your variable"
}

variable "eks_karpenter_iam_role_name" {
    type = string
    description = "(optional) describe your variable"
}
variable "eks_karpenter_iam_role_arn" {
    type = string
    description = "(optional) describe your variable"
}

variable "project" {
  type = string
  default = "cluster-wide"
  description = "(optional) describe your variable"
} 
variable "namespace" {
  type = string
  default = "karpenter"
  description = "(optional) describe your variable"
} 
variable "release" {
  type = string
  default = "cw"
  description = "(optional) describe your variable"
} 
variable "values" {
  description = "(optional) describe your variable"
  default = [<<EOF
topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: DoNotSchedule
replicas: 2
EOF 
  ]
} 
variable "chart" {
  type = string
  default = "value"
  description = "(optional) describe your variable"
} 
variable "chart_version" {
  type = string
  default = "v0.15.*"
  description = "(optional) describe your variable"
} 
variable "repository" {
  type = string
  default = "https://charts.karpenter.sh"
  description = "(optional) describe your variable"
}