Enter password for PVD STAGE user: 
Enter password for PVD HUB user: 
Executing connect PVD HUB script
Connected.

PL/SQL procedure successfully completed.


Table created.


Table altered.

old   1: GRANT SELECT,INSERT,UPDATE,DELETE ON &usertx..activesubstance_addl TO &userst.
new   1: GRANT SELECT,INSERT,UPDATE,DELETE ON pvd_hub.activesubstance_addl TO pvd_stage

Grant succeeded.

Executing connect PVD STAGE script
Connected.

PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


View created.


PL/SQL procedure successfully completed.


Table created.


PL/SQL procedure successfully completed.


Package created.


Package body created.


PL/SQL procedure successfully completed.


Procedure created.


PL/SQL procedure successfully completed.


Table created.


Table altered.


Table created.


Table altered.


Table created.


Table altered.

old   1: CREATE OR REPLACE SYNONYM &userst..activesubstance_addl FOR &usertx..activesubstance_addl
new   1: CREATE OR REPLACE SYNONYM pvd_stage.activesubstance_addl FOR pvd_hub.activesubstance_addl

Synonym created.


Table created.


Table altered.


Procedure created.


Procedure created.


Procedure created.


Procedure created.


Procedure created.


Procedure created.


Procedure created.


Procedure created.

old   1: GRANT EXECUTE ON &USERST..P_POP_ACKNOWLEDGMENT_ADDL TO &USERTX. 
new   1: GRANT EXECUTE ON pvd_stage.P_POP_ACKNOWLEDGMENT_ADDL TO pvd_hub 

Grant succeeded.

old   1: GRANT EXECUTE ON &USERST..P_POP_E2B_INFO TO &USERTX. 
new   1: GRANT EXECUTE ON pvd_stage.P_POP_E2B_INFO TO pvd_hub 

Grant succeeded.

old   1: GRANT EXECUTE ON &USERST..P_POP_MESSAGES_ADDL TO &USERTX. 
new   1: GRANT EXECUTE ON pvd_stage.P_POP_MESSAGES_ADDL TO pvd_hub 

Grant succeeded.

old   1: GRANT EXECUTE ON &USERST..P_POP_ACTIVESUBSTANCE_ADDL TO &USERTX. 
new   1: GRANT EXECUTE ON pvd_stage.P_POP_ACTIVESUBSTANCE_ADDL TO pvd_hub 

Grant succeeded.

old   1: GRANT EXECUTE ON &USERST..P_CUSTOM_E2B_MASTER_SCRIPT TO &USERTX. 
new   1: GRANT EXECUTE ON pvd_stage.P_CUSTOM_E2B_MASTER_SCRIPT TO pvd_hub 

Grant succeeded.

old   1: GRANT EXECUTE ON &USERST..P_UPDATE_E2B_TABLES TO &USERTX. 
new   1: GRANT EXECUTE ON pvd_stage.P_UPDATE_E2B_TABLES TO pvd_hub 

Grant succeeded.

old   1: GRANT SELECT,INSERT,DELETE,UPDATE ON &USERST..e2b_info_temp TO &USERTX. 
new   1: GRANT SELECT,INSERT,DELETE,UPDATE ON pvd_stage.e2b_info_temp TO pvd_hub 

Grant succeeded.

old   1: GRANT SELECT,INSERT,DELETE,UPDATE ON &USERST..messages_addl_temp TO &USERTX. 
new   1: GRANT SELECT,INSERT,DELETE,UPDATE ON pvd_stage.messages_addl_temp TO pvd_hub 

Grant succeeded.

old   1: GRANT SELECT,INSERT,DELETE,UPDATE ON &USERST..acknowledgment_addl_temp TO &USERTX. 
new   1: GRANT SELECT,INSERT,DELETE,UPDATE ON pvd_stage.acknowledgment_addl_temp TO pvd_hub 

Grant succeeded.

