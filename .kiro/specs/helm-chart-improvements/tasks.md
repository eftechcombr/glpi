# Implementation Plan

- [x] 1. Create helper templates library
  - Create `kubernetes/glpi/templates/_helpers.tpl` file with reusable template functions
  - Implement chart name helpers (glpi.name, glpi.fullname, glpi.chart)
  - Implement label helpers (glpi.labels, glpi.selectorLabels)
  - Implement namespace helper (glpi.namespace)
  - Implement image name helpers for all components (glpi.phpfpm.image, glpi.nginx.image, glpi.mariadb.image, glpi.redis.image)
  - _Requirements: 1.5, 8.4_

- [x] 2. Update Chart.yaml metadata
  - Update description field to "GLPI - IT Asset Management and Service Desk"
  - Update appVersion to "11.0.2"
  - Update chart version to "1.0.0"
  - Add keywords array with ["glpi", "itil", "asset-management", "service-desk"]
  - _Requirements: 12.1, 12.2_

- [x] 3. Create comprehensive values.yaml file
  - Replace entire values.yaml with GLPI-specific configuration structure
  - Create global section with namespace configuration (optional, defaults to release namespace)
  - Create glpi section with version, language, phpfpm, nginx, paths, and persistence configurations
  - Create mariadb section with enabled flag, image, auth, primary resources, persistence, and service configurations
  - Create redis section with enabled flag, image, resources, and service configurations
  - Update ingress section with GLPI-appropriate defaults (glpi.example.local, backend to nginx service)
  - Remove httpRoute section entirely
  - Configure podSecurityContext (fsGroup: 33) and securityContext (runAsUser: 33, runAsNonRoot: true)
  - Keep serviceAccount, nodeSelector, tolerations, and affinity sections
  - Add comprehensive comments explaining each configuration option
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 2.1, 2.2, 2.3, 2.4, 2.5, 3.1, 3.2, 3.3, 3.4, 4.1, 4.2, 4.3, 4.4, 4.5, 5.1, 5.2, 5.3, 5.4, 7.1, 7.2, 7.3, 7.5, 8.1, 9.1, 9.2, 9.3, 9.4, 10.1, 10.2, 10.3, 10.4, 11.1, 11.2, 11.4, 12.3, 12.4_

- [x] 4. Update GLPI deployment templates
  - [x] 4.1 Template PHP-FPM deployment
    - Replace hardcoded namespace "glpi" with `{{ include "glpi.namespace" . }}`
    - Replace hardcoded image with `{{ include "glpi.phpfpm.image" . }}`
    - Replace hardcoded replica count with `{{ .Values.glpi.phpfpm.replicaCount }}`
    - Add resource limits and requests from `{{ .Values.glpi.phpfpm.resources }}`
    - Add liveness and readiness probes from values with conditional rendering based on enabled flags
    - Update labels using `{{ include "glpi.labels" . }}` and selectors using `{{ include "glpi.selectorLabels" . }}`
    - Add imagePullPolicy from `{{ .Values.glpi.phpfpm.image.pullPolicy }}`
    - _Requirements: 1.4, 1.5, 6.1, 5.1, 5.2, 8.3, 8.4, 9.1, 9.2_
  
  - [x] 4.2 Template Nginx deployment
    - Replace hardcoded namespace "glpi" with `{{ include "glpi.namespace" . }}`
    - Replace hardcoded image with `{{ include "glpi.nginx.image" . }}`
    - Replace hardcoded replica count with `{{ .Values.glpi.nginx.replicaCount }}`
    - Add resource limits and requests from `{{ .Values.glpi.nginx.resources }}`
    - Add liveness and readiness probes from values with conditional rendering based on enabled flags
    - Update labels using `{{ include "glpi.labels" . }}` and selectors using `{{ include "glpi.selectorLabels" . }}`
    - Add imagePullPolicy from `{{ .Values.glpi.nginx.image.pullPolicy }}`
    - _Requirements: 1.4, 1.5, 6.2, 5.3, 5.4, 8.3, 8.4, 9.3, 9.4_
  
  - [x] 4.3 Template GLPI services
    - Replace hardcoded namespace "glpi" with `{{ include "glpi.namespace" . }}` in both php-fpm and nginx services
    - Template Nginx service type from `{{ .Values.glpi.nginx.service.type }}` and port from `{{ .Values.glpi.nginx.service.port }}`
    - Update service labels using `{{ include "glpi.labels" . }}`
    - Update service selectors using `{{ include "glpi.selectorLabels" . }}`
    - _Requirements: 8.3, 8.4, 10.1, 10.2_

