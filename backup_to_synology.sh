#!/bin/bash

# This script is used to backup my DigitalOcean dropplet (Wordpress, Wiki and MySQL DB) into my Synology

email_address='egomezm@gmail.com';
synology_host='yvoictra.noip.me';
date=`date "+%Y%m%d"`;

mkdir -p /root/backup_shasta/$date

# Comprimimos el directorio /var/www/egomezm.es
tar -czf /root/backup_shasta/$date/egomezm.es.tar.gz /var/www/egomezm.es
# Comprimimos el directorio /var/www/wiki.egomezm.es
tar -czf /root/backup_shasta/$date/wiki.egomezm.es.tar.gz /var/www/wiki.egomezm.es/*
# Dump de la BBDD egomezm_es_wp
mysqldump -u rsync -prsync egomezm_es_wp > /root/backup_shasta/$date/dump_egomezm_es_wp.sql
tar -czf /root/backup_shasta/$date/dump_egomezm_es_wp.sql.tar.gz /root/backup_shasta/$date/dump_egomezm_es_wp.sql
/bin/rm /root/backup_shasta/$date/dump_egomezm_es_wp.sql

# Envio del backup al Synology
rsync -e "ssh -p 2222" -av /root/backup_shasta/$date rsync@$synology_host:/volume1/backup/backup_shasta;

print -$res_rsync-;

/bin/rm -r /root/backup_shasta

/usr/sbin/sendmail "$email_address" <<EOF
subject:[Backup] Shasta backup finished [`date`]
It has been successfully done the backup. $date.

$res_rsync

EOF
