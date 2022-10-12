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
  type        = string
  description = "(optional) describe your variable"
}
variable "eks_karpenter_iam_role_arn" {
  type        = string
  description = "(optional) describe your variable"
}

variable "project" {
  type        = string
  default     = "cluster-wide"
  description = "(optional) describe your variable"
}
variable "namespace" {
  type        = string
  default     = "karpenter"
  description = "(optional) describe your variable"
}
variable "release" {
  type        = string
  default     = "cw"
  description = "(optional) describe your variable"
}
variable "values" {
  description = "(optional) describe your variable"

}
variable "chart" {
  type        = string
  default     = "linkerd-control-plane"
  description = "(optional) describe your variable"
}
variable "chart_version" {
  type        = string
  default     = "1.9.*"
  description = "(optional) describe your variable"
}
variable "repository" {
  type        = string
  default     = "https://charts.karpenter.sh"
  description = "(optional) describe your variable"
}
