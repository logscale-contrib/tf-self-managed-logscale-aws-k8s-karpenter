resource "kubectl_manifest" "pc-normal-priority" {
  yaml_body = <<-YAML
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: normal-priority
value: 100000
globalDefault: true
description: "This default class will be used to allow all nodes classes to autoscale"
YAML
}
