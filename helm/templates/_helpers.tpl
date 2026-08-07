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
{{- end }}
{{- end }}

{{/*
Return the name of the Secret holding the MariaDB application user password: either the
user-supplied mariadb.auth.existingSecret, or the helmforge/mariadb subchart's own
auto-generated Secret ({release-name}-mariadb-auth). Mirrors that subchart's internal
"mariadb.secretName" naming convention so GLPI's own containers can read the SAME live
secret instead of duplicating (and potentially going stale/empty on) the password value in
glpi-secret. Only meaningful when mariadb.enabled is true.
*/}}
{{- define "glpi.mariadb.secretName" -}}
{{- if .Values.mariadb.auth.existingSecret -}}
{{- .Values.mariadb.auth.existingSecret -}}
{{- else -}}
{{- printf "%s-mariadb-auth" .Release.Name -}}
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

{{/*
Return the key within the MariaDB auth Secret (see glpi.mariadb.secretName) that holds the
application user's password. Mirrors mariadb.auth.existingSecretUserPasswordKey so a custom
existingSecret with a non-default key name is respected.
*/}}
{{- define "glpi.mariadb.secretPasswordKey" -}}
{{- .Values.mariadb.auth.existingSecretUserPasswordKey | default "mariadb-user-password" -}}
{{- end }}

{{/*
Return the name of the Secret holding S3 credentials for the files backup CronJob: either the
user-supplied glpi.backup.s3.existingSecret, or this chart's own generated Secret. Mirrors the
same existingSecret-or-generated pattern (and naming convention) as the helmforge/mariadb
subchart's own backup.s3.existingSecret / mariadb.backupSecretName.
*/}}
{{- define "glpi.backup.secretName" -}}
{{- if .Values.glpi.backup.s3.existingSecret -}}
{{- .Values.glpi.backup.s3.existingSecret -}}
{{- else -}}
{{- printf "%s-backup" (include "glpi.fullname" .) -}}
{{- end -}}
{{- end }}

{{/*
Validates required S3 settings and returns a non-empty string when the files backup CronJob
should be rendered. Mirrors the helmforge/mariadb subchart's own mariadb.backupEnabled
fail-fast validation (missing endpoint/bucket at install time is a much clearer error than
a CronJob silently failing every run).
*/}}
{{- define "glpi.backup.enabled" -}}
{{- if .Values.glpi.backup.enabled -}}
  {{- if not .Values.glpi.backup.s3.endpoint -}}
    {{- fail "glpi.backup.s3.endpoint is required when glpi.backup.enabled is true" -}}
  {{- end -}}
  {{- if not .Values.glpi.backup.s3.bucket -}}
    {{- fail "glpi.backup.s3.bucket is required when glpi.backup.enabled is true" -}}
  {{- end -}}
  {{- if not (or .Values.glpi.backup.volumes.files .Values.glpi.backup.volumes.marketplace .Values.glpi.backup.volumes.etc) -}}
    {{- fail "glpi.backup.enabled is true but glpi.backup.volumes.files/marketplace/etc are all false - nothing to back up" -}}
  {{- end -}}
  true
{{- end -}}
{{- end }}


