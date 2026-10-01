# Glossary & Domain Concepts

## Glossary & Domain Concepts

This section defines key terminology used throughout the project.

## Type Definitions

- **GLPI**: IT Asset Management and Service Desk system
- **ITIL**: Information Technology Infrastructure Library
- **PVC**: Persistent Volume Claim (Kubernetes)
- **HPA**: Horizontal Pod Autoscaler (Kubernetes)
- **PDB**: Pod Disruption Budget (Kubernetes)

## Enumerations

- **GLPI Status**: New, Assigned, Planned, Pending, Solved, Closed
- **Ticket Priority**: 1 (Very low) to 5 (Very high)
- **Ticket Urgency**: 1 to 5
- **Ticket Impact**: 1 to 5

## Core Terms

- **GLPI**: The core application — IT asset management and service desk
- **PHP-FPM**: PHP FastCGI Process Manager — runs GLPI application code
- **Nginx**: Web server and reverse proxy
- **MariaDB**: Relational database management system
- **Redis/Valkey**: In-memory data store used for caching
- **Helm**: Kubernetes package manager
- **Docker Compose**: Container orchestration for development

## Acronyms & Abbreviations

- **FPM**: FastCGI Process Manager
- **K8s**: Kubernetes
- **PVC**: Persistent Volume Claim
- **HPA**: Horizontal Pod Autoscaler
- **PDB**: Pod Disruption Budget
- **SLA**: Service Level Agreement
- **OLA**: Operational Level Agreement
- **ITSM**: IT Service Management
- **ITIL**: IT Infrastructure Library

## Personas / Actors

- **End User**: IT staff or employees using GLPI for ticketing and asset management
- **Administrator**: Manages GLPI configuration, plugins, and system settings
- **DevOps Engineer**: Deploys and maintains GLPI infrastructure
- **Developer**: Contributes to GLPI codebase or this deployment project

## Domain Rules & Invariants

- GLPI requires a database (MariaDB) for persistent storage
- GLPI requires a cache (Redis/Valkey) for optimal performance
- File uploads and marketplace plugins require persistent storage
- Database migrations must run before application startup
- All containers should run as non-root users for security
