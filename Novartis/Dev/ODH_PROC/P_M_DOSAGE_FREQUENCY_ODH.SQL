create or replace PROCEDURE P_M_DOSAGE_FREQUENCY(PI_MODE VARCHAR2) as
    ln_row_cnt           NUMBER;
    l_seq_num            NUMBER;
    l_target_sql         CLOB;
    l_etl_execution_id   NUMBER := pvd_cstm_seq.currval;
	l_stg_tab_name       VARCHAR2(4000);
    l_tgt_tab_name       VARCHAR2(4000);
BEGIN
IF pi_mode = 'INIT' THEN

--------------------------------------------------------
--  Populating Table DOSAGE_FREQUENCY_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
		EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_DOSAGE_FREQUENCY''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_DOSAGE_FREQUENCY''' INTO l_stg_tab_name;
        l_target_sql := 'INSERT INTO '||l_tgt_tab_name||'(DOSAGE_FREQUENCY_EID,DOSAGE_FREQUENCY_EID_AUTHORITY,GG_COMMIT_TIME,PVR_LAST_UPDATE_TIME,PVR_LAST_UPDATE_BY,BATCH,PARTITION)
        SELECT
            DOSAGE_FREQUENCY_EID,DOSAGE_FREQUENCY_EID_AUTHORITY,GG_COMMIT_TIME,SYSDATE PVR_LAST_UPDATE_TIME,''RXL'' PVR_LAST_UPDATE_BY,BATCH,PARTITION
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
--  Populating Table DOSAGE_FREQUENCY_NVS
--------------------------------------------------------

begin
        l_seq_num := pvd_cstm_table_log.nextval;
        EXECUTE IMMEDIATE 'select TGT_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_DOSAGE_FREQUENCY''' INTO l_tgt_tab_name;
		EXECUTE IMMEDIATE 'select STAGE_TABLE_NAME from pvd_cstm_tables where TARGET_POPULATION_PROCEDURE=''P_M_DOSAGE_FREQUENCY''' INTO l_stg_tab_name;
        l_target_sql := 'MERGE INTO '||l_tgt_tab_name||' ttn USING (
    SELECT
        DOSAGE_FREQUENCY_EID,DOSAGE_FREQUENCY_EID_AUTHORITY,GG_COMMIT_TIME,SYSDATE PVR_LAST_UPDATE_TIME,''RXL'' PVR_LAST_UPDATE_BY,BATCH,PARTITION
    FROM '||l_stg_tab_name||'
)
stn ON (
    ttn.dosage_frequency_eid = stn.dosage_frequency_eid
    AND ttn.dosage_frequency_eid_authority = stn.dosage_frequency_eid_authority
)
WHEN MATCHED THEN UPDATE SET ttn.batch = stn.batch,
ttn.partition = stn.partition,
ttn.GG_COMMIT_TIME = stn.GG_COMMIT_TIME,
ttn.PVR_LAST_UPDATE_TIME = stn.PVR_LAST_UPDATE_TIME,
ttn.PVR_LAST_UPDATE_BY = stn.PVR_LAST_UPDATE_BY
WHEN NOT MATCHED THEN INSERT (
    dosage_frequency_eid,
    dosage_frequency_eid_authority,
	GG_COMMIT_TIME,
	PVR_LAST_UPDATE_TIME,
	PVR_LAST_UPDATE_BY,
    batch,
    partition ) VALUES (
    stn.dosage_frequency_eid,
    stn.dosage_frequency_eid_authority,
	stn.GG_COMMIT_TIME,
    stn.PVR_LAST_UPDATE_TIME,
    stn.PVR_LAST_UPDATE_BY,
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