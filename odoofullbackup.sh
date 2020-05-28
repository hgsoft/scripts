#!/bin/bash
# Cria Backup Compactado
rm -Rf /opt/hgsoft/backup/backup-full-odoo*.tar.xz
tar -PcJvf /opt/hgsoft/backup/backup-full-odoo.tar.xz /opt/hgsoft/11/

