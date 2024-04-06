{{- define "common.deployment.tpl" -}}
{{- $top := first . }}
{{- $deployment := index . 1 }}
{{- $autoscaling := index . 2 }}
{{- $serviceAccount := index . 3 }}
apiVersion: apps/v1
kind: Deployment
metadata:
  {{- include "common.metadata" (list $top) | nindent 2 }}
spec:
  {{- if not $autoscaling.enabled }}
  replicas: {{ $deployment.replicaCount | default 1 }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "common.selectorLabels" $top | nindent 6 }}
  template:
    {{- include "common.pod.template" (list $top $deployment $serviceAccount) | nindent 4 }}
{{- end }}

{{- define "common.deployment" -}}
{{- include "common.utils.merge" (append . "common.deployment.tpl") }}
{{- end }}
