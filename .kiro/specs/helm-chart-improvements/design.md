# Design Document: GLPI Helm Chart Improvements

## Overview

This design transforms the GLPI Helm chart from a hardcoded template-based deployment to a fully configurable, production-ready Helm chart following best practices. The design restructures values.yaml to expose all configurable parameters and updates templates to consume these values dynamically.

## Architecture

### Current State
- Generic values.yaml with nginx placeholder
- Hardcoded values in templates (namespaces, images, resources)
- No GLPI-specific configuration exposure
- Limited customization options

### Target State
- Comprehensive values.yaml with GLPI-specific sections
- Templated manifests consuming values dynamically
- Configurable for different environments (dev, staging, production)
- Follows Helm chart best practices

### Component Structure

```
kubernetes/glpi/
├── Chart.yaml (updated metadata)
├── values.yaml (comprehensive configuration)
└── templates/
    ├── glpi-deployment.yaml (templated)
    ├── glpi-configmap.yaml (templated)
    ├── glpi-secret.yaml (templated)
    ├── glpi-persistentvolumeclaim.yaml (templated)
    ├── mariadb-statefulset.yaml (templated)
    ├── mariadb-configmap.yaml (templated)
    ├── mariadb-secret.yaml (templated)
    ├── mariadb-persistentvolumeclaim.yaml (templated)
    ├── redis-deployment.yaml (templated with conditional)
    ├── glpi-ingress.yaml (updated)
    └── namespace.yaml (conditional)
```

## Components and Interfaces

### 1. Values File Structure

The values.yaml will be organized into logical sections:

```yaml
# Global settings
global:
  namespace: glpi  # Optional, defaults to release namespace

# GLPI Application Configuration
glpi:
  version: "11.0.2"
  language: "en_US"
  
  phpfpm:
    image:
      repository: eftechcombr/glpi
      tag: php-fpm-11.0.2
      pullPolicy: IfNotPresent
    replicaCount: 1
    resources:
      limits:
        cpu: 1000m
        memory: 512Mi
      requests:
        cpu: 250m
        memory: 256Mi
    livenessProbe:
      enabled: true
      tcpSocket:
        port: 9000
      initialDelaySeconds: 30
      periodSeconds: 10
    readinessProbe:
      enabled: true
      tcpSocket:
        port: 9000
      initialDelaySeconds: 10
      periodSeconds: 5
  
  nginx:
    image:
      repository: eftechcombr/glpi
      tag: nginx-11.0.2
      pullPolicy: IfNotPresent
    replicaCount: 1
    resources:
      limits:
        cpu: 500m
        memory: 256Mi
      requests:
        cpu: 100m
        memory: 128Mi
    livenessProbe:
      enabled: true
      httpGet:
        path: /
        port: 8080
      initialDelaySeconds: 30
      periodSeconds: 10
    readinessProbe:
      enabled: true
      httpGet:
        path: /
        port: 8080
      initialDelaySeconds: 10
      periodSeconds: 5
    service:
      type: ClusterIP
      port: 80
      targetPort: 8080
  
  # GLPI directory paths
  paths:
    marketplace: /var/www/html/marketplace
    var: /var/lib/glpi
    config: /etc/glpi/config
  
  # Persistent storage configuration
  persistence:
    files:
      enabled: true
      storageClass: ""
      accessMode: ReadWriteOnce
      size: 10Gi
    marketplace:
      enabled: true
      storageClass: ""
      accessMode: ReadWriteOnce
      size: 2Gi
    etc:
      enabled: true
      storageClass: ""
      accessMode: ReadWriteOnce
      size: 50Mi

# MariaDB Configuration
mariadb:
  enabled: true
  image:
    repository: mariadb
    tag: "11.4"
    pullPolicy: IfNotPresent
  replicaCount: 1
  auth:
    rootPassword: glpi
    database: glpi
    username: glpi
    password: glpi
  primary:
    resources:
      limits:
        cpu: 1000m
        memory: 2Gi
      requests:
        cpu: 250m
        memory: 256Mi
  persistence:
    enabled: true
    storageClass: ""
    accessMode: ReadWriteOnce
    size: 10Gi
  service:
    type: ClusterIP
    port: 3306

# Redis Configuration
redis:
  enabled: true
  image:
    repository: redis
    tag: "7.0-alpine"
    pullPolicy: IfNotPresent
  replicaCount: 1
  resources:
    limits:
      cpu: 500m
      memory: 256Mi
    requests:
      cpu: 100m
      memory: 128Mi
  service:
    type: ClusterIP
    port: 6379

# Ingress Configuration
ingress:
  enabled: false
  className: ""
  annotations: {}
  hosts:
    - host: glpi.example.local
      paths:
        - path: /
          pathType: Prefix
  tls: []

# Security Context
podSecurityContext:
  fsGroup: 33  # www-data group

securityContext:
  runAsNonRoot: true
  runAsUser: 33  # www-data user
  capabilities:
    drop:
    - ALL

# Service Account
serviceAccount:
  create: true
  automount: true
  annotations: {}
  name: ""

# Additional Kubernetes configurations
nodeSelector: {}
tolerations: []
affinity: {}
```

