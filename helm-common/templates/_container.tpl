{{- define "common.container.tpl" -}}
{{- $top := first . }}
{{- $container := index . 1 }}
{{- $image := $container.image | default (dict) }}
name: {{ $top.Chart.Name }}
securityContext:
  {{- toYaml $container.securityContext | nindent 2 }}
image: "{{ $image.repository }}:{{ $image.tag | default $top.Chart.AppVersion }}"
imagePullPolicy: {{ $container.image.pullPolicy }}
env:
  {{- include "common.env.transformDict" $container.envVars | trim | nindent 2 }}
  {{- include "common.secretenv.transformDict" $container.envSecretVars | trim | nindent 2 }}
  {{- include "common.configmapenv.transformDict" $container.envConfigMapVars | trim | nindent 2 }}
envFrom:
  {{- include "common.envfromsecret.transformDict" $container.envFromSecret | trim |nindent 2 }}
  {{- include "common.envfromconfigmap.transformDict" $container.envFromConfigMap | trim |nindent 2 }}
resources:
  {{- toYaml $container.resources | nindent 2 }}
ports:
  {{- range $key, $serviceport := $container.service.ports }}
  - name: {{ $key }}
    containerPort: {{ $serviceport.port }}
    protocol: {{ $serviceport.protocol }}
  {{- end }}
{{- with (include "common.volumeMounts" . | trim) }}
volumeMounts:
  {{- nindent 4 . }}
{{- end }}
{{- if $container.startupProbe.enabled }}
startupProbe: {{- include "common.tplvalues.render" (dict "value" (omit $container.startupProbe "enabled") "context" $) | nindent 2 }}
{{- end }}
{{- if $container.livenessProbe.enabled }}
livenessProbe: {{- include "common.tplvalues.render" (dict "value" (omit $container.livenessProbe "enabled") "context" $) | nindent 2 }}
{{- end }}
{{- if $container.readinessProbe.enabled }}
readinessProbe: {{- include "common.tplvalues.render" (dict "value" (omit $container.readinessProbe "enabled") "context" $) | nindent 2 }}
{{- end }}
{{- end }}

{{- define "common.container" -}}
{{- include "common.utils.merge" (append . "common.container.tpl") }}
{{- end }}
