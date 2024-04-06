{{- define "common.utils.merge" -}}
{{- $top := first . }}
{{- $tplName := last . }}
{{- $args := initial . }}
{{- if typeIs "string" (last $args) }}
  {{- $overridesName := last $args }}
  {{- $args = initial $args }}
  {{- $tpl := fromYaml (include $tplName $args) | default (dict) }}
  {{- $overrides := fromYaml (include $overridesName $args) | default (dict) }}
  {{- toYaml (merge $overrides $tpl) }}
{{- else }}
  {{- include $tplName $args }}
{{- end }}
{{- end }}
