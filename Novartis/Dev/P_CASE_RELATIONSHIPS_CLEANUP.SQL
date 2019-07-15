CREATE OR REPLACE PROCEDURE p_case_relationships_cleanup
IS
   ln_etl_seq_value        NUMBER;
   ln_etl_proc_seq_value   NUMBER;
   l_etl_execution_id      NUMBER;
   ln_row_count            NUMBER;
   lvc_etl_proc_desc       VARCHAR2 (1000);
   lvc_sql                 VARCHAR2 (30000);
   lvc_loop_sql            VARCHAR2 (32767);
   lvc_mart_type           VARCHAR2 (100);
   lvc_etl_type            VARCHAR2 (100);
BEGIN
   l_etl_execution_id :=
                  pkg_etl_util.f_get_etl_constants_value ('ETL_EXECUTION_ID');
   ln_etl_proc_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
   lvc_mart_type := pkg_etl_util.f_get_etl_constants_value ('MART_TYPE');
   lvc_etl_type := pkg_etl_util.f_get_etl_constants_value ('ETL_TYPE');
   pkg_etl_util.p_insert_stg_log
      (ln_etl_proc_seq_value,
       'S_CASE_RELATIONSHIPS',
       'P_CASE_RELATIONSHIPS_CLEANUP',
       NULL,
       'EXECUTING CLEANUP OF S_CASE_RELATIONSHIPS IN P_CASE_RELATIONSHIPS_CLEANUP',
       'START',
       NULL,
       NULL
      );

   IF lvc_mart_type = 'DLP'
   THEN
      FOR c1 IN
         (SELECT *
            FROM (SELECT ceu.case_id, ceu.seq_num, ceu.symptom,
                         ceu.dlp_revision_number, ceu.enterprise_id,
                         ROW_NUMBER () OVER (PARTITION BY ceu.enterprise_id, ceu.case_id, ceu.symptom, pcr.version_num ORDER BY ceu.seq_num DESC)
                                                                           rn
                    FROM m_case_relationships ceu,
                         pvr_case_revisions_temp pcr
                   WHERE ceu.case_id = pcr.case_id
                     AND ceu.enterprise_id = pcr.enterprise_id
                     AND ceu.effective_start_date <= pcr.effective_start_date
                     AND ceu.effective_end_date > pcr.effective_start_date
                     AND ceu.deleted IS NULL
                     AND pcr.processed = 0)
           WHERE rn <> 1)
      LOOP
         ln_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
         pkg_etl_util.p_insert_stg_log
            (ln_etl_seq_value,
             'S_CASE_RELATIONSHIPS',
             'P_CASE_RELATIONSHIPS_CLEANUP',
             NULL,
                'DELETING MULTIPLE RECORDS IN S_CASE_RELATIONSHIPS IN P_CASE_RELATIONSHIPS_CLEANUP FOR CASE_ID = '
             || c1.case_id
             || ' AND SEQ_NUM = '
             || c1.seq_num
             || ' AND SYMPTOM = '
             || c1.symptom
             || ' AND dlp_revision_number = '
             || c1.dlp_revision_number
             || ' AND enterprisE_id = '
             || c1.enterprise_id,
             'START',
             NULL,
             NULL
            );
         lvc_sql :=
               'DELETE FROM m_case_relationships
