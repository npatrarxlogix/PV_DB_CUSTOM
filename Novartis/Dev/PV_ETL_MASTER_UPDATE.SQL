BEGIN
   UPDATE pvr_etl_stage_table_mapping
      SET post_stage_cleanup = 'P_CASE_RELATIONSHIPS_CLEANUP'
    WHERE tgt_table_name IN ('S_CASE_RELATIONSHIPS');

   COMMIT;
END;
/