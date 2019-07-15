create or replace PROCEDURE P_M_STUDY(PI_MODE VARCHAR2) as
    ln_row_cnt           NUMBER;
    l_seq_num            NUMBER;
    l_target_sql         CLOB;
    l_etl_execution_id   NUMBER := pvd_cstm_seq.currval;
	l_stg_tab_name       VARCHAR2(4000);
    l_tgt_tab_name       VARCHAR2(4000);
BEGIN
IF pi_mode = 'INIT' THEN
--------------------------------------------------------
--  Populating Table STUDY_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY''' INTO l_stg_tab_name;
        l_target_sql := 'INSERT INTO '||l_tgt_tab_name||'(TRIAL_NO,COMPOUND_CODE,AGE_MAXIMUM_ACTUAL,AGE_MAXIMUM_UNITS,AGE_MINIMUM_ACTUAL,AGE_MINIMUM_UNITS,MALE_PARTICIPATION_IND
			,FEMALE_PARTICIPATION_IND,PHASE_CODE,PROJECT_CODE_ALIAS,PROJECT_CODE_NCC,STUDY_CATEGORY_CODE,STUDY_CATEGORY_DESC,STUDY_CODE_ALIAS
			,STUDY_CODE_NCC,STUDY_EID,STUDY_EID_AUTHORITY,TITLE,BLINDING_SCHEMA_CODE,BLINDING_SCHEMA_DESC,DESIGN_CONFIG_CODE,DESIGN_CONFIG_DESC
			,ALLOCATION_CODE,ALLOCATION_DESC,LAST_UPDATED_BY,ORGANIZATION_CODE,DESCRIPTION,ORGANIZATION_EID,ORGANIZATION_EID_AUTHORITY
			,GG_COMMIT_TIME,PVR_LAST_UPDATE_TIME,PVR_LAST_UPDATE_BY,MANAGING_ORG_EREF,BATCH,PARTITION)
        SELECT
            EVS.TRIAL_NO,EVS.COMPOUND_CODE,EVS.AGE_MAXIMUM_ACTUAL,EVS.AGE_MAXIMUM_UNITS,EVS.AGE_MINIMUM_ACTUAL,EVS.AGE_MINIMUM_UNITS,EVS.MALE_PARTICIPATION_IND
			,EVS.FEMALE_PARTICIPATION_IND,EVS.PHASE_CODE,EVS.PROJECT_CODE_ALIAS,EVS.PROJECT_CODE_NCC,EVS.STUDY_CATEGORY_CODE,EVS.STUDY_CATEGORY_DESC,EVS.STUDY_CODE_ALIAS
			,EVS.STUDY_CODE_NCC,EVS.STUDY_EID,EVS.STUDY_EID_AUTHORITY,EVS.TITLE,EVS.BLINDING_SCHEMA_CODE,EVS.BLINDING_SCHEMA_DESC,EVS.DESIGN_CONFIG_CODE,EVS.DESIGN_CONFIG_DESC
			,EVS.ALLOCATION_CODE,EVS.ALLOCATION_DESC,EVS.LAST_UPDATED_BY,EVO.ORGANIZATION_CODE,EVO.DESCRIPTION,EVO.ORGANIZATION_EID,EVO.ORGANIZATION_EID_AUTHORITY
			,GG_COMMIT_TIME,SYSDATE PVR_LAST_UPDATE_TIME, ''RXL'' PVR_LAST_UPDATE_BY,EVS.MANAGING_ORG_EREF,EVS.BATCH,EVS.PARTITION
        FROM
            '||l_stg_tab_name||' EVS LEFT JOIN S_ESB_V_ORGANIZATION EVO ON EVS.MANAGING_ORG_EREF=EVO.ORGANIZATION_EID'
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
--  Populating Table STUDY_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY''' INTO l_stg_tab_name;
        l_target_sql := 'MERGE INTO '||l_tgt_tab_name||' ttn USING (

   SELECT
            EVS.TRIAL_NO,EVS.COMPOUND_CODE,EVS.AGE_MAXIMUM_ACTUAL,EVS.AGE_MAXIMUM_UNITS,EVS.AGE_MINIMUM_ACTUAL,EVS.AGE_MINIMUM_UNITS,EVS.MALE_PARTICIPATION_IND
			,EVS.FEMALE_PARTICIPATION_IND,EVS.PHASE_CODE,EVS.PROJECT_CODE_ALIAS,EVS.PROJECT_CODE_NCC,EVS.STUDY_CATEGORY_CODE,EVS.STUDY_CATEGORY_DESC,EVS.STUDY_CODE_ALIAS
			,EVS.STUDY_CODE_NCC,EVS.STUDY_EID,EVS.STUDY_EID_AUTHORITY,EVS.TITLE,EVS.BLINDING_SCHEMA_CODE,EVS.BLINDING_SCHEMA_DESC,EVS.DESIGN_CONFIG_CODE,EVS.DESIGN_CONFIG_DESC
			,EVS.ALLOCATION_CODE,EVS.ALLOCATION_DESC,EVS.LAST_UPDATED_BY,EVO.ORGANIZATION_CODE,EVO.DESCRIPTION,EVO.ORGANIZATION_EID,EVO.ORGANIZATION_EID_AUTHORITY
			,GG_COMMIT_TIME,SYSDATE PVR_LAST_UPDATE_TIME, ''RXL'' PVR_LAST_UPDATE_BY,EVS.MANAGING_ORG_EREF,EVS.BATCH,EVS.PARTITION
        FROM
             '||l_stg_tab_name||' EVS LEFT JOIN S_ESB_V_ORGANIZATION EVO ON EVS.MANAGING_ORG_EREF=EVO.ORGANIZATION_EID
)
stn ON (
    ttn.study_eid = stn.study_eid
    AND ttn.study_eid_authority = stn.study_eid_authority
)
WHEN MATCHED THEN UPDATE SET ttn.trial_no = stn.trial_no,
ttn.compound_code = stn.compound_code,
ttn.title = stn.title,
ttn.project_code_ncc = stn.project_code_ncc,
ttn.project_code_alias = stn.project_code_alias,
ttn.study_code_ncc = stn.study_code_ncc,
ttn.study_code_alias = stn.study_code_alias,
ttn.phase_code = stn.phase_code,
ttn.design_config_code = stn.design_config_code,
ttn.blinding_schema_code = stn.blinding_schema_code,
ttn.last_updated_by = stn.last_updated_by,
ttn.age_maximum_actual = stn.age_maximum_actual,
ttn.allocation_code = stn.allocation_code,
ttn.age_maximum_units = stn.age_maximum_units,
ttn.age_minimum_actual = stn.age_minimum_actual,
ttn.age_minimum_units = stn.age_minimum_units,
ttn.female_participation_ind = stn.female_participation_ind,
ttn.male_participation_ind = stn.male_participation_ind,
ttn.study_category_code = stn.study_category_code,
TTN.STUDY_CATEGORY_DESC=STN.STUDY_CATEGORY_DESC,
TTN.BLINDING_SCHEMA_DESC=STN.BLINDING_SCHEMA_DESC,
TTN.DESIGN_CONFIG_DESC=STN.DESIGN_CONFIG_DESC,
TTN.ALLOCATION_DESC=STN.ALLOCATION_DESC,
ttn.ORGANIZATION_CODE = stn.ORGANIZATION_CODE,
ttn.ORGANIZATION_EID = stn.ORGANIZATION_EID,
ttn.ORGANIZATION_EID_AUTHORITY = stn.ORGANIZATION_EID_AUTHORITY,
ttn.description = stn.description,
ttn.GG_COMMIT_TIME = stn.GG_COMMIT_TIME,
ttn.PVR_LAST_UPDATE_TIME = stn.PVR_LAST_UPDATE_TIME,
ttn.PVR_LAST_UPDATE_BY = stn.PVR_LAST_UPDATE_BY,
ttn.MANAGING_ORG_EREF = stn.MANAGING_ORG_EREF,
ttn.batch = stn.batch,
ttn.partition = stn.partition
WHEN NOT MATCHED THEN INSERT (
    study_eid,
    study_eid_authority,
    trial_no,
    compound_code,
    title,
    project_code_ncc,
    project_code_alias,
    study_code_ncc,
    study_code_alias,
    phase_code,
    design_config_code,
    blinding_schema_code,
    last_updated_by,
    age_maximum_actual,
    allocation_code,
    age_maximum_units,
    age_minimum_actual,
    age_minimum_units,
    female_participation_ind,
    male_participation_ind,
    study_category_code,
	BLINDING_SCHEMA_DESC,
	STUDY_CATEGORY_DESC,
	DESIGN_CONFIG_DESC,
	ALLOCATION_DESC,
	organization_eid,
    organization_eid_authority,
    organization_code,
    description,
	GG_COMMIT_TIME,
	PVR_LAST_UPDATE_TIME,
	PVR_LAST_UPDATE_BY,
	MANAGING_ORG_EREF,
    batch,
    partition ) VALUES (
    stn.study_eid,
    stn.study_eid_authority,
    stn.trial_no,
    stn.compound_code,
    stn.title,
    stn.project_code_ncc,
    stn.project_code_alias,
    stn.study_code_ncc,
    stn.study_code_alias,
    stn.phase_code,
    stn.design_config_code,
    stn.blinding_schema_code,
    stn.last_updated_by,
    stn.age_maximum_actual,
    stn.allocation_code,
    stn.age_maximum_units,
    stn.age_minimum_actual,
    stn.age_minimum_units,
    stn.female_participation_ind,
    stn.male_participation_ind,
    stn.study_category_code,
	STN.BLINDING_SCHEMA_DESC,
	STN.STUDY_CATEGORY_DESC,
	STN.DESIGN_CONFIG_DESC,
	STN.ALLOCATION_DESC,
	stn.organization_eid,
    stn.organization_eid_authority,
    stn.organization_code,
    stn.description,
	stn.GG_COMMIT_TIME,
	STN.PVR_LAST_UPDATE_TIME,
	STN.PVR_LAST_UPDATE_BY,
	stn.MANAGING_ORG_EREF,
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