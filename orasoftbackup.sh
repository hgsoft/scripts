
#!/bin/bash
# orabackup.sh - Backup Logico do Oracle
# Criado em 2008-02-01 por Alexsandro Haag (infra@cigam.com.br)

export ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server
export ORACLE_SID=XE
export PATH=$ORACLE_HOME/bin:$PATH

BACKUP_DIR=/oradata/backups
TEMP_DIR=$BACKUP_DIR/tmp
ORALOGIN=backup/backup@XE

SEMANA=$(date |sed '1!d' |awk '{print $1}')

DMPFILE=$HOSTNAME-oracigam-$SEMANA.dmp
LOGFILE=$HOSTNAME-oracigam-$SEMANA.log
BKPFILE=$HOSTNAME-orasoftbackup-$SEMANA

BKPFORMAT=tar.bz2
TAR_PAR=Pcjvf

rm -rf $BACKUP_DIR/$BKPFILE.$BKPFORMAT
exp $ORALOGIN full=y consistent=y file=$TEMP_DIR/$DMPFILE log=$TEMP_DIR/$LOGFILE statistics=none

#Restaurando backup no outro servidor Oracle
ORALOGIN=system/oracle@XE_W2003
sqlplus $ORALOGIN @restore.sql
imp $ORALOGIN file=$TEMP_DIR/$DMPFILE fromuser=cigamnovo touser=cigamrestore recordlength=65535 buffer=40000
sqlplus @ORALOGIN @restore_identifica.sql

#Compactando e removendo arquivo dump
tar $TAR_PAR $BACKUP_DIR/$BKPFILE.$BKPFORMAT $TEMP_DIR/$DMPFILE $TEMP_DIR/$LOGFILE
rm -rf $TEMP_DIR/$DMPFILE
rm -rf $TEMP_DIR/$LOGFILE