### 2. Template Updates

#### glpi-deployment.yaml
- Replace hardcoded image references with `{{ .Values.glpi.phpfpm.image.repository }}:{{ .Values.glpi.phpfpm.image.tag }}`
- Replace hardcoded replicas with `{{ .Values.glpi.phpfpm.replicaCount }}`
- Replace hardcoded namespace with `{{ .Values.global.namespace | default .Release.Namespace }}`
- Add resource limits from values
- Add configurable probes
- Use helper templates for labels and selectors

#### glpi-configmap.yaml
- Template GLPI version: `{{ .Values.glpi.version }}`
- Template GLPI language: `{{ .Values.glpi.language }}`
- Template directory paths from `{{ .Values.glpi.paths }}`
- Template MariaDB connection from `{{ .Values.mariadb }}`

#### glpi-persistentvolumeclaim.yaml
- Template storage class: `{{ .Values.glpi.persistence.files.storageClass }}`
- Template access mode: `{{ .Values.glpi.persistence.files.accessMode }}`
- Template size: `{{ .Values.glpi.persistence.files.size }}`
- Add conditional rendering based on `{{ .Values.glpi.persistence.files.enabled }}`

#### mariadb-statefulset.yaml
- Template image from `{{ .Values.mariadb.image }}`
- Template resources from `{{ .Values.mariadb.primary.resources }}`
- Template replicas from `{{ .Values.mariadb.replicaCount }}`
- Remove hardcoded namespace
- Add conditional rendering based on `{{ .Values.mariadb.enabled }}`

#### redis-deployment.yaml
- Template image from `{{ .Values.redis.image }}`
- Template resources from `{{ .Values.redis.resources }}`
- Template replicas from `{{ .Values.redis.replicaCount }}`
- Add conditional rendering: `{{- if .Values.redis.enabled }}`
- Remove hardcoded namespace

#### glpi-ingress.yaml
- Update default host to `glpi.example.local`
- Configure backend service to point to nginx service
- Template all values from `{{ .Values.ingress }}`

#### namespace.yaml
- Add conditional rendering: `{{- if .Values.global.namespace }}`
- Only create namespace if explicitly specified in values

### 3. Helper Templates

Create `_helpers.tpl` with reusable template functions:

```yaml
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
Return the proper Redis image name
*/}}
{{- define "glpi.redis.image" -}}
{{- printf "%s:%s" .Values.redis.image.repository .Values.redis.image.tag }}
{{- end }}
```

## Data Models

### Configuration Hierarchy

```
Values
├── global (namespace)
├── glpi
│   ├── version
│   ├── language
│   ├── phpfpm (deployment config)
│   ├── nginx (deployment config)
│   ├── paths (directory structure)
│   └── persistence (PVC configs)
├── mariadb
│   ├── enabled
│   ├── image
│   ├── auth (credentials)
│   ├── primary (resources)
│   └── persistence
├── redis
│   ├── enabled
│   ├── image
│   ├── resources
│   └── service
├── ingress
├── securityContext
└── serviceAccount
```

### Secret Management

Secrets will remain in templates but values will be templated:

```yaml
# glpi-secret.yaml
data:
  MARIADB_DATABASE: {{ .Values.mariadb.auth.database | b64enc }}
  MARIADB_USER: {{ .Values.mariadb.auth.username | b64enc }}
  MARIADB_PASSWORD: {{ .Values.mariadb.auth.password | b64enc }}
```

