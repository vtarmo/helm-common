{{- define "common.ips" -}}
{{- $top := first . }}
{{- $imagepullsecrets := index . 1 }}
{{- range $key, $value := $imagepullsecrets }}
{{- if $imagepullsecrets -}}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{$key}}
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: {{ template "common.ips.secret" (list . $value) }}
{{- end }}
{{- end }}
{{- end }}

{{- define "common.ips.secret" }}
{{- $top := first . }}
{{- $imagepullsecrets := index . 1 }}
{{- with $imagepullsecrets }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

