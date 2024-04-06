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
  - port: {{ $service.port }}
    targetPort: http
    protocol: TCP
    name: http
  selector:
    {{- include "common.selectorLabels" $top | nindent 4 }}
{{- end }}

{{- define "common.service" -}}
{{- include "common.utils.merge" (append . "common.service.tpl") }}
{{- end }}
