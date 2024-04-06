{{- define "common.volumes" -}}
{{- $volume := index . 1 }}
{{- range $index, $persistence := $volume.volumes }}
{{- if $persistence.enabled }}
- name: {{ $index }}
  {{- if eq (default "pvc" $persistence.type) "pvc" }}
    {{- $pvcName := (include "common.fullname" $) -}}
    {{- if $persistence.existingClaim }}
      {{- $pvcName = $persistence.existingClaim -}}
    {{- else -}}
      {{- if $persistence.nameOverride -}}
        {{- if not (eq $persistence.nameOverride "-") -}}
          {{- $pvcName = (printf "%s-%s" (include "common.fullname" $) $persistence.nameOverride) -}}
        {{- end -}}
      {{- else -}}
        {{- $pvcName = (printf "%s-%s" (include "common.fullname" $) $index) -}}
      {{- end -}}
    {{- end }}
  persistentVolumeClaim:
    claimName: {{ $pvcName }}
  {{- else if eq $persistence.type "emptyDir" }}
    {{- $emptyDir := dict -}}
    {{- with $persistence.medium -}}
      {{- $_ := set $emptyDir "medium" . -}}
    {{- end -}}
    {{- with $persistence.sizeLimit -}}
      {{- $_ := set $emptyDir "sizeLimit" . -}}
    {{- end }}
  emptyDir: {{- $emptyDir | toYaml | nindent 4 }}
  {{- else if eq $persistence.type "hostPath" }}
  hostPath:
    path: {{ required "hostPath not set" $persistence.hostPath }}
    {{- with $persistence.hostPathType }}
    type: {{ . }}
    {{- end }}
  {{- else if eq $persistence.type "custom" }}
    {{- toYaml $persistence.volumeSpec | nindent 2 }}
  {{- else }}
    {{- fail (printf "Not a valid persistence.type (%s)" .Values.persistence.type) }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "common.volumeMounts" -}}
{{- $volume := index . 1 }}
{{- range $persistenceIndex, $persistenceItem := $volume.volumes }}
{{- if $persistenceItem.enabled }}
  {{- if kindIs "slice" $persistenceItem.subPath -}}
    {{- if $persistenceItem.mountPath -}}
      {{- fail (printf "Cannot use persistence.mountPath with a subPath list (%s)" $persistenceIndex) }}
    {{- end -}}
    {{- range $subPathIndex, $subPathItem := $persistenceItem.subPath }}
- name: {{ $persistenceIndex }}
  subPath: {{ required "subPaths as a list of maps require a path field" $subPathItem.path }}
  mountPath: {{ required "subPaths as a list of maps require an explicit mountPath field" $subPathItem.mountPath }}
      {{- with $subPathItem.readOnly }}
  readOnly: {{ . }}
      {{- end }}
      {{- with $subPathItem.mountPropagation }}
  mountPropagation: {{ . }}
      {{- end }}
    {{- end -}}
  {{- else -}}
    {{- $mountPath := (printf "/%v" $persistenceIndex) -}}
    {{- if eq "hostPath" (default "pvc" $persistenceItem.type) -}}
      {{- $mountPath = $persistenceItem.hostPath -}}
    {{- end -}}
    {{- with $persistenceItem.mountPath -}}
      {{- $mountPath = . -}}
    {{- end }}
    {{- if ne $mountPath "-" }}
- name: {{ $persistenceIndex }}
  mountPath: {{ $mountPath }}
      {{- with $persistenceItem.subPath }}
  subPath: {{ . }}
      {{- end }}
      {{- with $persistenceItem.readOnly }}
  readOnly: {{ . }}
      {{- end }}
      {{- with $persistenceItem.mountPropagation }}
  mountPropagation: {{ . }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}
