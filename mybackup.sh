#!/bin/bash
# mybackup.sh - Backup do mySQL
# Criado em 2018-03-29 por Matheus Adriano Haag (matheus@hgsoft.com.br)
#
# Exemplo de agendamento no crontab
# 00 23 * * * /opt/hgsoft/projetos/backup/mybackup.sh > /tmp/mybackup.log

BACKUP_DIR=/home/matheus/dev/src/masterplast
TEMP_DIR=/tmp
DMPFILE=bases.backup
LOGFILE=mybackup.log
SEMANA=$(date +%A)
BKPFILE=bases-$SEMANA

BKPFORMAT=tar.bz2
TAR_PAR=Pcjvf

date
rm -rf $BACKUP_DIR/$BKPFILE.$BKPFORMAT
/usr/bin/mysqldump -u root -proot --all-databases --log-error $TEMP_DIR/$LOGFILE > $TEMP_DIR/$DMPFILE
tar $TAR_PAR $BACKUP_DIR/$BKPFILE.$BKPFORMAT $TEMP_DIR/$DMPFILE $TEMP_DIR/$LOGFILE
rm -rf $TEMP_DIR/$DMPFILE
rm -rf $TEMP_DIR/$LOGFILE
date
