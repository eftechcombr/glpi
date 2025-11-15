# Implementation Plan

- [x] 1. Add job configuration structure to values.yaml
  - Add a new `jobs` section under the `glpi` configuration with enabled flags for all five jobs (verifyDir, dbInstall, dbUpgrade, dbConfigure, cacheConfigure)
  - Add a new `cronjob` section under the `glpi` configuration with enabled flag and schedule parameter
  - Include descriptive comments for each job explaining its purpose
  - Set all enabled flags to `true` by default for backward compatibility
  - Place the new configuration after the existing `glpi.persistence` section
  - _Requirements: 1.3, 1.4, 1.5, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 3.1, 3.2, 3.3, 3.4_

- [x] 2. Add conditional logic to glpi-job.yaml template
  - Wrap the glpi-verify-dir job manifest with `{{- if default true .Values.glpi.jobs.verifyDir.enabled }}` conditional
  - Wrap the glpi-db-install job manifest with `{{- if default true .Values.glpi.jobs.dbInstall.enabled }}` conditional
  - Wrap the glpi-db-upgrade job manifest with `{{- if default true .Values.glpi.jobs.dbUpgrade.enabled }}` conditional
  - Wrap the glpi-db-configure job manifest with `{{- if default true .Values.glpi.jobs.dbConfigure.enabled }}` conditional
  - Wrap the glpi-cache-configure job manifest with `{{- if default true .Values.glpi.jobs.cacheConfigure.enabled }}` conditional
  - Ensure each conditional block ends with `{{- end }}` after the job specification
  - Preserve all existing job specifications including containers, volumes, environment variables, and restart policies
  - Maintain proper YAML document separator (---) placement between jobs
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 4.1, 4.2, 4.3, 4.4, 4.5_

- [x] 3. Add conditional logic to glpi-cronjob.yaml template
  - Wrap the entire cronjob manifest with `{{- if default true .Values.glpi.cronjob.enabled }}` conditional at the beginning of the file
  - Add `{{- end }}` at the end of the file to close the conditional block
  - Replace the hardcoded schedule value with `{{ .Values.glpi.cronjob.schedule | quote }}` to make it configurable
  - Preserve all existing cronjob specifications
  - _Requirements: 1.1, 1.2, 1.3, 1.5, 4.1, 4.2, 4.3, 4.4_

- [x] 4. Validate template rendering with different configurations
  - Run `helm template` with default values to verify all jobs are rendered
  - Run `helm template` with all jobs disabled to verify no job manifests are generated
  - Run `helm template` with selective jobs disabled (e.g., dbInstall and dbUpgrade) to verify only enabled jobs are rendered
  - Verify that disabled jobs produce no output (no empty documents or stray separators)
  - Verify that enabled jobs render with complete and correct specifications
  - Check that YAML document separators are correctly placed
  - _Requirements: 1.1, 1.2, 4.1, 4.2, 4.5_
