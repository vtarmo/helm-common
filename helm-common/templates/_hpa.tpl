{{- define "common.hpa.tpl" -}}
{{- $top := first . }}
{{- $autoscaling := index . 1 }}
{{- if semverCompare ">=1.23-0" $top.Capabilities.KubeVersion.GitVersion -}}
apiVersion: autoscaling/v2
{{- else -}}
apiVersion: autoscaling/v2
{{- end }}
kind: HorizontalPodAutoscaler
metadata:
  {{- include "common.metadata" (list $top) | nindent 2 }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "common.fullname" $top }}
  minReplicas: {{ $autoscaling.minReplicas }}
  maxReplicas: {{ $autoscaling.maxReplicas }}
  metrics:
  {{- with $autoscaling.cpuUtilizationPercentage }}
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: {{ . }}
  {{- end }}
  {{- with $autoscaling.memoryUtilizationPercentage }}
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: {{ . }}
  {{- end }}
{{- end }}

{{- define "common.hpa" -}}
{{- $autoscaling := index . 1 }}
{{- if $autoscaling.enabled }}
  {{- include "common.utils.merge" (append . "common.hpa.tpl") }}
{{- end }}
{{- end }}
