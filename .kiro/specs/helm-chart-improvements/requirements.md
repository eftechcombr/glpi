# Requirements Document

## Introduction

This document defines requirements for improving the GLPI Kubernetes Helm chart. The current chart has hardcoded values in templates and uses a generic values.yaml file that doesn't expose GLPI-specific configurations. The improvements will make the chart configurable, production-ready, and follow Helm best practices.

## Glossary

- **Helm_Chart**: A package format for Kubernetes applications containing templates and configuration values
- **GLPI_Application**: The GLPI IT asset management application consisting of PHP-FPM and Nginx containers
- **Values_File**: The values.yaml file that exposes configurable parameters for the Helm chart
- **Template_Files**: Kubernetes manifest templates that use values from the Values_File
- **MariaDB_Component**: The database backend for GLPI_Application
- **Redis_Component**: The caching layer for GLPI_Application
- **Chart_User**: A person deploying the Helm_Chart to a Kubernetes cluster

## Requirements

### Requirement 1

**User Story:** As a Chart_User, I want to configure GLPI application settings through values.yaml, so that I can customize the deployment without modifying templates

#### Acceptance Criteria

1. THE Helm_Chart SHALL expose GLPI version configuration in the Values_File
2. THE Helm_Chart SHALL expose GLPI language configuration in the Values_File
3. THE Helm_Chart SHALL expose GLPI directory paths configuration in the Values_File
4. THE Helm_Chart SHALL expose GLPI image repository and tag configuration in the Values_File
5. THE Helm_Chart SHALL replace hardcoded GLPI configuration values in Template_Files with references to the Values_File

### Requirement 2

**User Story:** As a Chart_User, I want to configure MariaDB settings through values.yaml, so that I can adjust database resources and credentials for my environment

#### Acceptance Criteria

1. THE Helm_Chart SHALL expose MariaDB image configuration in the Values_File
2. THE Helm_Chart SHALL expose MariaDB resource limits and requests in the Values_File
3. THE Helm_Chart SHALL expose MariaDB replica count in the Values_File
4. THE Helm_Chart SHALL expose MariaDB storage size configuration in the Values_File
5. THE Helm_Chart SHALL expose MariaDB connection parameters in the Values_File

### Requirement 3

**User Story:** As a Chart_User, I want to configure Redis settings through values.yaml, so that I can optimize caching for my workload

#### Acceptance Criteria

1. THE Helm_Chart SHALL expose Redis image configuration in the Values_File
2. THE Helm_Chart SHALL expose Redis resource limits and requests in the Values_File
3. THE Helm_Chart SHALL expose Redis replica count in the Values_File
4. THE Helm_Chart SHALL expose Redis enable or disable option in the Values_File

### Requirement 4

**User Story:** As a Chart_User, I want to configure persistent storage for GLPI, so that I can use appropriate storage classes and sizes for my cluster

#### Acceptance Criteria

1. THE Helm_Chart SHALL expose storage class configuration for GLPI volumes in the Values_File
2. THE Helm_Chart SHALL expose storage size configuration for each GLPI volume in the Values_File
3. THE Helm_Chart SHALL expose storage class configuration for MariaDB volumes in the Values_File
4. THE Helm_Chart SHALL expose storage size configuration for MariaDB volumes in the Values_File
5. THE Helm_Chart SHALL expose access mode configuration for persistent volumes in the Values_File

### Requirement 5

**User Story:** As a Chart_User, I want to configure resource limits for GLPI containers, so that I can ensure proper resource allocation in my cluster

#### Acceptance Criteria

1. THE Helm_Chart SHALL expose CPU and memory limits for PHP-FPM container in the Values_File
2. THE Helm_Chart SHALL expose CPU and memory requests for PHP-FPM container in the Values_File
3. THE Helm_Chart SHALL expose CPU and memory limits for Nginx container in the Values_File
4. THE Helm_Chart SHALL expose CPU and memory requests for Nginx container in the Values_File
5. THE Helm_Chart SHALL apply resource configurations from Values_File to Template_Files

