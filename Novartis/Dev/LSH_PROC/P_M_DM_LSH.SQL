create or replace PROCEDURE P_M_DM(PI_MODE VARCHAR2) as 
    ln_row_cnt           NUMBER;
    l_seq_num            NUMBER;
    l_target_sql         CLOB;
    l_etl_execution_id   NUMBER := pvd_cstm_seq.currval;
	l_src_tab_name       VARCHAR2(4000);
	l_src_tgt_link_name  VARCHAR2(4000);
	l_stg_tab_name       VARCHAR2(4000);
    l_tgt_tab_name       VARCHAR2(4000);
	
begin
--------------------------------------------------------
--  Populating Table DM_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_DM''' INTO l_stg_tab_name;
		EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_DM''' INTO l_tgt_tab_name;
        l_target_sql := 'INSERT INTO '||l_tgt_tab_name||'
	(STUDY,COUNTRY,STUDY_SITE,PATIENT,AGEDRV,RACE,SEX,PVR_LAST_UPDATE_TIME,PVR_LAST_UPDATE_BY)
	SELECT STUDY,COUNTRY,STUDY_SITE,PATIENT,AGEDRV,RACE,SEX,NULL PVR_LAST_UPDATE_TIME,NULL PVR_LAST_UPDATE_BY
	FROM '||l_stg_tab_name
;
        pkg_cstm_obj.p_ins_etl_logging(l_seq_num,l_tgt_tab_name,l_etl_execution_id,'POPULATE MART TABLE','START',l_target_sql);
P_MART_LSH_TRUNCATE(l_tgt_tab_name);
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


end;
/