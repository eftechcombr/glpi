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
Return the key within the MariaDB auth Secret (see glpi.mariadb.secretName) that holds the
application user's password. Mirrors mariadb.auth.existingSecretUserPasswordKey so a custom
existingSecret with a non-default key name is respected.
*/}}
{{- define "glpi.mariadb.secretPasswordKey" -}}
{{- .Values.mariadb.auth.existingSecretUserPasswordKey | default "mariadb-user-password" -}}
{{- end }}


