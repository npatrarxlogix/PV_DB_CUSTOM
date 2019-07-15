create or replace PROCEDURE P_M_STUDY_SUBJ_FIG_ALL(PI_MODE VARCHAR2) as
    ln_row_cnt           NUMBER;
    l_seq_num            NUMBER;
    l_target_sql         CLOB;
    l_etl_execution_id   NUMBER := pvd_cstm_seq.currval;
	l_stg_tab_name       VARCHAR2(4000);
    l_tgt_tab_name       VARCHAR2(4000);
BEGIN
IF pi_mode = 'INIT' THEN
--------------------------------------------------------
--  Populating Table STUDY_SUBJ_FIG_ALL_NVS
--------------------------------------------------------

begin	
        l_seq_num := pvd_cstm_table_log.nextval;
       EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_SUBJ_FIG_ALL''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_SUBJ_FIG_ALL''' INTO l_stg_tab_name;
		
        l_target_sql := 'INSERT INTO '||l_tgt_tab_name||'(TRIAL_NO,PATIENT_FIGURE_TYPE,ENTERED_TREATMENT,STUDY_SUBJ_FIG_EID_AUTHOR_BAS,STUDY_SUBJ_FIG_EID_AUTHOR_FUP,STUDY_SUBJ_FIG_EID_AUTHOR_SCR
			,STUDY_SUBJ_FIG_EID_AUTHOR_TRT,STUDY_SUBJ_FIG_EID_BAS,STUDY_SUBJ_FIG_EID_FUP,STUDY_SUBJ_FIG_EID_SCR,STUDY_SUBJ_FIG_EID_TRT
			,GG_COMMIT_TIME,PVR_LAST_UPDATE_TIME,PVR_LAST_UPDATE_BY,BATCH,PARTITION)
        SELECT
            TRIAL_NO,PATIENT_FIGURE_TYPE,ENTERED_TREATMENT,STUDY_SUBJ_FIG_EID_AUTHOR_BAS,STUDY_SUBJ_FIG_EID_AUTHOR_FUP,STUDY_SUBJ_FIG_EID_AUTHOR_SCR
			,STUDY_SUBJ_FIG_EID_AUTHOR_TRT,STUDY_SUBJ_FIG_EID_BAS,STUDY_SUBJ_FIG_EID_FUP,STUDY_SUBJ_FIG_EID_SCR,STUDY_SUBJ_FIG_EID_TRT
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
--  Populating Table STUDY_SUBJ_FIG_ALL_NVS
--------------------------------------------------------

begin	
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_SUBJ_FIG_ALL''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_STUDY_SUBJ_FIG_ALL''' INTO l_stg_tab_name;
        l_target_sql := 'MERGE INTO '||l_tgt_tab_name||' ttn USING (
    SELECT
        TRIAL_NO,PATIENT_FIGURE_TYPE,ENTERED_TREATMENT,STUDY_SUBJ_FIG_EID_AUTHOR_BAS,STUDY_SUBJ_FIG_EID_AUTHOR_FUP,STUDY_SUBJ_FIG_EID_AUTHOR_SCR
			,STUDY_SUBJ_FIG_EID_AUTHOR_TRT,STUDY_SUBJ_FIG_EID_BAS,STUDY_SUBJ_FIG_EID_FUP,STUDY_SUBJ_FIG_EID_SCR,STUDY_SUBJ_FIG_EID_TRT
			,GG_COMMIT_TIME,SYSDATE PVR_LAST_UPDATE_TIME, ''RXL'' PVR_LAST_UPDATE_BY,BATCH,PARTITION
    FROM '||l_stg_tab_name||'
)
stn ON (
    ttn.study_subj_fig_eid_scr = stn.study_subj_fig_eid_scr
    AND ttn.study_subj_fig_eid_author_scr = stn.study_subj_fig_eid_author_scr
        AND ttn.study_subj_fig_eid_trt = stn.study_subj_fig_eid_trt
            AND ttn.study_subj_fig_eid_author_trt = stn.study_subj_fig_eid_author_trt
                AND ttn.study_subj_fig_eid_fup = stn.study_subj_fig_eid_fup
                    AND ttn.study_subj_fig_eid_author_fup = stn.study_subj_fig_eid_author_fup
                        AND ttn.study_subj_fig_eid_bas = stn.study_subj_fig_eid_bas
                            AND ttn.study_subj_fig_eid_author_bas = stn.study_subj_fig_eid_author_bas
)
WHEN MATCHED THEN UPDATE SET ttn.trial_no = stn.trial_no,
ttn.entered_treatment = stn.entered_treatment,
ttn.patient_figure_type = stn.patient_figure_type,
ttn.GG_COMMIT_TIME = stn.GG_COMMIT_TIME,
ttn.PVR_LAST_UPDATE_TIME = stn.PVR_LAST_UPDATE_TIME,
ttn.PVR_LAST_UPDATE_BY = stn.PVR_LAST_UPDATE_BY,
ttn.batch = stn.batch,
ttn.partition = stn.partition
WHEN NOT MATCHED THEN INSERT (
    study_subj_fig_eid_scr,
    study_subj_fig_eid_author_scr,
    study_subj_fig_eid_trt,
    study_subj_fig_eid_author_trt,
    study_subj_fig_eid_fup,
    study_subj_fig_eid_author_fup,
    study_subj_fig_eid_bas,
    study_subj_fig_eid_author_bas,
    trial_no,
    entered_treatment,
    patient_figure_type,
	GG_COMMIT_TIME,
	PVR_LAST_UPDATE_TIME,
	PVR_LAST_UPDATE_BY,
    batch,
    partition ) VALUES (
    stn.study_subj_fig_eid_scr,
    stn.study_subj_fig_eid_author_scr,
    stn.study_subj_fig_eid_trt,
    stn.study_subj_fig_eid_author_trt,
    stn.study_subj_fig_eid_fup,
    stn.study_subj_fig_eid_author_fup,
    stn.study_subj_fig_eid_bas,
    stn.study_subj_fig_eid_author_bas,
    stn.trial_no,
    stn.entered_treatment,
    stn.patient_figure_type,
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