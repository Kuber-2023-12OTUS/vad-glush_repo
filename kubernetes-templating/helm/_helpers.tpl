

{{/*
 Обявление конструкции repositories если она существует
*/}}  
{{- define "base_repositories" -}}
repositories:
{{- range $i, $e := .Values.apps }}
    {{- if eq  (index $.Values (list $e "use_exeternal_rep" | join "_")) true }}
  - name: {{ index $.Values (list $e "repositories_name" | join "_") }}
    url: {{ index $.Values (list $e "repositories_url" | join "_") }}
    {{- end }}
{{- end }}
{{ end }}


{{/*
 Обявление конструкции releases
*/}} 
{{- define "base_release" -}}
    {{- range $i, $e := .Values.apps }}
  - name: {{ index $.Values (list $e "service_name" | join "_")}}
    labels:
      app: {{ index $.Values (list $e "service_labels" | join "_") }}
    namespace: {{  $.Values.namespace}}
    version: {{ index $.Values (list $e "version" | join "_") -}}
    
{{/*
 Обявление условия и наполнения при выборке внешнего или локаьного charta
*/}}
{{- if eq (index $.Values (list $e "use_exeternal_rep" | join "_")) true }}
    chart: {{ index $.Values (list $e "repositories_name" | join "_") }}/{{ index $.Values (list $e "service_name" | join "_") }}
{{- else }}
    chart: {{ index $.Values (list $e "chart" | join "_") }}
{{- end -}}

{{/*
 Обявление конструкции set если она существует
*/}}    
{{- if (index $.Values (list $e "set" | join "_")) }}
    set:
{{- range $f, $g := (index $.Values (list $e "set" | join "_")) }}
    - name: {{ .name }}
      value: {{ .value }}
{{- end }}
{{- end }}
    inherit:
      - template: default
    {{ end }}
{{ end }}