WHERE CASE_ID = '
            || c1.case_id
            || ' AND SEQ_NUM = '
            || c1.seq_num
            || ' AND SYMPTOM = '
            || c1.symptom
            || ' AND dlp_revision_number = '
            || c1.dlp_revision_number
            || ' AND enterprisE_id = '
            || c1.enterprise_id;

         EXECUTE IMMEDIATE lvc_sql;

         ln_row_count := SQL%ROWCOUNT;

         IF lvc_etl_type = 'INIT'
         THEN
            COMMIT;
         END IF;

         pkg_etl_util.p_insert_stg_log
            (ln_etl_seq_value,
             'S_CASE_RELATIONSHIPS',
             'P_CASE_RELATIONSHIPS_CLEANUP',
             ln_row_count,
                'DELETING MULTIPLE RECORDS IN S_CASE_RELATIONSHIPS IN P_CASE_RELATIONSHIPS_CLEANUP FOR CASE_ID = '
             || c1.case_id
             || ' AND SEQ_NUM = '
             || c1.seq_num
             || ' AND SYMPTOM = '
             || c1.symptom
             || ' AND dlp_revision_number = '
             || c1.dlp_revision_number
             || ' AND enterprisE_id = '
             || c1.enterprise_id,
             'SUCCESS',
             NULL,
             lvc_sql
            );
      END LOOP;
   ELSIF lvc_mart_type = 'ARGUS'
   THEN
      FOR c1 IN
         (SELECT *
            FROM (SELECT ceu.case_id, ceu.seq_num, ceu.symptom,
                         ceu.dlp_revision_number, ceu.enterprise_id,
                         ROW_NUMBER () OVER (PARTITION BY ceu.enterprise_id, ceu.case_id, ceu.symptom, ceu.dlp_revision_number ORDER BY ceu.seq_num DESC)
                                                                           rn
                    FROM s_case_relationships ceu
                   WHERE deleted IS NULL)
           WHERE rn <> 1)
      LOOP
         ln_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
         pkg_etl_util.p_insert_stg_log
            (ln_etl_seq_value,
             'S_CASE_RELATIONSHIPS',
             'P_CASE_RELATIONSHIPS_CLEANUP',
             NULL,
                'DELETING MULTIPLE RECORDS IN S_CASE_RELATIONSHIPS IN P_CASE_RELATIONSHIPS_CLEANUP FOR CASE_ID = '
             || c1.case_id
             || ' AND SEQ_NUM = '
             || c1.seq_num
             || ' AND SYMPTOM = '
             || c1.symptom
             || ' AND dlp_revision_number = '
             || c1.dlp_revision_number
             || ' AND enterprisE_id = '
             || c1.enterprise_id,
             'START',
             NULL,
             NULL
            );
         lvc_sql :=
               'DELETE FROM S_CASE_RELATIONSHIPS
WHERE CASE_ID = '
            || c1.case_id
            || ' AND SEQ_NUM = '
            || c1.seq_num
            || ' AND dlp_revision_number = '
            || c1.dlp_revision_number
            || ' AND enterprisE_id = '
            || c1.enterprise_id;

         EXECUTE IMMEDIATE lvc_sql;

         ln_row_count := SQL%ROWCOUNT;

         IF lvc_etl_type = 'INIT'
         THEN
            COMMIT;
         END IF;

         pkg_etl_util.p_insert_stg_log
            (ln_etl_seq_value,
             'S_CASE_RELATIONSHIPS',
             'P_CASE_RELATIONSHIPS_CLEANUP',
             ln_row_count,
                'DELETING MULTIPLE RECORDS IN S_CASE_RELATIONSHIPS IN P_CASE_RELATIONSHIPS_CLEANUP FOR CASE_ID = '
             || c1.case_id
             || ' AND SEQ_NUM = '
             || c1.seq_num
             || ' AND SYMPTOM = '
             || c1.symptom
             || ' AND dlp_revision_number = '
             || c1.dlp_revision_number
             || ' AND enterprisE_id = '
             || c1.enterprise_id,
             'SUCCESS',
             NULL,
             lvc_sql
            );
      END LOOP;
   END IF;

   pkg_etl_util.p_insert_stg_log
      (ln_etl_proc_seq_value,
       'S_CASE_RELATIONSHIPS',
       'P_CASE_RELATIONSHIPS_CLEANUP',
       NULL,
       'EXECUTING CLEANUP OF S_CASE_RELATIONSHIPS IN P_CASE_RELATIONSHIPS_CLEANUP',
       'SUCCESS',
       NULL,
       NULL
      );
EXCEPTION
   WHEN OTHERS
   THEN
      pkg_etl_util.p_set_etl_constants_value ('ETL_INTERNAL_JOB_STATUS', 2);
      pkg_etl_util.p_insert_stg_log
         (ln_etl_proc_seq_value,
          'S_CASE_RELATIONSHIPS',
          'P_CASE_RELATIONSHIPS_CLEANUP',
          NULL,
          'EXECUTING CLEANUP OF S_CASE_RELATIONSHIPS IN P_CASE_RELATIONSHIPS_CLEANUP',
          'ERROR',
          NULL,
          lvc_sql
         );
      ln_etl_proc_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_excp
                             (ln_etl_proc_seq_value,
                              'S_CASE_RELATIONSHIPS',
                              'ERROR OCCURED IN P_CASE_RELATIONSHIPS_CLEANUP',
                              SQLCODE,
                              TO_CHAR (   SQLERRM
                                       || ' -> '
                                       || DBMS_UTILITY.format_error_backtrace
                                       || ' -> '
                                       || lvc_sql
                                      )
                             );
      ROLLBACK;
      raise_application_error (-20001,
                               'ERROR OCCURED IN P_CASE_RELATIONSHIPS_CLEANUP'
                              );
END;
/