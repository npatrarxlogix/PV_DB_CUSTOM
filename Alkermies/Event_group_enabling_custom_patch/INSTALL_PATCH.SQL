PROMPT ************************Customer Code Installation*****************************
ACCEPT SPOOL_PATH PROMPT "Enter the file location for saving log (e.g.  D:\Logs_file.log): "
SPOOL &SPOOL_PATH
SET SERVEROUTPUT ON SIZE 1000000
DEFINE FILE_SEP = '\'
@USER_PARAMETERS.SQL

ACCEPT USERTX_PWD PROMPT "Enter password for MART user: "  HIDE
ACCEPT USERTXAPP_PWD PROMPT "Enter password for APP user: "  HIDE
ACCEPT USERST_PWD PROMPT "Enter password for STAGE user: "  HIDE

PROMPT Executing connect stage script
@CONNECT_STAGE.SQL
@CREATE_STAGE_TABLES.SQL
@GRANT_SMQ_TO_LLT_PT_TEMP.SQL

PROMPT Executing connect MART script
@CONNECT_MART.SQL
@VW_LEG_GROUP_CSTM.SQL
@GRANT_VW_LEG_GRP_CSTM.SQL
@Event_group_metadata.sql

PROMPT Executing connect app script
@CONNECT_APP.SQL
@SYNONYM_VW_LEG_GRP_CSTM.SQL

SET SERVEROUTPUT OFF

SPOOL OFF