old   1: GRANT SELECT,INSERT,DELETE,UPDATE ON &USERST..act_subs_addl_temp TO &USERTX. 
new   1: GRANT SELECT,INSERT,DELETE,UPDATE ON pvd_stage.act_subs_addl_temp TO pvd_hub 

Grant succeeded.

Executing connect PVD HUB script
Connected.
old   1: CREATE OR REPLACE SYNONYM &USERTX..P_POP_ACKNOWLEDGMENT_ADDL FOR &USERST..P_POP_ACKNOWLEDGMENT_ADDL 
new   1: CREATE OR REPLACE SYNONYM pvd_hub.P_POP_ACKNOWLEDGMENT_ADDL FOR pvd_stage.P_POP_ACKNOWLEDGMENT_ADDL 

Synonym created.

old   1: CREATE OR REPLACE SYNONYM &USERTX..P_POP_E2B_INFO FOR &USERST..P_POP_E2B_INFO 
new   1: CREATE OR REPLACE SYNONYM pvd_hub.P_POP_E2B_INFO FOR pvd_stage.P_POP_E2B_INFO 

Synonym created.

old   1: CREATE OR REPLACE SYNONYM &USERTX..P_POP_MESSAGES_ADDL FOR &USERST..P_POP_MESSAGES_ADDL 
new   1: CREATE OR REPLACE SYNONYM pvd_hub.P_POP_MESSAGES_ADDL FOR pvd_stage.P_POP_MESSAGES_ADDL 

Synonym created.

old   1: CREATE OR REPLACE SYNONYM &USERTX..P_POP_ACTIVESUBSTANCE_ADDL FOR &USERST..P_POP_ACTIVESUBSTANCE_ADDL 
new   1: CREATE OR REPLACE SYNONYM pvd_hub.P_POP_ACTIVESUBSTANCE_ADDL FOR pvd_stage.P_POP_ACTIVESUBSTANCE_ADDL 

Synonym created.

old   1: CREATE OR REPLACE SYNONYM &USERTX..P_CUSTOM_E2B_MASTER_SCRIPT FOR &USERST..P_CUSTOM_E2B_MASTER_SCRIPT 
new   1: CREATE OR REPLACE SYNONYM pvd_hub.P_CUSTOM_E2B_MASTER_SCRIPT FOR pvd_stage.P_CUSTOM_E2B_MASTER_SCRIPT 

Synonym created.

old   1: CREATE OR REPLACE SYNONYM &USERTX..P_UPDATE_E2B_TABLES FOR &USERST..P_UPDATE_E2B_TABLES 
new   1: CREATE OR REPLACE SYNONYM pvd_hub.P_UPDATE_E2B_TABLES FOR pvd_stage.P_UPDATE_E2B_TABLES 

Synonym created.

old   1: CREATE OR REPLACE SYNONYM &USERTX..acknowledgment_addl_temp FOR &USERST..acknowledgment_addl_temp 
new   1: CREATE OR REPLACE SYNONYM pvd_hub.acknowledgment_addl_temp FOR pvd_stage.acknowledgment_addl_temp 

Synonym created.

old   1: CREATE OR REPLACE SYNONYM &USERTX..messages_addl_temp FOR &USERST..messages_addl_temp 
new   1: CREATE OR REPLACE SYNONYM pvd_hub.messages_addl_temp FOR pvd_stage.messages_addl_temp 

Synonym created.

old   1: CREATE OR REPLACE SYNONYM &USERTX..e2b_info_temp FOR &USERST..e2b_info_temp 
new   1: CREATE OR REPLACE SYNONYM pvd_hub.e2b_info_temp FOR pvd_stage.e2b_info_temp 

Synonym created.

old   1: CREATE OR REPLACE SYNONYM &USERTX..act_subs_addl_temp FOR &USERST..act_subs_addl_temp 
new   1: CREATE OR REPLACE SYNONYM pvd_hub.act_subs_addl_temp FOR pvd_stage.act_subs_addl_temp 

Synonym created.

