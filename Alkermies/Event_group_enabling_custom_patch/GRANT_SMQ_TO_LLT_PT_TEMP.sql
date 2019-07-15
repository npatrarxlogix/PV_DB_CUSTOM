BEGIN 

EXECUTE IMMEDIATE ' grant select on meddra_smq_to_llt_pt_temp TO &USERTX. with grant option';

END; 
/ 