CREATE OR REPLACE PROCEDURE P_S_STUDY_USERDEF_ITEM (
    pi_mode VARCHAR2
) IS

    ln_row_cnt           NUMBER;
    l_seq_num            NUMBER;
    l_stage_sql          CLOB;
    l_etl_execution_id   NUMBER := pvd_cstm_seq.currval;
    l_stg_tab_name       VARCHAR2(4000);
	l_src_tab_name       VARCHAR2(4000);
    l_tgt_tab_name       VARCHAR2(4000);
BEGIN
--------------------------------------------------------
--  Populating Table S_ESB_V_STUDY_USERDEF_ITEM
--------------------------------------------------------

    BEGIN
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where STAGE_POPULATION_PROCEDURE=''P_S_STUDY_USERDEF_ITEM''' INTO l_stg_tab_name;
		EXECUTE IMMEDIATE 'select SRC_TABLE_NAME from pvd_cstm_tables where STAGE_POPULATION_PROCEDURE=''P_S_STUDY_USERDEF_ITEM''' INTO l_src_tab_name;
        IF pi_mode = 'INIT' 
		THEN
		l_stage_sql := 'INSERT INTO '||l_stg_tab_name||'
	(STUDY_EREF,STUDY_CODE_NCC,TRIAL_NO,ITEM_NAME,ITEM_VALUE,ITEM_CODE ,STUDY_USERDEF_ITEM_EID,STUDY_USERDEF_ITEM_EID_AUTH
			,STUDY_CODE_ALIAS,GG_COMMIT_TIME,BATCH,PARTITION)
        SELECT
            STUDY_EREF,STUDY_CODE_NCC,TRIAL_NO,ITEM_NAME,ITEM_VALUE,ITEM_CODE ,STUDY_USERDEF_ITEM_EID,STUDY_USERDEF_ITEM_EID_AUTH
			,STUDY_CODE_ALIAS,GG_COMMIT_TIME,BATCH,PARTITION
        FROM
            '||l_src_tab_name
;
        ELSIF pi_mode = 'INCR'
		THEN
		l_stage_sql := 'INSERT INTO '||l_stg_tab_name||'
	(STUDY_EREF,STUDY_CODE_NCC,TRIAL_NO,ITEM_NAME,ITEM_VALUE,ITEM_CODE ,STUDY_USERDEF_ITEM_EID,STUDY_USERDEF_ITEM_EID_AUTH
			,STUDY_CODE_ALIAS,GG_COMMIT_TIME,BATCH,PARTITION)
        SELECT STUDY_EREF,STUDY_CODE_NCC,TRIAL_NO,ITEM_NAME,ITEM_VALUE,ITEM_CODE ,STUDY_USERDEF_ITEM_EID,STUDY_USERDEF_ITEM_EID_AUTH
			,STUDY_CODE_ALIAS,GG_COMMIT_TIME,BATCH,PARTITION FROM (SELECT
            STUDY_EREF,STUDY_CODE_NCC,TRIAL_NO,ITEM_NAME,ITEM_VALUE,ITEM_CODE ,STUDY_USERDEF_ITEM_EID,STUDY_USERDEF_ITEM_EID_AUTH
			,STUDY_CODE_ALIAS,GG_COMMIT_TIME,BATCH,PARTITION,
			ROW_NUMBER() OVER(PARTITION BY STUDY_USERDEF_ITEM_EID,STUDY_USERDEF_ITEM_EID_AUTH ORDER BY BATCH DESC) rn
        FROM
            '||l_src_tab_name || ' where batch in(select batch from pvd_temp_batch_tbl)) WHERE rn = 1'
;
        END IF;
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