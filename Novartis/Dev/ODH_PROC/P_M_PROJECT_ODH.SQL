create or replace PROCEDURE P_M_PROJECT(PI_MODE VARCHAR2) as
    ln_row_cnt           NUMBER;
    l_seq_num            NUMBER;
    l_target_sql         CLOB;
    l_etl_execution_id   NUMBER := pvd_cstm_seq.currval;
	l_stg_tab_name       VARCHAR2(4000);
    l_tgt_tab_name       VARCHAR2(4000);
BEGIN
IF pi_mode = 'INIT' THEN
--------------------------------------------------------
--  Populating Table PROJECT_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_PROJECT''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_PROJECT''' INTO l_stg_tab_name;
        l_target_sql := 'INSERT INTO '||l_tgt_tab_name||'(COMPOUND_CODE,PROJECT_CODE_NCC,PROJECT_CODE_ALIAS,PROJECT_EID,PROJECT_EID_AUTHORITY,GG_COMMIT_TIME
            ,PVR_LAST_UPDATE_TIME,PVR_LAST_UPDATE_BY,BATCH,PARTITION)
        SELECT
            COMPOUND_CODE,PROJECT_CODE_NCC,PROJECT_CODE_ALIAS,PROJECT_EID,PROJECT_EID_AUTHORITY,GG_COMMIT_TIME
			,SYSDATE PVR_LAST_UPDATE_TIME, ''RXL'' PVR_LAST_UPDATE_BY,BATCH,PARTITION
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
--  Populating Table PROJECT_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_PROJECT''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_PROJECT''' INTO l_stg_tab_name;
        l_target_sql := 'MERGE INTO '||l_tgt_tab_name||' ttn USING (
   SELECT
            EVP.COMPOUND_CODE,EVP.PROJECT_CODE_NCC,EVP.PROJECT_CODE_ALIAS,EVP.PROJECT_EID,EVP.PROJECT_EID_AUTHORITY,EVP.GG_COMMIT_TIME
			,SYSDATE PVR_LAST_UPDATE_TIME, ''RXL'' PVR_LAST_UPDATE_BY,EVP.BATCH,EVP.PARTITION
        FROM  '||l_stg_tab_name||' EVP
)
stn ON (
    ttn.project_eid = stn.project_eid
    AND ttn.project_eid_authority = stn.project_eid_authority
)
WHEN MATCHED THEN UPDATE SET ttn.project_code_ncc = stn.project_code_ncc,
ttn.project_code_alias = stn.project_code_alias,
ttn.compound_code = stn.compound_code,
ttn.gg_commit_time = stn.gg_commit_time,
ttn.PVR_LAST_UPDATE_TIME = stn.PVR_LAST_UPDATE_TIME,
ttn.PVR_LAST_UPDATE_BY = stn.PVR_LAST_UPDATE_BY,
ttn.BATCH = stn.BATCH,
ttn.PARTITION = stn.PARTITION
WHEN NOT MATCHED THEN INSERT (			 
    project_eid,
    project_eid_authority,
    project_code_ncc,
    project_code_alias,
    compound_code,
    gg_commit_time,
	PVR_LAST_UPDATE_TIME,
	PVR_LAST_UPDATE_BY,
	BATCH,
	PARTITION
    )
	VALUES
	(
    stn.project_eid,
    stn.project_eid_authority,
    stn.project_code_ncc,
    stn.project_code_alias,
    stn.compound_code,
    stn.gg_commit_time,
	stn.PVR_LAST_UPDATE_TIME,
	stn.PVR_LAST_UPDATE_BY,
    stn.BATCH,
	stn.PARTITION
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