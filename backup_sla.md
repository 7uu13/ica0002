# Backup SLA

## Coverage

We back up services that satisfy at least one of these criteria:
 - are primary source of truth for particular data
 - contain customer and/or client data
 - are not feasible (or very costly) to restore by other means

Services that are backed up:
 - Database Servers
 - InfluxDB
 - Ansible Repository


## Schedule

Mysql backups are created every 6 hours and it takes up to 30 minutes (depending on the size of the database) to create and store the backup.

InfluxDB backups are created every 12 hours and it takes up to 15 minutes to create and store the backup.

Ansible Repository backups are created every 30 minutes and it takes up to 5 minutes to create and store the backup.

All backups are started automatically by cron.

Backup RPO (recovery point objective) is:
 - 6 hours for Mysql
 - 12 hours for InfluxDB
 - 30 minutes for Ansible Repository


## Storage

Both Mysql and InfluxDB backups are uploaded to the backup server.

Ansible Repository is mirrored to the internal Git server.

Backup data from both servers will be synchronized to encrypted AWS S3 bucket in future (work in progress).


## Retention

MySQL backups are stored for 7 days;

InfluxDB backups are stored for 14 days;

Ansible repository backups are stored for 180 days;

## Usability checks

MySQL backups are verified every 24 hours by automated restore testing script.

InfluxDB backups are verified every 48 hours by automated restore testing script.

Ansible repository backups are verified every 24 hours by automated clone testing.

## Restore process

Service is recovered from the backup in case of an incident, and when service cannot be restored in any other way.

RTO (recovery time objective) is:
 - 30 minutes for MySQL 
 - 15 minutes for InfluxDB
 - 15 minutes for Ansible repository

Detailed backup restore procedure is documented in the [backup_restore.md](./backup_restore.md).
