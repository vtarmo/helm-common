{{- define "common.configMap.tpl" -}}
{{- $top := first . }}
{{- $configmap := index . 1 }}
apiVersion: v1
kind: ConfigMap
metadata:
  {{- include "common.metadata" (list $top) | nindent 2 }}
data: 
  {{- toYaml $configmap.data | nindent 2 }}
{{- end }}

{{- define "common.configMap" -}}
{{- $configmap := index . 1 }}
{{- include "common.utils.merge" (append . "common.configMap.tpl") }}
{{- end }}
