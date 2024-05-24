{{- define "common.service.tpl" -}}
{{- $top := first . }}
{{- $service := index . 1 }}
apiVersion: v1
kind: Service
metadata:
  {{- include "common.metadata" (list $top) | nindent 2 }}
spec:
  type: {{ $service.type }}
  ports:
  {{- range $key, $index := $service.ports }}  
  - port: {{ $index.port }}
    targetPort: {{ $index.targetPort | default $index.port }}
    protocol: {{ $index.protocol }}
    name: {{ $key }}
  {{- end }}
  selector:
    {{- include "common.selectorLabels" $top | nindent 4 }}
{{- end }}

{{- define "common.service" -}}
{{- include "common.utils.merge" (append . "common.service.tpl") }}
{{- end }}