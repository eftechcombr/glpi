# Design Document

## Overview

This design implements a feature to enable/disable Kubernetes Jobs and CronJobs in the GLPI Helm chart through values configuration. The solution uses Helm's conditional template syntax to selectively render job manifests based on boolean flags in the values file. This provides users with granular control over which initialization and maintenance tasks are deployed.

## Architecture

The implementation follows Helm's standard pattern for optional resources:

1. **Values Layer**: Add job configuration structure to `values.yaml` with enabled flags and documentation
2. **Template Layer**: Wrap job manifests in conditional blocks that check the enabled flags
3. **Default Behavior**: All jobs default to enabled (true) for backward compatibility

### Component Interaction

```
values.yaml (user config)
    ↓
Helm Template Engine
    ↓
Conditional Evaluation (.Values.glpi.jobs.<job-name>.enabled)
    ↓
Rendered Kubernetes Manifests (only enabled jobs)
    ↓
Kubernetes Cluster
```

## Components and Interfaces

### 1. Values Configuration Structure

Add a new `jobs` section under `glpi` in `values.yaml`:

```yaml
glpi:
  # ... existing configuration ...
  
  # -- Job Configuration
  # Control which initialization jobs are deployed
  jobs:
    # Verify and create required GLPI directories
    verifyDir:
      enabled: true
    
    # Install GLPI database schema (for fresh installations)
    dbInstall:
      enabled: true
    
    # Upgrade GLPI database schema (for version upgrades)
    dbUpgrade:
      enabled: true
    
    # Configure GLPI database connection
    dbConfigure:
      enabled: true
    
    # Configure GLPI cache settings
    cacheConfigure:
      enabled: true
  
  # -- CronJob Configuration
  # Control the scheduled maintenance job
  cronjob:
    # Enable or disable the GLPI maintenance cronjob
    enabled: true
    # Schedule in cron format (default: every 2 minutes)
    schedule: "*/2 * * * *"
```

### 2. Template Modifications

#### glpi-job.yaml Template Structure

Wrap each job definition with a conditional block:

```yaml
{{- if .Values.glpi.jobs.verifyDir.enabled }}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: glpi-verify-dir
  # ... rest of job spec ...
{{- end }}

{{- if .Values.glpi.jobs.dbInstall.enabled }}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: glpi-db-install
  # ... rest of job spec ...
{{- end }}

{{- if .Values.glpi.jobs.dbUpgrade.enabled }}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: glpi-db-upgrade
  # ... rest of job spec ...
{{- end }}

{{- if .Values.glpi.jobs.dbConfigure.enabled }}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: glpi-db-configure
  # ... rest of job spec ...
{{- end }}

{{- if .Values.glpi.jobs.cacheConfigure.enabled }}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: glpi-cache-configure
  # ... rest of job spec ...
{{- end }}
```

#### glpi-cronjob.yaml Template Structure

Wrap the entire cronjob with a conditional block:

```yaml
{{- if .Values.glpi.cronjob.enabled }}
apiVersion: batch/v1
kind: CronJob
metadata:
  name: glpi-cronjob
  # ... rest of cronjob spec ...
spec:
  schedule: {{ .Values.glpi.cronjob.schedule | quote }}
  # ... rest of spec ...
{{- end }}
```

### 3. Naming Convention Mapping

Map job names to camelCase values keys:

| Job Name | Script | Values Key |
|----------|--------|------------|
| glpi-verify-dir | glpi-verify-dir.sh | verifyDir |
| glpi-db-install | glpi-db-install.sh | dbInstall |
| glpi-db-upgrade | glpi-db-upgrade.sh | dbUpgrade |
| glpi-db-configure | glpi-db-configure.sh | dbConfigure |
| glpi-cache-configure | glpi-cache-configure.sh | cacheConfigure |
| glpi-cronjob | front/cron.php | cronjob |

## Data Models

### Values Schema

```yaml
glpi:
  jobs:
    verifyDir:
      enabled: boolean (default: true)
    dbInstall:
      enabled: boolean (default: true)
    dbUpgrade:
      enabled: boolean (default: true)
    dbConfigure:
      enabled: boolean (default: true)
    cacheConfigure:
      enabled: boolean (default: true)
  cronjob:
    enabled: boolean (default: true)
    schedule: string (default: "*/2 * * * *")
```

### Template Conditional Logic

Each job uses the pattern:
```
{{- if .Values.glpi.jobs.<jobKey>.enabled }}
  <job manifest>
{{- end }}
```

The conditional evaluates to:
- `true`: Render the job manifest
- `false` or `nil`: Skip rendering (no manifest output)

