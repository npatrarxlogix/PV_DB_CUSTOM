create or replace PROCEDURE P_M_PROJECT_INDICATION(PI_MODE VARCHAR2) as
    ln_row_cnt           NUMBER;
    l_seq_num            NUMBER;
    l_target_sql         CLOB;
    l_etl_execution_id   NUMBER := pvd_cstm_seq.currval;
	l_stg_tab_name       VARCHAR2(4000);
    l_tgt_tab_name       VARCHAR2(4000);
BEGIN
IF pi_mode = 'INIT' THEN
--------------------------------------------------------
--  Populating Table PROJECT_INDICATION_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_PROJECT_INDICATION''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_PROJECT_INDICATION''' INTO l_stg_tab_name;
        l_target_sql := 'INSERT INTO '||l_tgt_tab_name||'(PROJECT_INDICATION_EID, PROJECT_INDICATION_EID_AUTHO,PROJECT_EREF,PROJECT_EREF_AUTHORITY
            ,GG_COMMIT_TIME,PVR_LAST_UPDATE_TIME,PVR_LAST_UPDATE_BY,BATCH,PARTITION)
        SELECT
            PROJECT_INDICATION_EID,PROJECT_INDICATION_EID_AUTHO,PROJECT_EREF,PROJECT_EREF_AUTHORITY
			,GG_COMMIT_TIME,SYSDATE PVR_LAST_UPDATE_TIME, ''RXL'' PVR_LAST_UPDATE_BY,BATCH,PARTITION
        FROM '||l_stg_tab_name
;
        pkg_cstm_obj.p_ins_etl_logging(l_seq_num,l_tgt_tab_name,l_etl_execution_id,'POPULATE MART TABLE','START',l_target_sql);
 			

EXECUTE IMMEDIATE l_target_sql;
        ln_row_cnt := SQL%rowcount;
        pkg_cstm_obj.p_updt_etl_logging(ln_row_cnt,'SUCCESS',l_seq_num);
    EXCEPTION
        WHEN OTHERS THEN
            pkg_cstm_obj.p_ins_exception(l_tgt_tab_name,'POPULATE MART TABLE',sqlcode,sqlerrm,l_target_sql);
            pkg_cstm_obj.p_updt_etl_logging(NULL,'FAILED',l_seq_num);
            RAISE;
    END;
	
	COMMIT;
	
END IF;
IF pi_mode = 'INCR' THEN 
--------------------------------------------------------
--  Populating Table PROJECT_INDICATION_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_PROJECT_INDICATION''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_PROJECT_INDICATION''' INTO l_stg_tab_name;
        l_target_sql := 'MERGE INTO '||l_tgt_tab_name||' ttn USING (
   SELECT
            PROJECT_INDICATION_EID,PROJECT_INDICATION_EID_AUTHO,PROJECT_EREF,PROJECT_EREF_AUTHORITY
			,GG_COMMIT_TIME,SYSDATE PVR_LAST_UPDATE_TIME, ''RXL'' PVR_LAST_UPDATE_BY,BATCH,PARTITION
        FROM '||l_stg_tab_name||'
)
stn ON (
    ttn.PROJECT_INDICATION_EID = stn.PROJECT_INDICATION_EID
    AND ttn.PROJECT_INDICATION_EID_AUTHO = stn.PROJECT_INDICATION_EID_AUTHO
)
WHEN MATCHED THEN UPDATE SET ttn.PROJECT_EREF = stn.PROJECT_EREF,
ttn.PROJECT_EREF_AUTHORITY = stn.PROJECT_EREF_AUTHORITY,
ttn.GG_COMMIT_TIME = stn.GG_COMMIT_TIME,
ttn.PVR_LAST_UPDATE_TIME = stn.PVR_LAST_UPDATE_TIME,
ttn.PVR_LAST_UPDATE_BY = stn.PVR_LAST_UPDATE_BY,
ttn.BATCH = stn.BATCH,
ttn.PARTITION = stn.PARTITION
WHEN NOT MATCHED THEN INSERT (			 
	PROJECT_INDICATION_EID,
	PROJECT_INDICATION_EID_AUTHO,
	PROJECT_EREF,
	PROJECT_EREF_AUTHORITY,
	GG_COMMIT_TIME,
	PVR_LAST_UPDATE_TIME,
	PVR_LAST_UPDATE_BY,
	BATCH,
	PARTITION
    )
	VALUES
	(
	stn.PROJECT_INDICATION_EID,
	stn.PROJECT_INDICATION_EID_AUTHO,
	stn.PROJECT_EREF,
	stn.PROJECT_EREF_AUTHORITY,
    stn.GG_COMMIT_TIME,
	stn.PVR_LAST_UPDATE_TIME,
	stn.PVR_LAST_UPDATE_BY,
    stn.BATCH,
	stn.PARTITION
   )'
;
        pkg_cstm_obj.p_ins_etl_logging(l_seq_num,l_tgt_tab_name,l_etl_execution_id,'POPULATE MART TABLE','START',l_target_sql);
 			

EXECUTE IMMEDIATE l_target_sql;
        ln_row_cnt := SQL%rowcount;
        pkg_cstm_obj.p_updt_etl_logging(ln_row_cnt,'SUCCESS',l_seq_num);
    EXCEPTION
        WHEN OTHERS THEN
            pkg_cstm_obj.p_ins_exception(l_tgt_tab_name,'POPULATE MART TABLE',sqlcode,sqlerrm,l_target_sql);
            pkg_cstm_obj.p_updt_etl_logging(NULL,'FAILED',l_seq_num);
            RAISE;
    END;


	
end if;
end;
/