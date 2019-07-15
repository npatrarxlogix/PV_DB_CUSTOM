PROMPT ************************Customer Code Installation*****************************
ACCEPT SPOOL_PATH PROMPT "Enter the file location for saving log (e.g.  D:\Logs_file.log): "
SPOOL &SPOOL_PATH
SET SERVEROUTPUT ON SIZE 1000000
DEFINE FILE_SEP = '\'
@USER_PARAMETERS.SQL

ACCEPT USERTX_PWD PROMPT "Enter password for MART user: "  HIDE
ACCEPT USERTXAPP_PWD PROMPT "Enter password for APP user: "  HIDE

PROMPT Executing connect mart script
@CONNECT_MART.SQL
@V_C_MASTER_ADDL_CSTM.SQL
@GRANTS_MART_TO_APP.SQL

PROMPT Executing connect app script
@CONNECT_APP.SQL
@SYNONYMS_APP.SQL

SET SERVEROUTPUT OFF

SPOOL OFF
