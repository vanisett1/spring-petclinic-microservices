{{/*
Expand the name of the chart.
*/}}
{{- define "admin-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "admin-server.fullname" -}}
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
{{- define "admin-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "admin-server.labels" -}}
helm.sh/chart: {{ include "admin-server.chart" . }}
{{ include "admin-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "admin-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "admin-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "admin-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "admin-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Deployment annotations
*/}}
{{- define "admin-server.annotations" -}}
{{- if .Values.prometheus.enabled }}
prometheus.io/scrape: "{{ .Values.prometheus.scrape | default "true" }}"
prometheus.io/port: "{{ .Values.prometheus.port }}"
prometheus.io/path: "{{ .Values.prometheus.path }}"
{{- end }}
{{- with .Values.annotations }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}