- [x] 5. Update GLPI ConfigMap template
  - Replace hardcoded namespace "glpi" with `{{ include "glpi.namespace" . }}`
  - Template GLPI version from `{{ .Values.glpi.version }}`
  - Template GLPI language from `{{ .Values.glpi.language }}`
  - Template all GLPI directory paths from `{{ .Values.glpi.paths }}` (marketplace, var, config)
  - Template MariaDB host using `mariadb-headless.{{ include "glpi.namespace" . }}.svc.cluster.local`
  - Template MariaDB port from `{{ .Values.mariadb.service.port }}`
  - Update labels using `{{ include "glpi.labels" . }}`
  - _Requirements: 1.1, 1.2, 1.3, 1.5, 2.5, 8.3, 8.4_

- [x] 6. Update GLPI Secret template
  - Replace hardcoded namespace "glpi" with `{{ include "glpi.namespace" . }}`
  - Template database name from `{{ .Values.mariadb.auth.database | b64enc }}`
  - Template database username from `{{ .Values.mariadb.auth.username | b64enc }}`
  - Template database password from `{{ .Values.mariadb.auth.password | b64enc }}`
  - Update labels using `{{ include "glpi.labels" . }}`
  - _Requirements: 2.5, 8.3, 8.4_

- [x] 7. Update GLPI PersistentVolumeClaim templates
  - Replace hardcoded namespace "glpi" with `{{ include "glpi.namespace" . }}` in all three PVCs
  - For files PVC: wrap in `{{- if .Values.glpi.persistence.files.enabled }}`, template storageClass, accessMode, and size from values
  - For marketplace PVC: wrap in `{{- if .Values.glpi.persistence.marketplace.enabled }}`, template storageClass, accessMode, and size from values
  - For etc PVC: wrap in `{{- if .Values.glpi.persistence.etc.enabled }}`, template storageClass, accessMode, and size from values
  - Update labels using `{{ include "glpi.labels" . }}` in all PVCs
  - Remove commented out storageClassName and accessModes lines
  - _Requirements: 4.1, 4.2, 4.5, 8.3, 8.4_

- [x] 8. Update MariaDB templates
  - [x] 8.1 Template MariaDB StatefulSet
    - Wrap entire file in `{{- if .Values.mariadb.enabled }}`
    - Replace hardcoded namespace "glpi" with `{{ include "glpi.namespace" . }}`
    - Replace hardcoded image "mariadb:11.4" with `{{ include "glpi.mariadb.image" . }}`
    - Replace hardcoded replica count with `{{ .Values.mariadb.replicaCount }}`
    - Template resource limits and requests from `{{ .Values.mariadb.primary.resources }}`
    - Update labels using `{{ include "glpi.labels" . }}`
    - Add imagePullPolicy from `{{ .Values.mariadb.image.pullPolicy }}`
    - _Requirements: 2.1, 2.2, 2.3, 8.3, 8.4_
  
  - [x] 8.2 Template MariaDB services
    - Wrap both services in `{{- if .Values.mariadb.enabled }}`
    - Replace hardcoded namespace "glpi" with `{{ include "glpi.namespace" . }}` in both services
    - Template service type from `{{ .Values.mariadb.service.type }}` in the main service
    - Template service port from `{{ .Values.mariadb.service.port }}` in both services
    - Update labels using `{{ include "glpi.labels" . }}`
    - _Requirements: 8.3, 8.4, 10.3_
  
  - [x] 8.3 Template MariaDB Secret
    - Wrap entire file in `{{- if .Values.mariadb.enabled }}`
    - Replace hardcoded namespace "glpi" with `{{ include "glpi.namespace" . }}`
    - Template root password from `{{ .Values.mariadb.auth.rootPassword | b64enc }}`
    - Template database name from `{{ .Values.mariadb.auth.database | b64enc }}`
    - Template username from `{{ .Values.mariadb.auth.username | b64enc }}`
    - Template password from `{{ .Values.mariadb.auth.password | b64enc }}`
    - Update labels using `{{ include "glpi.labels" . }}`
    - _Requirements: 2.5, 8.3, 8.4_
  
  - [x] 8.4 Template MariaDB PersistentVolumeClaim
    - Wrap entire file in `{{- if and .Values.mariadb.enabled .Values.mariadb.persistence.enabled }}`
    - Replace hardcoded namespace "glpi" with `{{ include "glpi.namespace" . }}`
    - Template storage class from `{{ .Values.mariadb.persistence.storageClass }}` (allow empty for default)
    - Template access mode from `{{ .Values.mariadb.persistence.accessMode }}`
    - Template size from `{{ .Values.mariadb.persistence.size }}`
    - Update labels using `{{ include "glpi.labels" . }}`
    - Remove commented out storageClassName line
    - _Requirements: 4.3, 4.4, 4.5, 8.3, 8.4_

