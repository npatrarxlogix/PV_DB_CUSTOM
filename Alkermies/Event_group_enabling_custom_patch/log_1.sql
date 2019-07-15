Enter password for MART user: 
Enter password for APP user: 
Enter password for STAGE user: 
Executing connect stage script
Connected.

Table created.


Table created.


2 rows updated.


1 row updated.


1 row updated.


Commit complete.

old   3: EXECUTE IMMEDIATE ' grant select on meddra_smq_to_llt_pt_temp TO &USERTX. with grant option';
new   3: EXECUTE IMMEDIATE ' grant select on meddra_smq_to_llt_pt_temp TO IA_APP_03 with grant option';

PL/SQL procedure successfully completed.

Executing connect MART script
Connected.

View created.

old   3: EXECUTE IMMEDIATE ' grant select on VW_LEG_GROUP_CSTM TO &USERTXAPP.';
new   3: EXECUTE IMMEDIATE ' grant select on VW_LEG_GROUP_CSTM TO IA_APP_02';

PL/SQL procedure successfully completed.

Executing connect app script
Connected.
old   3: EXECUTE IMMEDIATE ' CREATE OR REPLACE SYNONYM VW_LEG_GROUP_CSTM FOR &USERTX..VW_LEG_GROUP_CSTM';
new   3: EXECUTE IMMEDIATE ' CREATE OR REPLACE SYNONYM VW_LEG_GROUP_CSTM FOR IA_APP_03.VW_LEG_GROUP_CSTM';

PL/SQL procedure successfully completed.

