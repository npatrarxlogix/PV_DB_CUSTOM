BEGIN 

EXECUTE IMMEDIATE ' CREATE OR REPLACE SYNONYM VW_LEG_GROUP_CSTM FOR &USERTX..VW_LEG_GROUP_CSTM';

END;
/