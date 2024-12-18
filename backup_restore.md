# Install and configure infrastructure with Ansible:
```bash
ansible-playbook infra.yaml
```

## Restore MySQL data from the backup:
```bash 
sudo -u backup duplicity --no-encryption restore rsync://7uu13@backup/mysql/ /home/backup/restore/agama.sql
```
```bash
sudo -u root mysql agama < /home/backup/restore/agama.sql
```

#### Verify and check the result of the restored database in MySql:                         
---
```
```sql
USE database agama;

SELECT * FROM item;
```                                      

## Restore InfluxDB data from the backup:
```bash 
sudo -u backup duplicity --no-encryption restore rsync://7uu13@backup/influxdb/ /home/backup/restore/influxdb
```
---
```bash 
sudo systemctl stop telegraf
```
---
```bash 
influx -execute 'DROP DATABASE telegraf'                                           

sudo -u backup influxd restore -portable -db telegraf /home/backup/restore/influxdb 
```
---

#### Verify and check the result of the restored database in influx:
---                         
```bash 
influx
use telegraf
show series on telegraf
```             
---
