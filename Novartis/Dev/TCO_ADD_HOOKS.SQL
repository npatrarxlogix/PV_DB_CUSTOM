BEGIN
   UPDATE pvr_etl_constants
      SET etl_value = '1'
    WHERE etl_key = 'POPULATE_CUSTOM_PBRER_CATEGORY';

   MERGE INTO pvr_etl_constants pec
      USING (SELECT 'ETL_HOOK_POST_CDR_TRANSFORM#2' etl_key,
                    'PKG_POST_CASE_TRANSFORM.P_MAIN' etl_value
               FROM DUAL) qry
      ON (pec.etl_key = qry.etl_key)
      WHEN MATCHED THEN
         UPDATE
            SET etl_value = qry.etl_value
      WHEN NOT MATCHED THEN
         INSERT (etl_key, etl_value)
         VALUES (qry.etl_key, qry.etl_value);
   COMMIT;
END;
/