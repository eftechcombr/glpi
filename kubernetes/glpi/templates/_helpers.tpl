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
Return the proper MariaDB image name
*/}}
{{- define "glpi.mariadb.image" -}}
{{- printf "%s:%s" .Values.mariadb.image.repository .Values.mariadb.image.tag }}
{{- end }}

{{/*
Return the name of the Secret holding MariaDB server credentials
(MARIADB_ROOT_PASSWORD, MARIADB_DATABASE, MARIADB_USER, MARIADB_PASSWORD).
Used by the MariaDB StatefulSet itself and the mariadb-timezone Job.
Set mariadb.auth.existingSecret to reference a Secret managed outside this
chart (e.g. synced by Doppler, External Secrets Operator, Vault) instead of
letting the chart create one from plaintext values.yaml values.
*/}}
{{- define "glpi.mariadbSecretName" -}}
{{- if .Values.mariadb.auth.existingSecret -}}
{{- .Values.mariadb.auth.existingSecret -}}
{{- else -}}
mariadb-glpi-secret
{{- end -}}
{{- end }}

{{/*
Return the name of the Secret holding the GLPI application's DB credentials
(MARIADB_DATABASE, MARIADB_USER, MARIADB_PASSWORD - no root password).
Used by php-fpm, all init Jobs, and the cronjob.
Set glpi.database.existingSecret to reference a Secret managed outside this
chart instead of letting the chart create one from plaintext values.yaml
values. Applies regardless of mariadb.enabled (internal or external DB).
*/}}
{{- define "glpi.databaseSecretName" -}}
{{- if .Values.glpi.database.existingSecret -}}
{{- .Values.glpi.database.existingSecret -}}
{{- else -}}
glpi-secret
{{- end -}}
{{- end }}

{{/*
Return the proper Redis image name
*/}}
{{- define "glpi.redis.image" -}}
{{- printf "%s:%s" .Values.redis.image.repository .Values.redis.image.tag }}
{{- end }}
