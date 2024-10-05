{{/*
Expand the name of the chart.
*/}}
{{- define "visits-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "visits-service.fullname" -}}
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
{{- define "visits-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "visits-service.labels" -}}
helm.sh/chart: {{ include "visits-service.chart" . }}
{{ include "visits-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "visits-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "visits-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "visits-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "visits-service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Deployment annotations
*/}}
{{- define "visits-service.annotations" -}}
{{- if .Values.prometheus.enabled }}
prometheus.io/scrape: "{{ .Values.prometheus.scrape | default "true" }}"
prometheus.io/port: "{{ .Values.prometheus.port }}"
prometheus.io/path: "{{ .Values.prometheus.path }}"
{{- end }}
{{- with .Values.annotations }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}