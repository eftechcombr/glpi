# Requirements Document

## Introduction

This feature adds database backup capability to the GLPI Docker deployment. The system will create MariaDB database backups and store them in the configured dump directory, with optional support for uploading backups to AWS S3 for off-site storage and disaster recovery.

## Glossary

- **GLPI**: IT Asset Management, IT Service Management and IT Help Desk software
- **Backup Script**: The shell script that performs database backup operations
- **Dump Directory**: The filesystem location where database backups are stored (GLPI_DUMP_DIR)
- **S3 Bucket**: Amazon Simple Storage Service bucket for remote backup storage (also compatible with MinIO)
- **MariaDB**: The relational database management system used by GLPI
- **mysqldump**: The MariaDB utility for creating database backups
- **Backup CronJob**: A Kubernetes CronJob resource that schedules automated backup execution
- **Retention Period**: The duration (7 days) after which old backup files are automatically deleted

## Requirements

### Requirement 1

**User Story:** As a system administrator, I want to create compressed database backups of my GLPI instance, so that I can restore data in case of failure or corruption while minimizing storage space.

#### Acceptance Criteria

1. WHEN the backup script is executed THEN the Backup Script SHALL create a SQL dump file and compress it to tar.gz format in the Dump Directory
2. WHEN creating a backup THEN the Backup Script SHALL use the MariaDB connection parameters from environment variables (MARIADB_HOST, MARIADB_PORT, MARIADB_DATABASE, MARIADB_USER, MARIADB_PASSWORD)
3. WHEN generating the backup filename THEN the Backup Script SHALL include a timestamp in ISO 8601 format to ensure uniqueness
4. WHEN the backup completes successfully THEN the Backup Script SHALL exit with status code 0
5. WHEN the backup fails THEN the Backup Script SHALL exit with a non-zero status code and output an error message
6. WHEN compression completes THEN the Backup Script SHALL remove the intermediate uncompressed SQL file

### Requirement 2

**User Story:** As a system administrator, I want backups to be stored with descriptive filenames, so that I can easily identify and manage backup files.

#### Acceptance Criteria

1. WHEN creating a backup file THEN the Backup Script SHALL name the file using the pattern "glpi-backup-YYYY-MM-DD-HH-MM-SS.tar.gz"
2. WHEN the Dump Directory does not exist THEN the Backup Script SHALL create the directory before writing the backup file
3. WHEN writing the backup file THEN the Backup Script SHALL ensure the file has appropriate permissions for the www-data user

### Requirement 3

**User Story:** As a system administrator, I want to optionally upload backups to AWS S3 or MinIO, so that I have off-site backup storage for disaster recovery.

#### Acceptance Criteria

1. WHERE S3 upload is enabled, WHEN a backup completes successfully THEN the Backup Script SHALL upload the compressed backup file to the configured S3 bucket
2. WHERE S3 upload is enabled, WHEN the S3_BUCKET environment variable is not set THEN the Backup Script SHALL skip the upload and log a warning message
3. WHERE S3 upload is enabled, WHEN the S3 upload fails THEN the Backup Script SHALL log an error message but SHALL NOT delete the local backup file
4. WHERE S3 upload is enabled, WHEN uploading to S3 THEN the Backup Script SHALL use AWS CLI with credentials from environment variables or IAM roles
5. WHERE S3 upload is disabled or not configured, WHEN a backup completes THEN the Backup Script SHALL only store the backup locally
6. WHERE MinIO is used, WHEN the S3_ENDPOINT environment variable is set THEN the Backup Script SHALL use the custom endpoint for S3-compatible storage

### Requirement 4

**User Story:** As a system administrator, I want the backup script to provide clear feedback, so that I can monitor backup operations and troubleshoot issues.

#### Acceptance Criteria

1. WHEN the backup starts THEN the Backup Script SHALL output a message indicating the backup operation has begun
2. WHEN the backup completes successfully THEN the Backup Script SHALL output the backup file path and size
3. WHEN S3 upload is attempted THEN the Backup Script SHALL output the S3 destination path
4. WHEN any operation fails THEN the Backup Script SHALL output a descriptive error message to stderr
5. WHEN the script executes THEN the Backup Script SHALL follow the same output patterns as existing GLPI scripts (glpi-db-install.sh, glpi-db-configure.sh)

### Requirement 5

**User Story:** As a system administrator, I want old backup files to be automatically cleaned up, so that I can manage storage space without manual intervention.

#### Acceptance Criteria

1. WHEN the backup script executes THEN the Backup Script SHALL delete backup files in the Dump Directory older than 7 days
2. WHEN cleaning old backups THEN the Backup Script SHALL only delete files matching the pattern "glpi-backup-*.tar.gz"
3. WHEN no old backup files exist THEN the Backup Script SHALL continue without error
4. WHEN cleanup fails for a specific file THEN the Backup Script SHALL log a warning but SHALL continue processing other files
5. WHEN cleanup completes THEN the Backup Script SHALL output the number of files deleted

### Requirement 6

**User Story:** As a system administrator, I want backups to run automatically on a schedule, so that I have regular backups without manual intervention.

#### Acceptance Criteria

1. WHEN the Kubernetes deployment is applied THEN the system SHALL create a Backup CronJob resource
2. WHEN the CronJob is configured THEN the Backup CronJob SHALL execute the backup script daily at a configurable time
3. WHEN the CronJob executes THEN the Backup CronJob SHALL use the same Docker image and environment variables as the main GLPI deployment
4. WHEN the CronJob completes THEN the Backup CronJob SHALL retain logs from the last 3 successful executions and last 1 failed execution
5. WHEN the CronJob is disabled THEN the system SHALL allow administrators to set the schedule to an empty value or remove the CronJob resource

### Requirement 7

**User Story:** As a system administrator, I want the backup script to integrate with the existing GLPI Docker infrastructure, so that it works consistently with other database operations.

#### Acceptance Criteria

1. WHEN the script is deployed THEN the Backup Script SHALL be located at /usr/local/bin/glpi-db-backup.sh
2. WHEN the script is deployed THEN the Backup Script SHALL have executable permissions
3. WHEN the script runs THEN the Backup Script SHALL use the same environment variables as other GLPI database scripts
4. WHEN the script is added to the Docker image THEN the Backup Script SHALL be copied during the Docker build process in the Dockerfile
5. WHEN the script executes THEN the Backup Script SHALL run as the www-data user in the container context
