create or replace PROCEDURE P_M_STUDY_THERAPY(PI_MODE VARCHAR2) as
    ln_row_cnt           NUMBER;
    l_seq_num            NUMBER;
    l_target_sql         CLOB;
    l_etl_execution_id   NUMBER := pvd_cstm_seq.currval;
	l_stg_tab_name       VARCHAR2(4000);
    l_tgt_tab_name       VARCHAR2(4000);
BEGIN
IF pi_mode = 'INIT' THEN
--------------------------------------------------------
--  Populating Table STUDY_THERAPY_NVS
--------------------------------------------------------

begin	
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_THERAPY''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_THERAPY''' INTO l_stg_tab_name;
        l_target_sql := 'INSERT INTO '||l_tgt_tab_name||'(STUDY_EREF,STUDY_CODE_NCC,STUDY_CODE_ALIAS,TRIAL_NO,COMPOUND_CODE,DOSAGE_FREQUENCY_DESC,DOSE_QUANTITY_UNITS,STUDY_THERAPY_EID,STUDY_THERAPY_EID_AUTHORITY
			,TARGET_RANDOMIZATION_NUMBER,ADMINISTRATION_ROUTE_DESC,TREATMENT_ARM_NAME
			,GG_COMMIT_TIME,PVR_LAST_UPDATE_TIME,PVR_LAST_UPDATE_BY,BATCH,PARTITION)
        SELECT
            STUDY_EREF,STUDY_CODE_NCC,STUDY_CODE_ALIAS,TRIAL_NO,COMPOUND_CODE,DOSAGE_FREQUENCY_DESC,DOSE_QUANTITY_UNITS,STUDY_THERAPY_EID,STUDY_THERAPY_EID_AUTHORITY
			,TARGET_RANDOMIZATION_NUMBER,ADMINISTRATION_ROUTE_DESC,TREATMENT_ARM_NAME
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
--  Populating Table STUDY_THERAPY_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_THERAPY''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_THERAPY''' INTO l_stg_tab_name;
        l_target_sql := 'MERGE INTO '||l_tgt_tab_name||' ttn USING (
    SELECT
             STUDY_EREF,STUDY_CODE_NCC,STUDY_CODE_ALIAS,TRIAL_NO,COMPOUND_CODE,DOSAGE_FREQUENCY_DESC,DOSE_QUANTITY_UNITS,STUDY_THERAPY_EID,STUDY_THERAPY_EID_AUTHORITY
			,TARGET_RANDOMIZATION_NUMBER,ADMINISTRATION_ROUTE_DESC,TREATMENT_ARM_NAME
			,GG_COMMIT_TIME,SYSDATE PVR_LAST_UPDATE_TIME, ''RXL'' PVR_LAST_UPDATE_BY,BATCH,PARTITION
    FROM '||l_stg_tab_name||'
)
stn ON (
    ttn.study_therapy_eid = stn.study_therapy_eid
    AND ttn.study_therapy_eid_authority = stn.study_therapy_eid_authority
)
WHEN MATCHED THEN UPDATE SET ttn.study_eref = stn.study_eref,
ttn.trial_no = stn.trial_no,
ttn.study_code_ncc = stn.study_code_ncc,
ttn.study_code_alias = stn.study_code_alias,
ttn.compound_code = stn.compound_code,
ttn.administration_route_desc = stn.administration_route_desc,
ttn.dosage_frequency_desc = stn.dosage_frequency_desc,
ttn.dose_quantity_units = stn.dose_quantity_units,
ttn.target_randomization_number = stn.target_randomization_number,
ttn.treatment_arm_name = stn.treatment_arm_name,
ttn.GG_COMMIT_TIME = stn.GG_COMMIT_TIME,
ttn.PVR_LAST_UPDATE_TIME = stn.PVR_LAST_UPDATE_TIME,
ttn.PVR_LAST_UPDATE_BY = stn.PVR_LAST_UPDATE_BY,
ttn.batch = stn.batch,
ttn.partition = stn.partition
WHEN NOT MATCHED THEN INSERT (
    study_therapy_eid,
    study_therapy_eid_authority,
    study_eref,
    trial_no,
    study_code_ncc,
    study_code_alias,
    compound_code,
    administration_route_desc,
    dosage_frequency_desc,
    dose_quantity_units,
    target_randomization_number,
    treatment_arm_name,
	GG_COMMIT_TIME,
	PVR_LAST_UPDATE_TIME,
	PVR_LAST_UPDATE_BY,
    batch,
    partition ) VALUES (
    stn.study_therapy_eid,
    stn.study_therapy_eid_authority,
    stn.study_eref,
    stn.trial_no,
    stn.study_code_ncc,
    stn.study_code_alias,
    stn.compound_code,
    stn.administration_route_desc,
    stn.dosage_frequency_desc,
    stn.dose_quantity_units,
    stn.target_randomization_number,
    stn.treatment_arm_name,
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