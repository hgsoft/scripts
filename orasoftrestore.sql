set verify off
set echo on
set heading off

spool orasoftrestore.log

select 'Iniciado em: ' || to_char(sysdate,'DD/MM/YYYY HH:MI:SS') from dual;

drop user cigamrestore cascade;

create user cigamrestore
identified by cigamrestore
default tablespace cigam_data
temporary tablespace temp;

grant connect,resource,create view to cigamrestore;

revoke unlimited tablespace from cigamrestore;

alter user cigamrestore
quota 0 on system
quota 0 on sysaux
quota unlimited on CIGAM_DATA
quota unlimited on CIGAM_INDEX;

select 'Finalizado em: ' || to_char(sysdate,'DD/MM/YYYY HH:MI:SS') from dual;

spool off

quit