### Requirement 6

**User Story:** As a Chart_User, I want to configure replica counts for GLPI components, so that I can scale the application based on load

#### Acceptance Criteria

1. THE Helm_Chart SHALL expose replica count for PHP-FPM deployment in the Values_File
2. THE Helm_Chart SHALL expose replica count for Nginx deployment in the Values_File
3. THE Helm_Chart SHALL apply replica count configurations from Values_File to Template_Files

### Requirement 7

**User Story:** As a Chart_User, I want to configure ingress settings properly, so that I can expose GLPI with my ingress controller

#### Acceptance Criteria

1. THE Helm_Chart SHALL expose ingress hostname configuration in the Values_File with GLPI-appropriate defaults
2. THE Helm_Chart SHALL expose ingress TLS configuration in the Values_File
3. THE Helm_Chart SHALL expose ingress annotations in the Values_File
4. THE Helm_Chart SHALL configure ingress to route to the Nginx service
5. THE Helm_Chart SHALL remove HTTPRoute configuration as it is not used by GLPI_Application

### Requirement 8

**User Story:** As a Chart_User, I want namespace configuration to be optional, so that I can deploy GLPI to my preferred namespace

#### Acceptance Criteria

1. THE Helm_Chart SHALL expose namespace configuration in the Values_File
2. THE Helm_Chart SHALL use Helm release namespace when namespace is not specified in Values_File
3. THE Helm_Chart SHALL remove hardcoded namespace references from Template_Files
4. THE Helm_Chart SHALL apply namespace from Values_File or release namespace to all Template_Files

### Requirement 9

**User Story:** As a Chart_User, I want proper health check configurations, so that Kubernetes can manage GLPI container lifecycle correctly

#### Acceptance Criteria

1. THE Helm_Chart SHALL expose liveness probe configuration for PHP-FPM in the Values_File
2. THE Helm_Chart SHALL expose readiness probe configuration for PHP-FPM in the Values_File
3. THE Helm_Chart SHALL expose liveness probe configuration for Nginx in the Values_File
4. THE Helm_Chart SHALL expose readiness probe configuration for Nginx in the Values_File
5. THE Helm_Chart SHALL configure appropriate probe paths for GLPI_Application

### Requirement 10

**User Story:** As a Chart_User, I want to configure service types, so that I can expose GLPI using LoadBalancer or NodePort if needed

#### Acceptance Criteria

1. THE Helm_Chart SHALL expose service type configuration for Nginx service in the Values_File
2. THE Helm_Chart SHALL expose service port configuration for Nginx service in the Values_File
3. THE Helm_Chart SHALL expose service type configuration for MariaDB service in the Values_File
4. THE Helm_Chart SHALL expose service type configuration for Redis service in the Values_File

### Requirement 11

**User Story:** As a Chart_User, I want security context configurations exposed, so that I can run GLPI with appropriate security policies

#### Acceptance Criteria

1. THE Helm_Chart SHALL expose pod security context configuration in the Values_File
2. THE Helm_Chart SHALL expose container security context configuration in the Values_File
3. THE Helm_Chart SHALL apply security context configurations from Values_File to Template_Files
4. THE Helm_Chart SHALL configure appropriate security contexts for unprivileged Nginx container

### Requirement 12

**User Story:** As a Chart_User, I want the Chart metadata to reflect GLPI, so that the chart is properly identified

#### Acceptance Criteria

1. THE Helm_Chart SHALL update Chart.yaml description to reference GLPI
2. THE Helm_Chart SHALL update Chart.yaml appVersion to match GLPI version
3. THE Helm_Chart SHALL remove generic placeholder comments from Values_File
4. THE Helm_Chart SHALL add GLPI-specific documentation comments to Values_File