- [x] 9. Update Redis templates
  - [x] 9.1 Template Redis deployment
    - Wrap entire deployment in `{{- if .Values.redis.enabled }}`
    - Add namespace field with `{{ include "glpi.namespace" . }}`
    - Replace hardcoded image "redis:7.0-alpine" with `{{ include "glpi.redis.image" . }}`
    - Replace hardcoded replica count with `{{ .Values.redis.replicaCount }}`
    - Template resource limits and requests from `{{ .Values.redis.resources }}`
    - Update labels using `{{ include "glpi.labels" . }}` and selectors using `{{ include "glpi.selectorLabels" . }}`
    - Add imagePullPolicy from `{{ .Values.redis.image.pullPolicy }}`
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 8.3, 8.4_
  
  - [x] 9.2 Template Redis service
    - Wrap entire service in `{{- if .Values.redis.enabled }}`
    - Add namespace field with `{{ include "glpi.namespace" . }}`
    - Template service type from `{{ .Values.redis.service.type }}`
    - Template service port from `{{ .Values.redis.service.port }}`
    - Update labels using `{{ include "glpi.labels" . }}`
    - Update selectors using `{{ include "glpi.selectorLabels" . }}`
    - _Requirements: 3.4, 8.3, 8.4, 10.4_

- [x] 10. Update Ingress template
  - Replace hardcoded namespace with helper template reference
  - Update default hostname to glpi.example.local
  - Configure backend service to reference nginx service using helper templates
  - Template ingress className from values
  - Template ingress annotations from values
  - Template hosts configuration from values
  - Template TLS configuration from values
  - Update labels using helper templates
  - _Requirements: 7.1, 7.2, 7.3, 7.4, 8.3, 8.4_

- [x] 11. Update namespace template
  - Add conditional rendering to only create namespace if global.namespace is explicitly set
  - Template namespace name from values
  - Update labels using helper templates
  - _Requirements: 8.1, 8.2, 8.3, 8.4_

- [x] 12. Remove HTTPRoute template
  - Delete kubernetes/glpi/templates/glpi-httpRoute.yaml file if it exists
  - Remove httpRoute section from values.yaml
  - _Requirements: 7.5_

- [x] 13. Update remaining template files
  - Update glpi-cronjob.yaml with namespace templating and helper labels
  - Update glpi-job.yaml with namespace templating and helper labels
  - Update mariadb-configmap.yaml with namespace templating and helper labels
  - Update mariadb-job.yaml with namespace templating and helper labels
  - Ensure all templates use consistent helper template patterns
  - _Requirements: 8.3, 8.4_

- [x] 14. Validate chart structure
  - Run helm lint on the chart to check for issues
  - Run helm template with default values to verify rendering
  - Run helm template with custom values to test configurability
  - Verify all required fields are present in values.yaml
  - Check that all templates properly reference values
  - _Requirements: All_
