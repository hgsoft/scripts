#!/bin/bash
# orasoftrestore.sh - Teste de restauracao do Oracle
# Criado em 2009-08-17 por Alexsandro Haag (infra@cigam.com.br)

#Parametros e variavei gerais
export ORACLE_HOME=/home/oracle/product/10.2.0/db_1
export ORACLE_SID=cigam
export PATH=$ORACLE_HOME/bin:$PATH

#Caminho da restauracao
RESTORE_DIR=/home/oracle/restore

#Usuario Oracle para restauracao
ORALOGIN=backup/backup@$ORACLE_SID

#Pega dia da semana
if [ $1 == '' ]; 
then
    SEMANA=$(date |sed '1!d' |awk '{print $1}')
else
    SEMANA=$1
fi

#Parametros para o arquivo de backup
BKPFILE=$RESTORE_DIR/$HOSTNAME-orasoftbackup-$SEMANA.tar.bz2
TAR_PAR=Pxjvf

#Parametros para o restore
DMPFILE=$RESTORE_DIR/home/oracle/backup/tmp/$HOSTNAME-oracigam-$SEMANA.dmp
FROMUSER=CIGAM
TOUSER=CIGAMRESTORE

if [ -f $BKPFILE ]; 
then
    echo "$0: Descompactando arquivo de backup..."
    tar $TAR_PAR $BKPFILE 
else
    echo "$0: Arquivo $BKPFILE nao existe!"
    exit 0
fi

echo "$0: Preparando o ambiente..."
sqlplus $ORALOGIN @orasoftrestore.sql

if [ -f $DMPFILE ]; 
then
    echo "$0: Restaurando o banco..."
    imp $ORALOGIN file=$DMPFILE fromuser=$FROMUSER touser=$TOUSER statistics=none
else
    echo "$0: Arquivo $DMPFILE nao existe!"
    exit 0
fi

echo "$0: Apagando arquivos apos processo de restore..."
rm -rf $$RESTORE_DIR/home/oracle/backup/tmp/
rm -rf $RESTORE_DIR/$BKPFILE

echo "$0: Processo Concluido!"

