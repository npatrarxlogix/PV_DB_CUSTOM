create or replace PROCEDURE P_M_DRUG_ADMINISTRATION(PI_MODE VARCHAR2) as 
    ln_row_cnt           NUMBER;
    l_seq_num            NUMBER;
    l_target_sql         CLOB;
    l_etl_execution_id   NUMBER := pvd_cstm_seq.currval;
	l_src_tab_name       VARCHAR2(4000);
	l_src_tgt_link_name  VARCHAR2(4000);
	l_stg_tab_name       VARCHAR2(4000);
    l_tgt_tab_name       VARCHAR2(4000);
BEGIN
IF pi_mode = 'INIT' THEN
--------------------------------------------------------
--  Populating Table DRUG_ADMINISTRATION_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_DRUG_ADMINISTRATION''' INTO l_stg_tab_name;
		EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_DRUG_ADMINISTRATION''' INTO l_tgt_tab_name;
        l_target_sql := 'INSERT INTO '||l_tgt_tab_name||'
	(AL_CLINICAL_TRIAL_NM,AL_TRIAL_COUNTRY_CD,TRIAL_SITE_ID,CLINICAL_SUBJECT_ID,CLINICAL_VISIT_NO,REASON_FOR_CHANGE_DICT_NM
	,TREATMENT_DISCONTINUATION_DT,DEDW_OPERATION_TS,DRUG_ADMINISTRATION_SK,PVR_LAST_UPDATE_TIME,PVR_LAST_UPDATE_BY)
      SELECT AL_CLINICAL_TRIAL_NM,AL_TRIAL_COUNTRY_CD,TRIAL_SITE_ID,CLINICAL_SUBJECT_ID,CLINICAL_VISIT_NO,REASON_FOR_CHANGE_DICT_NM
	  ,TREATMENT_DISCONTINUATION_DT,DEDW_OPERATION_TS,DRUG_ADMINISTRATION_SK,NULL PVR_LAST_UPDATE_TIME,NULL PVR_LAST_UPDATE_BY
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
--  Populating Table DRUG_ADMINISTRATION_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
       EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_DRUG_ADMINISTRATION''' INTO l_stg_tab_name;
	   EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_DRUG_ADMINISTRATION''' INTO l_tgt_tab_name;
        l_target_sql := 'MERGE INTO '||l_tgt_tab_name||' ttn USING (

SELECT AL_CLINICAL_TRIAL_NM,AL_TRIAL_COUNTRY_CD,TRIAL_SITE_ID,CLINICAL_SUBJECT_ID,CLINICAL_VISIT_NO,REASON_FOR_CHANGE_DICT_NM
	  ,TREATMENT_DISCONTINUATION_DT,DEDW_OPERATION_TS,DRUG_ADMINISTRATION_SK,NULL PVR_LAST_UPDATE_TIME,NULL PVR_LAST_UPDATE_BY
	  FROM '||
            l_stg_tab_name||'
	
)
stn ON (
    ttn.DRUG_ADMINISTRATION_SK = stn.DRUG_ADMINISTRATION_SK
)
WHEN MATCHED THEN UPDATE SET 
ttn.AL_CLINICAL_TRIAL_NM = stn.AL_CLINICAL_TRIAL_NM,
ttn.AL_TRIAL_COUNTRY_CD = stn.AL_TRIAL_COUNTRY_CD,
ttn.TRIAL_SITE_ID = stn.TRIAL_SITE_ID,
ttn.CLINICAL_SUBJECT_ID = stn.CLINICAL_SUBJECT_ID,

ttn.CLINICAL_VISIT_NO = stn.CLINICAL_VISIT_NO,
ttn.REASON_FOR_CHANGE_DICT_NM = stn.REASON_FOR_CHANGE_DICT_NM,
ttn.TREATMENT_DISCONTINUATION_DT = stn.TREATMENT_DISCONTINUATION_DT,
ttn.DEDW_OPERATION_TS=stn.DEDW_OPERATION_TS,
ttn.PVR_LAST_UPDATE_TIME = stn.PVR_LAST_UPDATE_TIME,
ttn.PVR_LAST_UPDATE_BY = stn.PVR_LAST_UPDATE_BY

WHEN NOT MATCHED THEN INSERT (
  AL_CLINICAL_TRIAL_NM,
  AL_TRIAL_COUNTRY_CD,
  TRIAL_SITE_ID,
  CLINICAL_SUBJECT_ID,
  CLINICAL_VISIT_NO,
  REASON_FOR_CHANGE_DICT_NM,
  TREATMENT_DISCONTINUATION_DT,
  DEDW_OPERATION_TS,
  DRUG_ADMINISTRATION_SK,  
  PVR_LAST_UPDATE_TIME,
  PVR_LAST_UPDATE_BY
   ) 
  
  VALUES (
    stn.AL_CLINICAL_TRIAL_NM,
    stn.AL_TRIAL_COUNTRY_CD,
	stn.TRIAL_SITE_ID,
    stn.CLINICAL_SUBJECT_ID,
    stn.CLINICAL_VISIT_NO,
    stn.REASON_FOR_CHANGE_DICT_NM,
    stn.TREATMENT_DISCONTINUATION_DT,
	stn.DEDW_OPERATION_TS,
	stn.DRUG_ADMINISTRATION_SK,
	stn.PVR_LAST_UPDATE_TIME,
	stn.PVR_LAST_UPDATE_BY
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