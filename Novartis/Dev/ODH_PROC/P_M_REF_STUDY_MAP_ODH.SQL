create or replace PROCEDURE P_M_REF_STUDY_MAP(PI_MODE VARCHAR2) as
    ln_row_cnt           NUMBER;
    l_seq_num            NUMBER;
    l_target_sql         CLOB;
    l_etl_execution_id   NUMBER := pvd_cstm_seq.currval;
	l_stg_tab_name       VARCHAR2(4000);
    l_tgt_tab_name       VARCHAR2(4000);
BEGIN
IF pi_mode = 'INIT' THEN

--------------------------------------------------------
--  Populating Table REF_STUDY_MAP_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
		EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_REF_STUDY_MAP''' INTO 
l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_REF_STUDY_MAP''' INTO 
l_stg_tab_name;
        l_target_sql := 'INSERT INTO '||
l_tgt_tab_name||'(STUDY_EID,STUDY_EID_AUTHORITY,PROJECT_EREF,PROJECT_EREF_AUTHORITY,COMPOUND_EREF,COMPOUND_EREF_AUTHORITY,PARENT_STUDY_EREF, 
PARENT_STUDY_EREF_AUTHORITY,CLINICAL_PLAN_NO,TRIAL_NO,PARENT_TRIAL_NO,COMPOUND_CODE,PARENT_STUDY_CODE_NCC,PARENT_STUDY_CODE_ALIAS,TITLE,     
PROJECT_CODE_NCC,PROJECT_CODE_ALIAS,SHORT_DESCRIPTION,STUDY_CODE_NCC,STUDY_CODE_ALIAS,PHASE_DESC,EUDRACT_NUMBER,NCTR_NUMBER,STUDY_STATUS_DESC, 
STUDY_ACRONYM,STUDY_CREDI,STUDY_SUBWAY,SUBWAY_MIGRATION_STATUS,GG_COMMIT_TIME,PVR_LAST_UPDATE_TIME,PVR_LAST_UPDATE_BY,BATCH,PARTITION)
        SELECT
            STUDY_EID,STUDY_EID_AUTHORITY,PROJECT_EREF,PROJECT_EREF_AUTHORITY,COMPOUND_EREF,COMPOUND_EREF_AUTHORITY,PARENT_STUDY_EREF, 
PARENT_STUDY_EREF_AUTHORITY,CLINICAL_PLAN_NO,TRIAL_NO,PARENT_TRIAL_NO,COMPOUND_CODE,PARENT_STUDY_CODE_NCC,PARENT_STUDY_CODE_ALIAS,TITLE,     
PROJECT_CODE_NCC,PROJECT_CODE_ALIAS,SHORT_DESCRIPTION,STUDY_CODE_NCC,STUDY_CODE_ALIAS,PHASE_DESC,EUDRACT_NUMBER,NCTR_NUMBER,STUDY_STATUS_DESC, 
STUDY_ACRONYM,STUDY_CREDI,STUDY_SUBWAY,SUBWAY_MIGRATION_STATUS,GG_COMMIT_TIME,SYSDATE PVR_LAST_UPDATE_TIME, ''RXL'' PVR_LAST_UPDATE_BY,BATCH,PARTITION

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
--  Populating Table REF_STUDY_MAP_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_REF_STUDY_MAP''' INTO 
l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_REF_STUDY_MAP''' 
INTO l_stg_tab_name;
        l_target_sql := 'MERGE INTO '||l_tgt_tab_name||' ttn USING (
    SELECT
        STUDY_EID,STUDY_EID_AUTHORITY,PROJECT_EREF,PROJECT_EREF_AUTHORITY,COMPOUND_EREF,COMPOUND_EREF_AUTHORITY,PARENT_STUDY_EREF, 