## Error Handling

### Missing Configuration

**Scenario**: User upgrades from an older chart version without the new job configuration

**Solution**: Use Helm's default function to provide backward-compatible defaults

```yaml
{{- if default true .Values.glpi.jobs.verifyDir.enabled }}
```

This ensures that if `glpi.jobs.verifyDir.enabled` is not defined, it defaults to `true`.

### Invalid Configuration

**Scenario**: User provides non-boolean value for enabled flag

**Solution**: Helm will evaluate non-boolean values according to Go template truthiness:
- Empty string, 0, false, nil → false
- Any other value → true

For strict validation, we rely on Helm's type checking and user testing with `helm template` or `helm install --dry-run`.

### Partial Job Execution

**Scenario**: User disables a job that other jobs depend on (e.g., disabling dbConfigure but enabling dbInstall)

**Solution**: Document job dependencies in values.yaml comments. The chart does not enforce dependencies programmatically, as users may have external processes handling these tasks.

## Testing Strategy

### 1. Template Rendering Tests

Test that templates render correctly with various configurations:

```bash
# Test with all jobs enabled (default)
helm template glpi ./kubernetes/glpi

# Test with all jobs disabled
helm template glpi ./kubernetes/glpi \
  --set glpi.jobs.verifyDir.enabled=false \
  --set glpi.jobs.dbInstall.enabled=false \
  --set glpi.jobs.dbUpgrade.enabled=false \
  --set glpi.jobs.dbConfigure.enabled=false \
  --set glpi.jobs.cacheConfigure.enabled=false \
  --set glpi.cronjob.enabled=false

# Test with selective jobs enabled
helm template glpi ./kubernetes/glpi \
  --set glpi.jobs.dbInstall.enabled=false \
  --set glpi.jobs.dbUpgrade.enabled=false
```

### 2. Validation Tests

Verify that:
- Disabled jobs do not appear in rendered output
- Enabled jobs appear with complete specifications
- YAML document separators (---) are correctly placed
- No empty documents are generated

### 3. Backward Compatibility Tests

Test upgrade scenarios:
```bash
# Install with old values (no job config)
helm template glpi ./kubernetes/glpi -f old-values.yaml

# Verify all jobs are rendered (backward compatible)
```

### 4. Integration Tests

Deploy to a test cluster and verify:
- Only enabled jobs are created in Kubernetes
- Disabled jobs do not create any resources
- Enabled jobs execute successfully
- CronJob schedule can be customized

## Implementation Notes

### Conditional Placement

The `{{- if }}` directive should be placed:
- **Before** the `---` separator for the first job in the file
- **After** the `---` separator for subsequent jobs

This ensures clean YAML output without leading separators when jobs are disabled.

### Whitespace Control

Use `{{-` and `-}}` to control whitespace:
- `{{-` removes whitespace before the tag
- `-}}` removes whitespace after the tag

This prevents empty lines in the rendered output when jobs are disabled.

### Schedule Configuration

The cronjob schedule is made configurable to support different maintenance intervals:
```yaml
schedule: {{ .Values.glpi.cronjob.schedule | quote }}
```

The `quote` function ensures the cron expression is properly quoted in the YAML output.

## Design Decisions

### Decision 1: Separate enabled flag for each job

**Rationale**: Provides maximum flexibility. Users may want to disable specific jobs (e.g., dbInstall for upgrades) while keeping others enabled.

**Alternative Considered**: Single global flag to enable/disable all jobs. Rejected because it lacks granularity.

### Decision 2: Default all jobs to enabled

**Rationale**: Maintains backward compatibility. Existing deployments continue to work without configuration changes.

**Alternative Considered**: Default to disabled, requiring explicit opt-in. Rejected because it would break existing deployments.

### Decision 3: Use camelCase for values keys

**Rationale**: Follows Helm best practices and improves readability in templates.

**Alternative Considered**: Use kebab-case matching job names. Rejected because it's less idiomatic in YAML configuration.

### Decision 4: No programmatic dependency enforcement

**Rationale**: Users may have external processes or custom workflows. Enforcing dependencies would reduce flexibility.

**Alternative Considered**: Add validation to ensure dependent jobs are enabled together. Rejected to avoid complexity and maintain flexibility.

### Decision 5: Make cronjob schedule configurable

**Rationale**: While implementing the enabled flag, it's a natural extension to make the schedule configurable as well, providing additional value with minimal effort.

**Alternative Considered**: Only add the enabled flag. Rejected because schedule configurability is a common user request.
