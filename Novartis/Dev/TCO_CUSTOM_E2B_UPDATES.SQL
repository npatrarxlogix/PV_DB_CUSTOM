BEGIN
   UPDATE pvr_etl_stage_table_mapping
      SET hidden = 'Y'
    WHERE tgt_table_name IN
                       ( 'S_MESSAGES', 'S_SAFETYREPORT', 'S_ACKNOWLEDGMENT' );

   UPDATE pvr_etl_master
      SET hidden = 'Y'
    WHERE tgt_table_name IN
                       ( 'E2B_INFO', 'ACKNOWLEDGMENT_ADDL', 'MESSAGES_ADDL' );

   UPDATE pvr_etl_constants
      SET etl_value = ''
    WHERE etl_key = 'ETL_HOOK_POST_CASE_TRANSFORM#1';

   UPDATE pvr_etl_constants
      SET etl_value = 'P_CUSTOM_E2B_MASTER_SCRIPT'
    WHERE etl_key = 'ETL_HOOK_PRE_STAGING#1';
	
   INSERT INTO pvr_etl_master
               (tgt_table_name, table_type, versioned_table, lang_seq_name,
                lang_table_exists, drop_cons_indexes, table_seq,
                dt_view_name, pre_cleanup_proc, hidden)
        VALUES ('ACTIVESUBSTANCE_ADDL', 'E2B', NULL, NULL, NULL, NULL, 15,
                'V_ACTIVESUBSTANCE_DT', NULL, 'Y');
	
   INSERT INTO pvr_etl_constants
               ( etl_key, etl_value
               )
        VALUES ( 'ETL_HOOK_POST_CDR_TRANSFORM#3', 'P_CUSTOM_E2B_MASTER_SCRIPT'
               );
   INSERT INTO pvr_etl_constants
               ( etl_key, etl_value
               )
        VALUES ( 'ETL_HOOK_POST_CDR_TRANSFORM#4', 'P_CALL_E2B_TABLES_UPDATE'
               );			   

   INSERT INTO pvr_etl_constants
               ( etl_key, etl_value
               )
        VALUES ( 'ACK_CHUNK_SIZE_PROCESSED', 0
               );
   INSERT INTO pvr_etl_constants
               ( etl_key, etl_value
               )
        VALUES ( 'MESSAGES_CHUNK_SIZE_PROCESSED', 0
               );
   INSERT INTO pvr_etl_constants
               ( etl_key, etl_value
               )
        VALUES ( 'E2B_INFO_CHUNK_SIZE_PROCESSED',0
               );
   INSERT INTO pvr_etl_constants
               ( etl_key, etl_value
               )
        VALUES ( 'ACT_SUB_CHUNK_SIZE_PROCESSED',0
               );			   
   INSERT INTO pvr_etl_constants
               ( etl_key, etl_value
               )
        VALUES ( 'FLAG_ESM_TABLES_UPDATE',0
               );	
   INSERT INTO pvr_etl_constants
               ( etl_key, etl_value
               )
        VALUES ( 'ETL_HOOK_END_STEP#8','PKG_ETL_RO_STG.P_MAIN'
               );			   

   MERGE INTO pvr_etl_constants pec
      USING ( SELECT 'ETL_HOOK_END_STEP#8' etl_key,
                     'P_CHECK_CUSTOM_E2B_JOBS' etl_value
               FROM DUAL ) a
      ON ( pec.etl_key = a.etl_key )
      WHEN MATCHED THEN
         UPDATE
            SET etl_value = a.etl_value
      WHEN NOT MATCHED THEN
         INSERT ( etl_key, etl_value )
         VALUES ( a.etl_key, a.etl_value );			   

   COMMIT;
END;
/