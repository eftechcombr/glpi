# Requirements Document

## Introduction

This feature enables users to selectively enable or disable Kubernetes Jobs and CronJobs in the GLPI Helm chart through values configuration. Currently, all jobs (glpi-verify-dir, glpi-db-install, glpi-db-upgrade, glpi-db-configure, glpi-cache-configure) and the cronjob (glpi-cronjob) are always deployed. This feature provides granular control over which jobs are deployed, allowing users to skip unnecessary jobs in specific deployment scenarios (e.g., upgrades vs fresh installs, or when using external database initialization).

## Glossary

- **Helm_Chart**: The Kubernetes package manager template system that defines the GLPI application deployment
- **Job**: A Kubernetes batch/v1 resource that runs a task to completion once
- **CronJob**: A Kubernetes batch/v1 resource that runs a task on a scheduled basis
- **Values_File**: The YAML configuration file (values.yaml) that contains user-configurable parameters for the Helm chart
- **Template_File**: The Helm template files that generate Kubernetes manifests based on values
- **GLPI_Jobs**: The five one-time jobs (glpi-verify-dir, glpi-db-install, glpi-db-upgrade, glpi-db-configure, glpi-cache-configure)
- **GLPI_CronJob**: The scheduled job (glpi-cronjob) that runs GLPI maintenance tasks every 2 minutes

## Requirements

### Requirement 1

**User Story:** As a Helm chart user, I want to enable or disable individual GLPI jobs through the values file, so that I can control which initialization tasks run during deployment

#### Acceptance Criteria

1. WHEN the user sets a job's enabled flag to false in the Values_File, THE Helm_Chart SHALL exclude that Job from the rendered Kubernetes manifests
2. WHEN the user sets a job's enabled flag to true in the Values_File, THE Helm_Chart SHALL include that Job in the rendered Kubernetes manifests
3. WHEN the user does not specify an enabled flag for a job in the Values_File, THE Helm_Chart SHALL default to enabled state with value true
4. THE Helm_Chart SHALL provide separate enabled flags for each of the five GLPI_Jobs (glpi-verify-dir, glpi-db-install, glpi-db-upgrade, glpi-db-configure, glpi-cache-configure)
5. THE Helm_Chart SHALL provide an enabled flag for the GLPI_CronJob

### Requirement 2

**User Story:** As a Helm chart user, I want the values file to have clear documentation for each job's purpose, so that I can make informed decisions about which jobs to enable or disable

#### Acceptance Criteria

1. THE Values_File SHALL include a comment describing the purpose of the glpi-verify-dir job
2. THE Values_File SHALL include a comment describing the purpose of the glpi-db-install job
3. THE Values_File SHALL include a comment describing the purpose of the glpi-db-upgrade job
4. THE Values_File SHALL include a comment describing the purpose of the glpi-db-configure job
5. THE Values_File SHALL include a comment describing the purpose of the glpi-cache-configure job
6. THE Values_File SHALL include a comment describing the purpose of the glpi-cronjob

### Requirement 3

**User Story:** As a Helm chart user, I want the job configuration to be organized logically in the values file, so that I can easily find and modify job settings

#### Acceptance Criteria

1. THE Values_File SHALL group all job-related configuration under a dedicated "jobs" section within the glpi configuration
2. THE Values_File SHALL group the cronjob configuration under a dedicated "cronjob" section within the glpi configuration
3. THE Helm_Chart SHALL maintain backward compatibility by defaulting all jobs to enabled when upgrading from previous chart versions
4. THE Values_File SHALL use consistent YAML structure with "enabled" as a boolean field for each job

### Requirement 4

**User Story:** As a Helm chart maintainer, I want the template files to use conditional logic for job rendering, so that disabled jobs are completely excluded from the deployment

#### Acceptance Criteria

1. WHEN a job's enabled flag evaluates to false, THE Template_File SHALL not render any Kubernetes manifest for that Job
2. WHEN a job's enabled flag evaluates to true, THE Template_File SHALL render the complete Kubernetes manifest for that Job with all existing specifications
3. THE Template_File SHALL preserve all existing job specifications including containers, volumes, environment variables, and restart policies
4. THE Template_File SHALL use Helm's conditional template syntax to evaluate the enabled flag
5. THE Template_File SHALL maintain the existing YAML document separator (---) structure between multiple jobs
