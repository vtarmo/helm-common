{{- define "common.env.transformDict" -}}
{{- range $key, $value := . }}
- name: {{$key | quote}}
  value: {{$value | quote}}
{{- end }}
{{- end }}

{{- define "common.secretenv.transformDict" -}}
{{- range $key, $value := . }}
- name: {{$key | quote}}
  valueFrom:
    secretKeyRef:
      name: {{$value.secretName}}
      key: {{$value.secretKey}}
{{- end }}
{{- end }}

{{- define "common.configmapenv.transformDict" -}}
{{- range $key, $value := . }}
- name: {{$key | quote}}
  valueFrom:
    configMapKeyRef:
      name: {{$value.configMapName}}
      key: {{$value.configMapKey}}
{{- end }}
{{- end }}

{{- define "common.envfromsecret.transformDict" -}}
{{- range $key, $value := . }}
- secretRef:
    name: {{$value | quote}}
{{- end }}
{{- end }}

{{- define "common.envfromconfigmap.transformDict" -}}
{{- range $key, $value := . }}
- configMapRef:
    name: {{$value | quote}}
{{- end }}
{{- end }}