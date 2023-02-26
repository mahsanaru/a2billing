apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: phpmyadmin
  name: phpmyadmin
  namespace: {{ include "common.names.namespace" . | quote }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: phpmyadmin
  template:
    metadata:
      labels:
        app: phpmyadmin
    spec:
      containers:
      - image: phpmyadmin
        imagePullPolicy: IfNotPresent
        name: phpmyadmin
        env:
          {{- if .Values.auth.usePasswordFiles }}
          - name: MYSQL_ROOT_PASSWORD_FILE
            value: {{ default "/opt/bitnami/mysql/secrets/mysql-root-password" .Values.auth.customPasswordFiles.root }}
          {{- else }}
          - name: MYSQL_ROOT_PASSWORD
            valueFrom:
              secretKeyRef:
                name: {{ template "mysql.secretName" . }}
                key: mysql-root-password
          {{- end }}
          {{- if not (empty .Values.auth.username) }}
          - name: PMA_USER
            value: {{ .Values.auth.username | quote }}
          {{- if .Values.auth.usePasswordFiles }}
          - name: MYSQL_PASSWORD_FILE
            value: {{ default "/opt/bitnami/mysql/secrets/mysql-password" .Values.auth.customPasswordFiles.user }}
          {{- else }}
          - name: PMA_PASSWORD
            valueFrom:
              secretKeyRef:
                name: {{ template "mysql.secretName" . }}
                key: mysql-password
          {{- end }}
          {{- end }}
          {{- if and .Values.auth.createDatabase .Values.auth.database }}
          - name: PMA_PMADB
            value: {{ .Values.auth.database | quote }}
          {{- end }}
