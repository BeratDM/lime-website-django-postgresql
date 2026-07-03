{{/*
Expand the name of the chart.
*/}}
{{- define "lime-w.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "lime-w.fullname" -}}
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
{{- define "lime-w.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "lime-w.labels" -}}
helm.sh/chart: {{ include "lime-w.chart" . }}
{{ include "lime-w.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "lime-w.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lime-w.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "lime-w.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "lime-w.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "lime-w.db.env" -}}
- name: POSTGRES_HOST
  value: lime-web2-postgresql

- name: POSTGRES_DB
  value: {{ .Values.postgresql.auth.database | quote }}

- name: POSTGRES_USER
  value: {{ .Values.postgresql.auth.username | quote }}

- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: lime-web2-postgresql
      key: password
{{- end }}


