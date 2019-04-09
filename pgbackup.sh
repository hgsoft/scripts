#!/bin/bash
# pgbackup.sh - Backup do PostgreSQL
# Criado em 2015-05-04 por Alexsandro Haag (alex@hgsoft.com.br)

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
date