PARENT_STUDY_EREF_AUTHORITY,CLINICAL_PLAN_NO,TRIAL_NO,PARENT_TRIAL_NO,COMPOUND_CODE,PARENT_STUDY_CODE_NCC,PARENT_STUDY_CODE_ALIAS,TITLE,     
PROJECT_CODE_NCC,PROJECT_CODE_ALIAS,SHORT_DESCRIPTION,STUDY_CODE_NCC,STUDY_CODE_ALIAS,PHASE_DESC,EUDRACT_NUMBER,NCTR_NUMBER,STUDY_STATUS_DESC, 
STUDY_ACRONYM,STUDY_CREDI,STUDY_SUBWAY,SUBWAY_MIGRATION_STATUS,GG_COMMIT_TIME,SYSDATE PVR_LAST_UPDATE_TIME, ''RXL'' PVR_LAST_UPDATE_BY,BATCH,PARTITION

    FROM '||l_stg_tab_name||'
)
stn ON (
    ttn.STUDY_EID = stn.STUDY_EID
)
WHEN MATCHED THEN UPDATE SET 
ttn.STUDY_EID_AUTHORITY = stn.STUDY_EID_AUTHORITY,
ttn.PROJECT_EREF = stn.PROJECT_EREF,
ttn.PROJECT_EREF_AUTHORITY = stn.PROJECT_EREF_AUTHORITY,
ttn.COMPOUND_EREF = stn.COMPOUND_EREF,
ttn.COMPOUND_EREF_AUTHORITY = stn.COMPOUND_EREF_AUTHORITY,
ttn.PARENT_STUDY_EREF = stn.PARENT_STUDY_EREF,
ttn.PARENT_STUDY_EREF_AUTHORITY = stn.PARENT_STUDY_EREF_AUTHORITY,
ttn.CLINICAL_PLAN_NO = stn.CLINICAL_PLAN_NO,
ttn.TRIAL_NO = stn.TRIAL_NO,
ttn.PARENT_TRIAL_NO = stn.PARENT_TRIAL_NO,
ttn.COMPOUND_CODE = stn.COMPOUND_CODE,
ttn.PARENT_STUDY_CODE_NCC = stn.PARENT_STUDY_CODE_NCC,
ttn.PARENT_STUDY_CODE_ALIAS = stn.PARENT_STUDY_CODE_ALIAS,
ttn.TITLE = stn.TITLE,
ttn.PROJECT_CODE_NCC = stn.PROJECT_CODE_NCC,
ttn.PROJECT_CODE_ALIAS = stn.PROJECT_CODE_ALIAS,
ttn.SHORT_DESCRIPTION = stn.SHORT_DESCRIPTION,
ttn.STUDY_CODE_NCC = stn.STUDY_CODE_NCC,
ttn.STUDY_CODE_ALIAS = stn.STUDY_CODE_ALIAS,
ttn.PHASE_DESC = stn.PHASE_DESC,
ttn.EUDRACT_NUMBER = stn.EUDRACT_NUMBER,
ttn.NCTR_NUMBER = stn.NCTR_NUMBER,
ttn.STUDY_STATUS_DESC = stn.STUDY_STATUS_DESC,
ttn.STUDY_ACRONYM = stn.STUDY_ACRONYM,
ttn.STUDY_CREDI = stn.STUDY_CREDI,
ttn.STUDY_SUBWAY = stn.STUDY_SUBWAY,
ttn.SUBWAY_MIGRATION_STATUS = stn.SUBWAY_MIGRATION_STATUS,
ttn.batch = stn.batch,
ttn.partition = stn.partition,
ttn.GG_COMMIT_TIME = stn.GG_COMMIT_TIME,
ttn.PVR_LAST_UPDATE_TIME = stn.PVR_LAST_UPDATE_TIME,
ttn.PVR_LAST_UPDATE_BY = stn.PVR_LAST_UPDATE_BY
WHEN NOT MATCHED THEN INSERT (
            STUDY_EID,            
            STUDY_EID_AUTHORITY, 
            PROJECT_EREF, 
            PROJECT_EREF_AUTHORITY, 
            COMPOUND_EREF, 
            COMPOUND_EREF_AUTHORITY, 
            PARENT_STUDY_EREF, 
            PARENT_STUDY_EREF_AUTHORITY, 
            CLINICAL_PLAN_NO, 
            TRIAL_NO,        
            PARENT_TRIAL_NO, 
            COMPOUND_CODE, 
            PARENT_STUDY_CODE_NCC, 
            PARENT_STUDY_CODE_ALIAS, 
            TITLE,     
            PROJECT_CODE_NCC, 
            PROJECT_CODE_ALIAS,
            SHORT_DESCRIPTION, 
            STUDY_CODE_NCC, 
            STUDY_CODE_ALIAS,
            PHASE_DESC, 
            EUDRACT_NUMBER, 
            NCTR_NUMBER, 
            STUDY_STATUS_DESC, 
            STUDY_ACRONYM, 
            STUDY_CREDI, 
            STUDY_SUBWAY, 
            SUBWAY_MIGRATION_STATUS,
			GG_COMMIT_TIME,
            PVR_LAST_UPDATE_TIME,
	        PVR_LAST_UPDATE_BY,			
			BATCH ,                
            PARTITION  ) VALUES (
            stn.STUDY_EID,            
            stn.STUDY_EID_AUTHORITY, 
            stn.PROJECT_EREF, 
            stn.PROJECT_EREF_AUTHORITY, 
            stn.COMPOUND_EREF, 
            stn.COMPOUND_EREF_AUTHORITY, 
            stn.PARENT_STUDY_EREF, 
            stn.PARENT_STUDY_EREF_AUTHORITY, 
            stn.CLINICAL_PLAN_NO, 
            stn.TRIAL_NO,        
            stn.PARENT_TRIAL_NO, 
            stn.COMPOUND_CODE, 
            stn.PARENT_STUDY_CODE_NCC, 
            stn.PARENT_STUDY_CODE_ALIAS, 
            stn.TITLE,     
            stn.PROJECT_CODE_NCC, 
            stn.PROJECT_CODE_ALIAS,
            stn.SHORT_DESCRIPTION, 
            stn.STUDY_CODE_NCC, 
            stn.STUDY_CODE_ALIAS,
            stn.PHASE_DESC, 
            stn.EUDRACT_NUMBER, 
            stn.NCTR_NUMBER, 
            stn.STUDY_STATUS_DESC, 
            stn.STUDY_ACRONYM, 
            stn.STUDY_CREDI, 
            stn.STUDY_SUBWAY, 
            stn.SUBWAY_MIGRATION_STATUS,
			stn.GG_COMMIT_TIME,
            stn.PVR_LAST_UPDATE_TIME,
	        stn.PVR_LAST_UPDATE_BY,			
			stn.BATCH ,                
            stn.PARTITION )'
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
