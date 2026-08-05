{{/*
Expand the name of the chart.
*/}}
{{- define "glpi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "glpi.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "glpi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "glpi.labels" -}}
helm.sh/chart: {{ include "glpi.chart" . }}
{{ include "glpi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "glpi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "glpi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the proper namespace
*/}}
{{- define "glpi.namespace" -}}
{{- .Values.global.namespace | default .Release.Namespace }}
{{- end }}

{{/*
Return the service account name
*/}}
{{- define "glpi.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- .Values.serviceAccount.name | default (include "glpi.fullname" .) }}
{{- else }}
{{- .Values.serviceAccount.name | default "default" }}
{{- end }}
{{- end }}

{{/*
Return the proper GLPI PHP-FPM image name
*/}}
{{- define "glpi.phpfpm.image" -}}
{{- printf "%s:%s" .Values.glpi.phpfpm.image.repository .Values.glpi.phpfpm.image.tag }}
{{- end }}

{{/*
Return the proper GLPI Nginx image name
*/}}
{{- define "glpi.nginx.image" -}}
{{- printf "%s:%s" .Values.glpi.nginx.image.repository .Values.glpi.nginx.image.tag }}
{{- end }}

{{/*
Return a resource request/limit object for one of a fixed set of size presets
(nano/micro/small/medium/large/xlarge/2xlarge), following the same tiers used by
the Bitnami charts (bitnami/common's common.resources.preset) so operators already
familiar with that convention get predictable numbers here too. Only used as a
fallback when a component's explicit `resources` value is left empty ({}); an
explicit `resources` block always takes precedence over the preset.
Usage: {{ include "glpi.resources.preset" (dict "type" "small") }}
*/}}
{{- define "glpi.resources.preset" -}}
{{- $presets := dict
  "nano" (dict
      "requests" (dict "cpu" "100m" "memory" "128Mi")
      "limits" (dict "cpu" "150m" "memory" "192Mi")
   )
  "micro" (dict
      "requests" (dict "cpu" "250m" "memory" "256Mi")
      "limits" (dict "cpu" "375m" "memory" "384Mi")
   )
  "small" (dict
      "requests" (dict "cpu" "500m" "memory" "512Mi")
      "limits" (dict "cpu" "750m" "memory" "768Mi")
   )
  "medium" (dict
      "requests" (dict "cpu" "500m" "memory" "1024Mi")
      "limits" (dict "cpu" "750m" "memory" "1536Mi")
   )
  "large" (dict
      "requests" (dict "cpu" "1.0" "memory" "2048Mi")
      "limits" (dict "cpu" "1.5" "memory" "3072Mi")
   )
  "xlarge" (dict
      "requests" (dict "cpu" "1.0" "memory" "3072Mi")
      "limits" (dict "cpu" "3.0" "memory" "6144Mi")
   )
  "2xlarge" (dict
      "requests" (dict "cpu" "1.0" "memory" "3072Mi")
      "limits" (dict "cpu" "6.0" "memory" "12288Mi")
   )
 }}
{{- if hasKey $presets .type -}}
{{- index $presets .type | toYaml -}}
{{- else -}}
{{- printf "ERROR: resourcesPreset '%s' invalid. Allowed values are %s" .type (join "," (keys $presets)) | fail -}}
{{- end -}}
{{- end }}

{{/*
Render a component's resources block: uses the explicit `resources` dict if it is
non-empty, otherwise falls back to `resourcesPreset` (skipped entirely if both are
unset). Usage: {{- include "glpi.resources" (dict "resources" .Values.glpi.phpfpm.resources "preset" .Values.glpi.phpfpm.resourcesPreset) | nindent 12 }}
*/}}
{{- define "glpi.resources" -}}
{{- if .resources -}}
{{- toYaml .resources -}}
{{- else if and .preset (ne .preset "none") -}}
{{- include "glpi.resources.preset" (dict "type" .preset) -}}
{{- end -}}
{{- end }}