**Note**: For production, users should use external secret management (Sealed Secrets, External Secrets Operator, etc.)

## Error Handling

### Validation

Add validation in templates using `required` function:

```yaml
{{- if .Values.glpi.persistence.files.enabled }}
{{- if not .Values.glpi.persistence.files.size }}
{{- fail "glpi.persistence.files.size is required when persistence is enabled" }}
{{- end }}
{{- end }}
```

### Conditional Resource Creation

- Namespace: Only create if `global.namespace` is set
- Redis: Only create if `redis.enabled` is true
- MariaDB: Only create if `mariadb.enabled` is true
- Ingress: Only create if `ingress.enabled` is true
- PVCs: Only create if respective `persistence.enabled` is true

### Backward Compatibility

- Provide sensible defaults matching current hardcoded values
- Document breaking changes in Chart.yaml annotations
- Increment chart version to 1.0.0 to indicate major refactor

## Testing Strategy

### Validation Tests

1. **Template Rendering**: Use `helm template` to verify all templates render correctly
2. **Lint Check**: Run `helm lint` to ensure chart follows best practices
3. **Value Validation**: Test with various value combinations:
   - Minimal values (all defaults)
   - Custom namespace
   - Disabled Redis
   - Custom resource limits
   - Different storage classes

### Integration Tests

1. **Default Installation**: Deploy with default values
2. **Custom Configuration**: Deploy with customized values
3. **Upgrade Path**: Test upgrading from current chart to new version
4. **Service Connectivity**: Verify PHP-FPM can connect to MariaDB and Redis
5. **Ingress Access**: Verify GLPI is accessible through ingress

### Test Commands

```bash
# Lint the chart
helm lint kubernetes/glpi

# Render templates with default values
helm template glpi kubernetes/glpi

# Render templates with custom values
helm template glpi kubernetes/glpi -f custom-values.yaml

# Dry-run installation
helm install glpi kubernetes/glpi --dry-run --debug

# Install to test namespace
helm install glpi kubernetes/glpi -n glpi-test --create-namespace

# Verify deployment
kubectl get all -n glpi-test
kubectl logs -n glpi-test -l app=php-fpm
kubectl logs -n glpi-test -l app=nginx
```

## Design Decisions and Rationales

### 1. Namespace Handling
**Decision**: Make namespace optional, default to release namespace
**Rationale**: Helm best practice is to use release namespace. Hardcoded namespaces limit flexibility.

### 2. Secret Management
**Decision**: Keep secrets in templates but make values configurable
**Rationale**: Provides basic functionality while allowing users to integrate external secret management.

### 3. Component Separation
**Decision**: Separate PHP-FPM and Nginx into distinct deployments
**Rationale**: Maintains current architecture, allows independent scaling.

### 4. Redis Optional
**Decision**: Make Redis deployment conditional
**Rationale**: Not all environments may need Redis, provides flexibility.

### 5. Storage Class Flexibility
**Decision**: Allow empty storageClass (uses cluster default)
**Rationale**: Different clusters have different default storage classes.

### 6. Resource Defaults
**Decision**: Provide production-ready resource limits as defaults
**Rationale**: Prevents resource exhaustion while allowing customization.

### 7. Probe Configuration
**Decision**: Make probes configurable but enabled by default
**Rationale**: Health checks are critical for production, but paths/timing may need adjustment.

### 8. HTTPRoute Removal
**Decision**: Remove HTTPRoute configuration
**Rationale**: Not used by GLPI, adds unnecessary complexity. Users can add if needed.

### 9. Helper Templates
**Decision**: Create comprehensive helper template library
**Rationale**: Reduces duplication, ensures consistency across templates.

### 10. Chart Version
**Decision**: Bump to version 1.0.0
**Rationale**: Indicates production-ready, stable API after major refactor.

## Migration Guide

For users upgrading from the current chart:

1. **Backup Data**: Backup all PVCs before upgrading
2. **Review Values**: Compare new values.yaml structure with current configuration
3. **Update Secrets**: If using external secrets, update references
4. **Test in Non-Production**: Deploy to test environment first
5. **Upgrade**: Use `helm upgrade` with new values file

### Breaking Changes

- Namespace is no longer hardcoded to "glpi"
- Image tags must be specified in values (no longer hardcoded)
- Resource limits are now enforced by default
- HTTPRoute configuration removed
