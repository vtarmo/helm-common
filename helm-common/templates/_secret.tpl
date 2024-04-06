{{- define "common.secret.tpl" -}}
{{- $top := first . }}
{{- $secret := index . 1 }}
{{- range $sName, $val := $secret -}}
apiVersion: v1
kind: Secret
metadata:
  {{- include "common.metadata"  (list $top) | nindent 2 }}
type: Opaque
data:
  {{- include "common.secrets.render" (dict "value" $val.data) | indent 2 }}
{{- end }}
{{- end }}

{{- define "common.secret" -}}
{{- $secret := index . 1 }}
{{- include "common.utils.merge" (append . "common.secret.tpl") }}
{{- end }}

{{- define "common.secrets.encode" -}}
{{if hasPrefix "b64:" .value}}{{trimPrefix "b64:" .value}}{{else}}{{toString .value|b64enc}}{{end}}
{{- end -}}

{{- define "common.secrets.render" -}}
{{- $v := dict -}}
{{- if kindIs "string" .value -}}
{{- $v = fromYaml .value }}
{{- else -}}
{{- $v = .value }}
{{- end -}}
{{- range $key, $value := $v }}
{{- if kindIs "string" $value }}
{{ printf "%s: %s" $key (include "common.secrets.encode" (dict "value" $value)) }}
{{- else }}
{{ $key }}: {{$value | toJson | b64enc }}
{{- end -}}
{{- end -}}
{{- end -}}
