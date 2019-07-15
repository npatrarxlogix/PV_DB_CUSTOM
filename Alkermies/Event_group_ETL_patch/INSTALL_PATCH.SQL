PROMPT ************************Customer Code Installation*****************************
ACCEPT SPOOL_PATH PROMPT "Enter the file location for saving log (e.g.  D:\Logs_file.log): "
SPOOL &SPOOL_PATH
SET SERVEROUTPUT ON SIZE 1000000
DEFINE FILE_SEP = '\'
@USER_PARAMETERS.SQL

ACCEPT USERRO_PWD PROMPT "Enter password for RO user: "  HIDE
ACCEPT USERST_PWD PROMPT "Enter password for STAGE user: "  HIDE

PROMPT Executing connect RO script
@CONNECT_RO.SQL
@CREATE_RO_TABLES.SQL

PROMPT Executing connect stage script
@CONNECT_STAGE.SQL
@GRANTS_STAGE_TO_RO.SQL


SET SERVEROUTPUT OFF

SPOOL OFF
