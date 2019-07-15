create or replace PROCEDURE P_S_ADVERSE_EVENT(
PI_CODE VARCHAR2
) IS

    ln_row_cnt           NUMBER;
    l_seq_num            NUMBER;
    l_stage_sql          CLOB;
    l_etl_execution_id   NUMBER := pvd_cstm_seq.currval;
	l_src_tab_name       VARCHAR2(4000);
	l_src_tgt_link_name  VARCHAR2(4000);
    l_stg_tab_name       VARCHAR2(4000);
    l_tgt_tab_name       VARCHAR2(4000);
    l_last_exec_time     DATE;
BEGIN
--------------------------------------------------------
--  Populating Table S_DSUR_MV_ADVERSE_EVENT
--------------------------------------------------------

   BEGIN
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where STAGE_POPULATION_PROCEDURE=''P_S_ADVERSE_EVENT''' INTO l_stg_tab_name;
        EXECUTE IMMEDIATE 'select SRC_TABLE_NAME from pvd_cstm_tables where STAGE_POPULATION_PROCEDURE=''P_S_ADVERSE_EVENT''' INTO l_src_tab_name;
            
        EXECUTE IMMEDIATE 'select DB_LINK from pvd_cstm_tables where STAGE_POPULATION_PROCEDURE=''P_S_ADVERSE_EVENT''' INTO l_src_tgt_link_name ;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where STAGE_POPULATION_PROCEDURE=''P_S_ADVERSE_EVENT''' INTO l_tgt_tab_name;
                        
        EXECUTE IMMEDIATE 'select max(DEDW_OPERATION_TS) from '||l_tgt_tab_name into l_last_exec_time;
		EXECUTE IMMEDIATE 'update PVD_CSTM_ETL_CONSTANTS set ETL_VALUE='''||l_last_exec_time||''' where ETL_KEY=''ETL_ADVERSE_EVENT_END_DT''';
        l_stage_sql := 'INSERT INTO '|| l_stg_tab_name||'
	(AL_CLINICAL_TRIAL_NM,AL_TRIAL_COUNTRY_CD,TRIAL_SITE_ID,CLINICAL_SUBJECT_ID,CLINICAL_VISIT_NO,AL_AE_START_DT,AE_SERIOUSNESS_CD,AE_PREFERRED_TR,AE_CAUSALITY_SUSPECTED_DE,
	ACTION_TAKEN_3_CD,DEDW_OPERATION_TS,ADVERSE_EVENT_SK)
SELECT AL_CLINICAL_TRIAL_NM,AL_TRIAL_COUNTRY_CD,TRIAL_SITE_ID,CLINICAL_SUBJECT_ID,CLINICAL_VISIT_NO,AL_AE_START_DT,AE_SERIOUSNESS_CD,AE_PREFERRED_TR,AE_CAUSALITY_SUSPECTED_DE,
	ACTION_TAKEN_3_CD,DEDW_OPERATION_TS,ADVERSE_EVENT_SK
	FROM 
            '||l_src_tab_name||'@'||l_src_tgt_link_name
            || CASE 
			     WHEN PI_CODE='INCR'
			  THEN ' WHERE DEDW_OPERATION_TS >'''||l_last_exec_time||''''
			  end;
			  
			  
        pkg_cstm_obj.p_ins_etl_logging(l_seq_num,l_stg_tab_name,l_etl_execution_id,'POPULATE STAGE TABLE','START',l_stage_sql);
        EXECUTE IMMEDIATE 'TRUNCATE TABLE '||l_stg_tab_name;
        EXECUTE IMMEDIATE l_stage_sql;
        ln_row_cnt := SQL%rowcount;
        pkg_cstm_obj.p_updt_etl_logging(ln_row_cnt,'SUCCESS',l_seq_num);
    EXCEPTION
        WHEN OTHERS THEN
            pkg_cstm_obj.p_ins_exception(l_stg_tab_name,'POPULATE STAGE TABLE',sqlcode,sqlerrm,l_stage_sql);
            pkg_cstm_obj.p_updt_etl_logging(NULL,'FAILED',l_seq_num);
            RAISE;
    END;		
	
	COMMIT;  
END;
/