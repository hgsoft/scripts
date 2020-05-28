#!/bin/bash
# pgbackup.sh - Backup do PostgreSQL
# Criado em 2015-05-04 por Alexsandro Haag (alex@hgsoft.com.br)

#Registrando log no Painel
curl -u dev@hgsoft.com.br:159753hg -X POST -H "Content-Type: application/json" -d '{"project_name": "Backup Nuvem", "company_name": "HGSoft", "stage": "INICIO", "message": "Backup Iniciado - Postgres", "status": "OK", "date_time_sent": "'"$(date +%Y-%m-%dT%H:%M:%S)"'"}' --tlsv1 https://manager.hgsoft.com.br/logs

BACKUP_DIR=/opt/hgsoft/backup
TEMP_DIR=/tmp
DMPFILE=nuvem.backup
LOGFILE=pgbackup.log
SEMANA=$(date +%A)
BKPFILE=nuvem-$SEMANA

BKPFORMAT=tar.xz
TAR_PAR=PcJvf

date
rm -rf $BACKUP_DIR/$BKPFILE.$BKPFORMAT
/usr/bin/pg_dumpall --username postgres --no-password --verbose --file "$TEMP_DIR/$DMPFILE" > $TEMP_DIR/$LOGFILE
tar $TAR_PAR $BACKUP_DIR/$BKPFILE.$BKPFORMAT $TEMP_DIR/$DMPFILE $TEMP_DIR/$LOGFILE
rm -rf $TEMP_DIR/$DMPFILE
rm -rf $TEMP_DIR/$LOGFILE

#Registrando log final no painel
curl -u dev@hgsoft.com.br:159753hg -X POST -H "Content-Type: application/json" -d '{"project_name": "Backup Nuvem", "company_name": "HGSoft", "stage": "FINAL", "message": "Backup Finalizado - Postgres", "status": "OK", "date_time_sent": "'"$(date +%Y-%m-%dT%H:%M:%S)"'"}' --tlsv1 https://manager.hgsoft.com.br/logs
date

