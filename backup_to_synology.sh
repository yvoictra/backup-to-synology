#!/bin/bash

email_address='egomezm@gmail.com';

fecha=`date "+%Y%m%d"`;

mkdir -p /root/backup_shasta/$fecha

# Comprimimos el directorio /var/www/egomezm.es
tar -czf /root/backup_shasta/$fecha/egomezm.es.tar.gz /var/www/egomezm.es
# Comprimimos el directorio /var/www/wiki.egomezm.es
tar -czf /root/backup_shasta/$fecha/wiki.egomezm.es.tar.gz /var/www/wiki.egomezm.es/*
# Dump de la BBDD egomezm_es_wp
mysqldump -u rsync -prsync egomezm_es_wp > /root/backup_shasta/$fecha/dump_egomezm_es_wp.sql
tar -czf /root/backup_shasta/$fecha/dump_egomezm_es_wp.sql.tar.gz /root/backup_shasta/$fecha/dump_egomezm_es_wp.sql
/bin/rm /root/backup_shasta/$fecha/dump_egomezm_es_wp.sql

# Envio del backup al Synology
rsync -e "ssh -p 2222" -av /root/backup_shasta/$fecha rsync@yvoictra.noip.me:/volume1/backup/backup_shasta

/bin/rm -r /root/backup_shasta

/usr/sbin/sendmail "$email_address" <<EOF
subject:[Backup] Shasta backup finalizado [`date`]
Se ha realizado con exito el backup $fecha.
EOF
