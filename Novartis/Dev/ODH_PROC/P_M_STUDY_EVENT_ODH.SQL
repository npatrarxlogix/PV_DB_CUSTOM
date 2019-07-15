create or replace PROCEDURE P_M_STUDY_EVENT(PI_MODE VARCHAR2) as
    ln_row_cnt           NUMBER;
    l_seq_num            NUMBER;
    l_target_sql         CLOB;
    l_etl_execution_id   NUMBER := pvd_cstm_seq.currval;
	l_stg_tab_name       VARCHAR2(4000);
    l_tgt_tab_name       VARCHAR2(4000);
BEGIN
IF pi_mode = 'INIT' THEN
--------------------------------------------------------
--  Populating Table STUDY_EVENT_NVS
--------------------------------------------------------

begin	
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_EVENT''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_EVENT''' INTO l_stg_tab_name;
        l_target_sql := 'INSERT INTO '||l_tgt_tab_name||'(TRIAL_NO,ACTUAL_DATE,BASELINE_DATE,EVENT_NUMBER,STUDY_EVENT_EID,STUDY_EVENT_EID_AUTHORITY,GG_COMMIT_TIME,PVR_LAST_UPDATE_TIME,PVR_LAST_UPDATE_BY,BATCH,PARTITION)
        SELECT
            TRIAL_NO,ACTUAL_DATE,BASELINE_DATE,EVENT_NUMBER,STUDY_EVENT_EID,STUDY_EVENT_EID_AUTHORITY,GG_COMMIT_TIME,SYSDATE PVR_LAST_UPDATE_TIME, ''RXL'' PVR_LAST_UPDATE_BY,BATCH,PARTITION
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
--  Populating Table STUDY_EVENT_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_EVENT''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_EVENT''' INTO l_stg_tab_name;
        l_target_sql := 'MERGE INTO '||l_tgt_tab_name||' ttn USING (
    SELECT
        TRIAL_NO,ACTUAL_DATE,BASELINE_DATE,EVENT_NUMBER,STUDY_EVENT_EID,STUDY_EVENT_EID_AUTHORITY,GG_COMMIT_TIME,SYSDATE PVR_LAST_UPDATE_TIME, ''RXL'' PVR_LAST_UPDATE_BY,BATCH,PARTITION
    FROM  '||l_stg_tab_name||'
)
stn ON (
    ttn.study_event_eid = stn.study_event_eid
    AND ttn.study_event_eid_authority = stn.study_event_eid_authority
)
WHEN MATCHED THEN UPDATE SET ttn.trial_no = stn.trial_no,
ttn.event_number = stn.event_number,
ttn.baseline_date = stn.baseline_date,
ttn.actual_date = stn.actual_date,
ttn.GG_COMMIT_TIME = stn.GG_COMMIT_TIME,
ttn.PVR_LAST_UPDATE_TIME = stn.PVR_LAST_UPDATE_TIME,
ttn.PVR_LAST_UPDATE_BY = stn.PVR_LAST_UPDATE_BY,
ttn.batch = stn.batch,
ttn.partition = stn.partition
WHEN NOT MATCHED THEN INSERT (
    study_event_eid,
    study_event_eid_authority,
    trial_no,
    event_number,
    baseline_date,
    actual_date,
	GG_COMMIT_TIME,
	PVR_LAST_UPDATE_TIME,
	PVR_LAST_UPDATE_BY,
    batch,
    partition ) VALUES (
    stn.study_event_eid,
    stn.study_event_eid_authority,
    stn.trial_no,
    stn.event_number,
    stn.baseline_date,
    stn.actual_date,
	stn.GG_COMMIT_TIME,
	STN.PVR_LAST_UPDATE_TIME,
	STN.PVR_LAST_UPDATE_BY,
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