create or replace PROCEDURE P_M_STUDY_DESIGN_FACTOR(PI_MODE VARCHAR2) as
    ln_row_cnt           NUMBER;
    l_seq_num            NUMBER;
    l_target_sql         CLOB;
    l_etl_execution_id   NUMBER := pvd_cstm_seq.currval;
	l_stg_tab_name       VARCHAR2(4000);
    l_tgt_tab_name       VARCHAR2(4000);
BEGIN
IF pi_mode = 'INIT' THEN
--------------------------------------------------------
--  Populating Table STUDY_DESIGN_FACTOR_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_DESIGN_FACTOR''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_DESIGN_FACTOR''' INTO l_stg_tab_name;
        l_target_sql := 'INSERT INTO '||l_tgt_tab_name||'(STUDY_DESIGN_FACTOR_EID,STUDY_DESIGN_FACTOR_EID_AUTH,STUDY_EREF,TRIAL_NO,STUDY_DESIGN_FACTOR_CODE,STUDY_DESIGN_FACTOR_DESC
            ,STUDY_CODE_NCC,STUDY_CODE_ALIAS,GG_COMMIT_TIME,PVR_LAST_UPDATE_TIME,PVR_LAST_UPDATE_BY,BATCH,PARTITION)
        SELECT
            STUDY_DESIGN_FACTOR_EID,STUDY_DESIGN_FACTOR_EID_AUTH,STUDY_EREF,TRIAL_NO,STUDY_DESIGN_FACTOR_CODE,STUDY_DESIGN_FACTOR_DESC
            ,STUDY_CODE_NCC,STUDY_CODE_ALIAS,GG_COMMIT_TIME,SYSDATE PVR_LAST_UPDATE_TIME, ''RXL'' PVR_LAST_UPDATE_BY,BATCH,PARTITION
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
--  Populating Table STUDY_DESIGN_FACTOR_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_DESIGN_FACTOR''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_DESIGN_FACTOR''' INTO l_stg_tab_name;
        l_target_sql := 'MERGE INTO '||l_tgt_tab_name||' ttn USING (

   SELECT
            STUDY_DESIGN_FACTOR_EID,STUDY_DESIGN_FACTOR_EID_AUTH,STUDY_EREF,TRIAL_NO,STUDY_DESIGN_FACTOR_CODE,STUDY_DESIGN_FACTOR_DESC
            ,STUDY_CODE_NCC,STUDY_CODE_ALIAS,GG_COMMIT_TIME,SYSDATE PVR_LAST_UPDATE_TIME, ''RXL'' PVR_LAST_UPDATE_BY,BATCH,PARTITION
        FROM '||l_stg_tab_name||' EVSD
)
stn ON (
    ttn.STUDY_DESIGN_FACTOR_EID = stn.STUDY_DESIGN_FACTOR_EID
    AND ttn.STUDY_DESIGN_FACTOR_EID_AUTH = stn.STUDY_DESIGN_FACTOR_EID_AUTH
)
WHEN MATCHED THEN UPDATE SET ttn.study_eref = stn.study_eref,
ttn.trial_no = stn.trial_no,
ttn.study_design_factor_code = stn.study_design_factor_code,
ttn.study_design_factor_desc = stn.study_design_factor_desc,
ttn.study_code_ncc = stn.study_code_ncc,
ttn.study_code_alias = stn.study_code_alias,
ttn.GG_COMMIT_TIME = stn.GG_COMMIT_TIME,
ttn.pvr_last_update_time = stn.pvr_last_update_time,
ttn.pvr_last_update_by = stn.pvr_last_update_by,
ttn.batch = stn.batch,
ttn.partition = stn.partition
WHEN NOT MATCHED THEN INSERT (
    study_design_factor_eid,
    study_design_factor_eid_auth,
	study_eref,
	trial_no,
    study_design_factor_code,
    STUDY_DESIGN_FACTOR_DESC,
	study_code_ncc,
	study_code_alias,
	GG_COMMIT_TIME,
	PVR_LAST_UPDATE_TIME,
	PVR_LAST_UPDATE_BY,
    batch,
    partition ) VALUES (
    stn.study_design_factor_eid,
    stn.study_design_factor_eid_auth,
	stn.study_eref,
	stn.trial_no,
    stn.study_design_factor_code,
    stn.STUDY_DESIGN_FACTOR_DESC,
	stn.study_code_ncc,
	stn.study_code_alias,
	stn.GG_COMMIT_TIME,
	stn.PVR_LAST_UPDATE_TIME,
	stn.PVR_LAST_UPDATE_BY,
    stn.batch,
    stn.partition )'
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