{{- define "common.configMap.tpl" -}}
{{- $top := first . }}
{{- $configmap := index . 1 }}
{{- range $cName, $val := $configmap }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" $top }}-{{$cName}}
  labels:
    {{- include "common.labels" $top | nindent 4 }}
data: 
  {{- toYaml $val.data | nindent 2 }}
{{- end }}
{{- end }}

{{- define "common.configMap" -}}
{{- $configmap := index . 1 }}
{{- include "common.utils.merge" (append . "common.configMap.tpl") }}
{{- end }}