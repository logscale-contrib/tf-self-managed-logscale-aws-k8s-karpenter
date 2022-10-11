variable "uniqueName" {
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