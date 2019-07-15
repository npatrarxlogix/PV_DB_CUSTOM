CREATE OR REPLACE PACKAGE BODY pkg_post_case_transform
IS
   g_etl_mode          VARCHAR2 (400)
                       := pkg_etl_util.f_get_etl_constants_value ('ETL_TYPE');
   l_etl_seq_value     NUMBER;
   ln_execute_status   NUMBER;
   g_etl_seq_value     NUMBER;
   gvc_sql             CLOB;
   g_row_count         NUMBER;

   PROCEDURE p_update_pop_marketing
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE c_master_addl
            SET pop_marketing = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                             (g_etl_seq_value,
                              'C_MASTER_ADDL',
                              'P_UPDATE_POP_MARKETING',
                              NULL,
                              'UPDATING POP Marketing Field IN C_MASTER_ADDL',
                              'START',
                              NULL,
                              NULL
                             );
      gvc_sql :=
            'MERGE INTO c_master_addl ct
         USING (SELECT pkg_etl_util.f_collection_to_string
                      (CAST
                          (COLLECT (cs.nm_address ORDER BY cs.rank_id) AS udt_varchar2_tab
                          ),
                       '',''
                      ) nm_list, cs.tenant_id, cs.case_id, cs.version_num
                    FROM (SELECT    cs.TITLE_DESC
                                 || '' ''
                                 || cs.first_name
                                 || '' ''
                                 || cs.last_name
                                 || '' ''
                                 || cs.suffix
                                 || '' ''
                                 || cs.address_1
                                 || '' ''
                                 || cs.city
                                 || '' ''
                                 || cs.state_province
                                 || '' ''
                                 || cs.postal_code
                                 || '' ''
                                 || ra.country
                                 || '' ''
                                 || cs.organisation nm_address,
                                 cs.tenant_id, cs.case_id, cs.version_num,
                                 cs.rank_id
                            FROM pvr_case_revisions_temp pcr,
                                 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_source'
               ELSE 's_source'
            END
         || ' cs,
                                 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_reporters_addl'
               ELSE 's_reporters_addl'
            END
         || ' ra
                           WHERE pcr.case_id = cs.case_id
                             AND pcr.version_num = cs.version_num
                             AND pcr.enterprise_id = cs.tenant_id
                             AND cs.tenant_id = ra.tenant_id
                             AND cs.case_id = ra.case_id
                             AND cs.version_num = ra.version_num
                             AND cs.src_rec_num = ra.src_rec_num
                             AND cs.qualification_id = 23000303
                             AND pcr.processed = 0 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || ') cs
                GROUP BY cs.tenant_id, cs.case_id, cs.version_num) qry
         ON (    ct.tenant_id = qry.tenant_id
             AND ct.case_id = qry.case_id
             AND ct.version_num = qry.version_num)
         WHEN MATCHED THEN
           UPDATE
               SET pop_marketing = qry.nm_list';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_POP_MARKETING_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_POP_MARKETING_JOB -> ERROR OCCURED IN P_POP_MARKETING_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_POP_MARKETING_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_MASTER_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                             (g_etl_seq_value,
                              'C_MASTER_ADDL',
                              'P_UPDATE_POP_MARKETING',
                              g_row_count,
                              'UPDATING POP Marketing Field IN C_MASTER_ADDL',
                              'SUCCESS',
                              NULL,
                              gvc_sql
                             );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_POP_MARKETING';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_case_category
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE c_identification_fu
            SET case_category_id = NULL,
                case_category_desc = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
         (g_etl_seq_value,
          'C_IDENTIFICATION_FU',
          'P_UPDATE_CLINICAL_TRIAL',
          NULL,
          'UPDATING CASE CATEGORY Field FOR CLINICAL TRIAL IN C_IDENTIFICATION_FU',
          'START',
          NULL,
          NULL
         );
      gvc_sql :=
            'MERGE INTO c_identification_fu outer_cm
         USING (SELECT cfu.tenant_id, cfu.case_id, cfu.version_num
                  FROM pvr_case_revisions_temp pcr, '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_identification'
               ELSE 's_identification'
            END
         || ' cfu
                 WHERE pcr.case_id = cfu.case_id
                   AND pcr.version_num = cfu.version_num
                   AND pcr.enterprise_id = cfu.tenant_id
                   AND cfu.source_type_desc = ''Clinical Trial''
                   AND pcr.processed = 0
                   AND NOT EXISTS (
                          SELECT 1
                            FROM pvr_case_revisions_temp pcr,
                                 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_characteristics_fu'
               ELSE 's_characteristics_fu'
            END
         || ' ci
                           WHERE pcr.case_id = ci.case_id
                             AND pcr.version_num = ci.version_num
                             AND pcr.enterprise_id = ci.tenant_id
                             AND ci.case_id = cfu.case_id
                             AND ci.version_num = cfu.version_num
                             AND ci.tenant_id = cfu.tenant_id
                             AND pcr.processed = 0
                             AND ci.characteristic_desc IN
                                    (''Novartis Patient Registry'',
                                     ''Intensive Monitoring Project'',
                                     ''Post Marketing Surveillance'',
                                     ''Non-Novartis Trial'',
                                     ''Individual Patient Use'',
                                     ''Non-Novartis Patient Registry'',
                                     ''Epidemiological Study'',
                                     ''Compassionate Use'')) '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || ' group by cfu.tenant_id, cfu.case_id, cfu.version_num) qry
         ON (    outer_cm.case_id = qry.case_id
             AND outer_cm.tenant_id = qry.tenant_id
             AND outer_cm.version_num = qry.version_num)
         WHEN MATCHED THEN
            UPDATE
               SET case_category_id = 1,
                   case_category_desc = ''Clinical Trial''';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_CLINICAL_TRIAL_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_CLINICAL_TRIAL_JOB -> ERROR OCCURED IN P_CLINICAL_TRIAL_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_CLINICAL_TRIAL_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_IDENTIFICATION_FU');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
         (g_etl_seq_value,
          'C_IDENTIFICATION_FU',
          'P_UPDATE_CLINICAL_TRIAL',
          g_row_count,
          'UPDATING CASE CATEGORY Field FOR CLINICAL TRIAL IN C_IDENTIFICATION_FU',
          'SUCCESS',
          NULL,
          gvc_sql
         );
      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
         (g_etl_seq_value,
          'C_IDENTIFICATION_FU',
          'P_UPDATE_POST_MARKETING',
          NULL,
          'UPDATING CASE CATEGORY Field FOR Post Marketing IN C_IDENTIFICATION_FU',
          'START',
          NULL,
          NULL
         );
      gvc_sql :=
            'MERGE INTO c_identification_fu outer_cm
         USING (SELECT cfu.tenant_id, cfu.case_id, cfu.version_num
                  FROM pvr_case_revisions_temp pcr, '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_identification'
               ELSE 's_identification'
            END
         || ' cfu
                 WHERE     pcr.case_id = cfu.case_id
                       AND pcr.version_num = cfu.version_num
                       AND pcr.enterprise_id = cfu.tenant_id
                       AND pcr.processed = 0
                       AND (cfu.source_type_desc NOT IN
                                                  (''Other'', ''Clinical Trial'')
                    OR (    cfu.source_type_desc = ''Clinical Trial''
                        AND EXISTS (
                               SELECT 1
                                 FROM pvr_case_revisions_temp pcr,
                                      '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_characteristics_fu'
               ELSE 's_characteristics_fu'
            END
         || ' ci
                                WHERE pcr.case_id = ci.case_id
                                  AND pcr.version_num = ci.version_num
                                  AND pcr.enterprise_id = ci.tenant_id
                                  AND ci.case_id = cfu.case_id
                                  AND ci.version_num = cfu.version_num
                                  AND ci.tenant_id = cfu.tenant_id
                                  AND pcr.processed = 0
                                  AND ci.characteristic_desc IN
                                         (''Novartis Patient Registry'',
                                          ''Intensive Monitoring Project'',
                                          ''Post Marketing Surveillance'',
                                          ''Non-Novartis Trial'',
                                          ''Individual Patient Use'',
                                          ''Non-Novartis Patient Registry'',
                                          ''Epidemiological Study'',
                                          ''Compassionate Use''))
                       )) '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || ' group by cfu.tenant_id, cfu.case_id, cfu.version_num) qry
         ON (    outer_cm.case_id = qry.case_id
             AND outer_cm.tenant_id = qry.tenant_id
             AND outer_cm.version_num = qry.version_num)
         WHEN MATCHED THEN
            UPDATE
               SET case_category_id = 2,
                   case_category_desc = ''Post Marketing Surveillance''';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_POST_MARKETING_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_POST_MARKETING_JOB -> ERROR OCCURED IN P_POST_MARKETING_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_POST_MARKETING_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_IDENTIFICATION_FU');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
         (g_etl_seq_value,
          'C_IDENTIFICATION_FU',
          'P_UPDATE_POST_MARKETING',
          g_row_count,
          'UPDATING CASE CATEGORY Field FOR Post Marketing IN C_IDENTIFICATION_FU',
          'SUCCESS',
          NULL,
          gvc_sql
         );
      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
             (g_etl_seq_value,
              'C_IDENTIFICATION_FU',
              'P_UPDATE_OTHER',
              NULL,
              'UPDATING SR/LIT Field FOR Other IN C_IDENTIFICATION_FU',
              'START',
              NULL,
              NULL
             );
      gvc_sql :=
            'MERGE INTO c_identification_fu outer_cm
         USING (SELECT cfu.tenant_id, cfu.case_id, cfu.version_num
                  FROM pvr_case_revisions_temp pcr, '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_identification'
               ELSE 's_identification'
            END
         || ' cfu
                 WHERE pcr.case_id = cfu.case_id
                   AND pcr.version_num = cfu.version_num
                   AND pcr.enterprise_id = cfu.tenant_id
                   AND pcr.processed = 0
                   AND cfu.source_type_desc IN (''Literature Case'',''Spontaneous Report'') '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
                   group by cfu.tenant_id, cfu.case_id, cfu.version_num) qry
         ON (    outer_cm.case_id = qry.case_id
             AND outer_cm.tenant_id = qry.tenant_id
             AND outer_cm.version_num = qry.version_num)
         WHEN MATCHED THEN
            UPDATE
               SET case_category_id = 3, case_category_desc = ''SR/LIT''';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_OTHER_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_OTHER_JOB -> ERROR OCCURED IN P_OTHER_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001, 'ERROR OCCURED IN P_SR_LIT_JOB');
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_IDENTIFICATION_FU');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
             (g_etl_seq_value,
              'C_IDENTIFICATION_FU',
              'P_UPDATE_SR_LIT',
              g_row_count,
              'UPDATING CASE CATEGORY Field FOR SR/LIT IN C_IDENTIFICATION_FU',
              'SUCCESS',
              NULL,
              gvc_sql
             );
      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
             (g_etl_seq_value,
              'C_IDENTIFICATION_FU',
              'P_UPDATE_SR_LIT',
              NULL,
              'UPDATING CASE CATEGORY Field FOR Other IN C_IDENTIFICATION_FU',
              'START',
              NULL,
              NULL
             );
      gvc_sql :=
            'MERGE INTO c_identification_fu outer_cm
         USING (SELECT cfu.tenant_id, cfu.case_id, cfu.version_num
                  FROM pvr_case_revisions_temp pcr, '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_identification'
               ELSE 's_identification'
            END
         || ' cfu
                 WHERE pcr.case_id = cfu.case_id
                   AND pcr.version_num = cfu.version_num
                   AND pcr.enterprise_id = cfu.tenant_id
                   AND pcr.processed = 0
                   AND cfu.source_type_desc = ''Other'' '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
                   group by cfu.tenant_id, cfu.case_id, cfu.version_num) qry
         ON (    outer_cm.case_id = qry.case_id
             AND outer_cm.tenant_id = qry.tenant_id
             AND outer_cm.version_num = qry.version_num)
         WHEN MATCHED THEN
            UPDATE
               SET case_category_id = 4, case_category_desc = ''Other''';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_OTHER_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_OTHER_JOB -> ERROR OCCURED IN P_OTHER_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001, 'ERROR OCCURED IN P_OTHER_JOB');
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_IDENTIFICATION_FU');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
             (g_etl_seq_value,
              'C_IDENTIFICATION_FU',
              'P_UPDATE_OTHER',
              g_row_count,
              'UPDATING CASE CATEGORY Field FOR Other IN C_IDENTIFICATION_FU',
              'SUCCESS',
              NULL,
              gvc_sql
             );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_CASE_CATEGORY';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_pms_studies
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE c_master_addl
            SET pms_studies = 0
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                               (g_etl_seq_value,
                                'C_MASTER_ADDL',
                                'P_UPDATE_PMS_STUDIES',
                                NULL,
                                'UPDATING PMS STUDIES Field IN C_MASTER_ADDL',
                                'START',
                                NULL,
                                NULL
                               );
      gvc_sql :=
            'MERGE INTO c_master_addl outer_cm
         USING (SELECT   cfu.case_id, cfu.tenant_id, cfu.version_num
                    FROM pvr_case_revisions_temp pcr JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_identification'
               ELSE 's_identification'
            END
         || ' cfu
                         ON (    pcr.case_id = cfu.case_id
                             AND pcr.version_num = cfu.version_num
                             AND pcr.enterprise_id = cfu.tenant_id
                            )
                         JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_characteristics_fu'
               ELSE 's_characteristics_fu'
            END
         || ' ci
                         ON (    cfu.case_id = ci.case_id
                             AND cfu.version_num = ci.version_num
                             AND cfu.tenant_id = ci.tenant_id
                            )
                   WHERE cfu.source_type_desc = ''Clinical Trial''
                     AND pcr.processed = 0
                     AND ci.characteristic_desc IN
                            (''Novartis Patient Registry'',
                             ''Intensive Monitoring Project'',
                             ''Post Marketing Surveillance'',
                             ''Non-Novartis Trial'', ''Individual Patient Use'',
                             ''Non-Novartis Patient Registry'',
                             ''Epidemiological Study'', ''Compassionate Use'') '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
                GROUP BY cfu.case_id, cfu.tenant_id, cfu.version_num) qry
         ON (    outer_cm.case_id = qry.case_id
             AND outer_cm.tenant_id = qry.tenant_id
             AND outer_cm.version_num = qry.version_num)
         WHEN MATCHED THEN
            UPDATE
               SET pms_studies = 1';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_PMS_STUDIES_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_PMS_STUDIES_JOB -> ERROR OCCURED IN P_PMS_STUDIES_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_PMS_STUDIES_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_MASTER_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                               (g_etl_seq_value,
                                'C_MASTER_ADDL',
                                'P_UPDATE_PMS_STUDIES',
                                g_row_count,
                                'UPDATING PMS STUDIES Field IN C_MASTER_ADDL',
                                'SUCCESS',
                                NULL,
                                gvc_sql
                               );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_PMS_STUDIES';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_most_relevant
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE c_event_addl
            SET flag_most_rel_ae = 0
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                         (g_etl_seq_value,
                          'C_EVENT_ADDL',
                          'P_UPDATE_MOST_RELEVANT',
                          NULL,
                          'UPDATING Most Relevant flag Field IN C_EVENT_ADDL',
                          'START',
                          NULL,
                          NULL
                         );
      gvc_sql :=
            'MERGE INTO c_event_addl cea
         USING (WITH c_prod_ae_ca AS
               (SELECT cpa.case_id, cpa.tenant_id, cpa.version_num, cpa.prod_rec_num,
                       cpa.ae_rec_num,
                       DECODE (cpa.RESULT_ASSESSMENT_3_ID,
                               3, 3,
                               5, 5,
                               6
                              ) "RPT_CAUSALITY",
                       DECODE (cpa.RESULT_ASSESSMENT_1_ID,
                               3, 3,
                               5, 5,
                               6
                              ) "DET_CAUSALITY"
                  FROM pvr_case_revisions_temp pcr JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_prod_ae_causality'
               ELSE 's_prod_ae_causality'
            END
         || ' cpa
                       ON (    pcr.case_id = cpa.case_id
                             AND pcr.version_num = cpa.version_num
                             AND pcr.enterprise_id = cpa.tenant_id
                            ) where pcr.processed = 0),
               susp_relatedness AS
               (SELECT   case_id, tenant_id, version_num, ae_rec_num,
                         MIN (LEAST (rpt_causality, det_causality)
                             ) derived_causality
                    FROM c_prod_ae_ca
                GROUP BY case_id, tenant_id, version_num, ae_rec_num)
          SELECT case_id, version_num, tenant_id, ae_rec_num
            FROM (SELECT caif.case_id, caif.version_num, caif.tenant_id, caif.ae_rec_num,
                         ROW_NUMBER () OVER (PARTITION BY caif.case_id ORDER BY nvl(caif.flag_symptom,0),
                          nvl(cai.flag_serious_death,0) DESC,
                          nvl(cai.flag_serious_threat,0) DESC,
                          nvl(cai.flag_serious_cong_anom,0) DESC,
                          nvl(cai.flag_serious_hosp,0) DESC,
                          nvl(cai.flag_serious_disable,0) DESC,
                          nvl(cai.flag_serious_int_req,0) DESC,
                          nvl(cai.flag_ae_med_serious,0) DESC,
                          nvl(cai.flag_serious_prlng_hsptalized,0) DESC,
                          nvl(cai.flag_serious_other_med_imp,0) DESC,
                          DECODE (susp_relatedness.derived_causality,
                                  3, 1,
                                  5, 3,
                                  2
                                 ),
                          DECODE (cai.ae_outcome_desc,
                                  ''Fatal/Death'', 1,
                                  ''Death due to AE/infection'', 2,
                                  ''Death not due to AE/infection'', 3,
                                  ''Death Not Related'', 4,
                                  ''Congenital Anomaly'', 5,
                                  ''Abortion due to AE/Infection'', 6,
                                  ''Condition Deteriorated'', 7,
                                  ''Recovered with Sequelae'', 8,
                                  ''Condition Unchanged'', 9,
                                  ''Condition Improving'', 10,
                                                                                                  ''Complete Recovery'', 11,
                                                                                                  '' '', 12,
                                                                                                  ''Unknown'', 13,
                                                                                                  ''Not Reported'', 14,
                                                                                                  ''Not Applicable'', 15
                                 ),
                          cai.rank_id) rn
                    FROM pvr_case_revisions_temp pcr,
                         '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_ae_identification_fu'
               ELSE 's_ae_identification_fu'
            END
         || ' caif,
                         '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_ae_identification'
               ELSE 's_ae_identification'
            END
         || ' cai,
                         susp_relatedness
                   WHERE pcr.case_id = caif.case_id
                     AND pcr.version_num = caif.version_num
                     AND pcr.enterprise_id = caif.tenant_id
                     AND caif.case_id = cai.case_id
                     AND caif.version_num = cai.version_num
                     AND caif.tenant_id = cai.tenant_id
                     AND caif.ae_rec_num = cai.ae_rec_num
                     AND caif.case_id = susp_relatedness.case_id
                     AND caif.version_num = susp_relatedness.version_num
                     AND caif.tenant_id = susp_relatedness.tenant_id
                     AND caif.ae_rec_num = susp_relatedness.ae_rec_num
                     AND pcr.processed = 0 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || ')
           WHERE rn = 1) qry
   ON (    cea.case_id = qry.case_id
       AND cea.tenant_id = qry.tenant_id
       AND cea.version_num = qry.version_num
       AND cea.ae_rec_num = qry.ae_rec_num)
   WHEN MATCHED THEN
      UPDATE
         SET flag_most_rel_ae = 1';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_MOST_RELEVANT_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_MOST_RELEVANT_JOB -> ERROR OCCURED IN P_MOST_RELEVANT_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_MOST_RELEVANT_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_EVENT_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                         (g_etl_seq_value,
                          'C_EVENT_ADDL',
                          'P_UPDATE_MOST_RELEVANT',
                          g_row_count,
                          'UPDATING Most Relevant flag Field IN C_EVENT_ADDL',
                          'SUCCESS',
                          NULL,
                          gvc_sql
                         );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_MOST_RELEVANT';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_diagnosis_symptom
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE c_event_addl
            SET diag_to_symp_pt = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                     (g_etl_seq_value,
                      'C_EVENT_ADDL',
                      'P_UPDATE_DIAGNOSIS_SYMPTOM',
                      NULL,
                      'UPDATING Diagnosis Symptom flag Field IN C_EVENT_ADDL',
                      'START',
                      NULL,
                      NULL
                     );
      gvc_sql :=
            'MERGE INTO c_event_addl cai
         USING (SELECT case_id, ae_rec_num, tenant_id, version_num,
                    mdr_ae_pt
                 || CASE
                       WHEN diag_to_symp IS NOT NULL
                          THEN '':'' || diag_to_symp
                    END diag_to_symp
            FROM (SELECT   cai.case_id, cai.ae_rec_num, cai.tenant_id,
                           cai.version_num,
                           cai.mdr_ae_pt,
                           pkg_etl_util.f_collection_to_string
                      (CAST
                          (COLLECT (cra.mdr_ae_pt ORDER BY cra.rank_id) AS udt_varchar2_tab
                          ),
                       '',''
                      ) DIAG_TO_SYMP
                      FROM pvr_case_revisions_temp pcr JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_ae_identification'
               ELSE 's_ae_identification'
            END
         || ' cai
                           ON (    pcr.case_id = cai.case_id
                             AND pcr.version_num = cai.version_num
                             AND pcr.enterprise_id = cai.tenant_id
                            )
                           INNER JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_ae_identification_fu'
               ELSE 's_ae_identification_fu'
            END
         || ' caif
                           ON (    cai.case_id = caif.case_id
                               AND cai.tenant_id = caif.tenant_id
                               AND cai.version_num = caif.version_num
                               AND cai.ae_rec_num = caif.ae_rec_num
                              )
                           LEFT JOIN
                           (SELECT ca.case_id, ca.tenant_id, cra.diagnosis,
                                   ca.version_num, ca.mdr_ae_pt, ca.rank_id
                              FROM pvr_case_revisions_temp pcr JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_relationships_addl'
               ELSE 's_relationships_addl'
            END
         || ' cra
                           ON (    pcr.case_id = cra.case_id
                             AND pcr.version_num = cra.version_num
                             AND pcr.enterprise_id = cra.tenant_id
                            )
                            INNER JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_ae_identification'
               ELSE 's_ae_identification'
            END
         || ' ca
                                   ON (    cra.case_id = ca.case_id
                                       AND cra.tenant_id = ca.tenant_id
                                       AND cra.version_num = ca.version_num
                                       AND cra.symptom = ca.ae_rec_num
                                      )
                     WHERE pcr.processed = 0 ) cra
                           ON (    cai.case_id = cra.case_id
                               AND cai.tenant_id = cra.tenant_id
                               AND cai.version_num = cra.version_num
                               AND cra.diagnosis = cai.ae_rec_num
                              )
                     WHERE caif.flag_symptom = 0
                       AND pcr.processed = 0 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
                  GROUP BY cai.case_id,
                           cai.ae_rec_num,
                           cai.tenant_id,
                           cai.version_num,
                           cai.mdr_ae_pt)) qry
   ON (    cai.case_id = qry.case_id
       AND cai.tenant_id = qry.tenant_id
       AND cai.version_num = qry.version_num
       AND cai.ae_rec_num = qry.ae_rec_num)
   WHEN MATCHED THEN
      UPDATE
         SET diag_to_symp_pt = qry.diag_to_symp';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_DIAG_SYMPTOM_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_DIAG_SYMPTOM_JOB -> ERROR OCCURED IN P_DIAG_SYMPTOM_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_DIAG_SYMPTOM_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_EVENT_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                     (g_etl_seq_value,
                      'C_EVENT_ADDL',
                      'P_UPDATE_DIAGNOSIS_SYMPTOM',
                      g_row_count,
                      'UPDATING Diagnosis Symptom flag Field IN C_EVENT_ADDL',
                      'SUCCESS',
                      NULL,
                      gvc_sql
                     );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_DIAGNOSIS_SYMPTOM';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_cons_rept
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE c_prod_ae_causality
            SET flag_relatedness_1 = NULL,
                flag_relatedness_3 = NULL,
                flag_conservative_relatedness = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);

         UPDATE c_ae_identification_fu
            SET flag_all_susp_relatedness = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
          (g_etl_seq_value,
           'C_PROD_AE_CAUSALITY',
           'P_UPDATE_CONSERVATIVE_REPT',
           NULL,
           'UPDATING Conservative Reportability Field IN C_PROD_AE_CAUSALITY',
           'START',
           NULL,
           NULL
          );
      gvc_sql :=
            'MERGE INTO c_prod_ae_causality ct USING ( WITH c_prod_ae_ca AS (
    SELECT
        cpa.case_id,
        cpa.tenant_id,
        cpa.version_num,
        cpa.prod_rec_num,
        cpa.ae_rec_num,
        DECODE(cpa.result_assessment_3_id,3,3,5,5,6) "RPT_CAUSALITY",
        DECODE(cpa.result_assessment_1_id,3,3,5,5,6) "DET_CAUSALITY"
    FROM
        pvr_case_revisions_temp pcr,
        '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_prod_ae_causality'
               ELSE 's_prod_ae_causality'
            END
         || ' cpa
    WHERE
        pcr.case_id = cpa.case_id
        AND   pcr.version_num = cpa.version_num
        AND   pcr.enterprise_id = cpa.tenant_id
        AND   pcr.processed = 0 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
),abc AS (
    SELECT
        case_id,
        tenant_id,
        version_num,
        prod_rec_num,
        ae_rec_num,
       MIN(least(rpt_causality,det_causality) ) derived_causality
    FROM
        c_prod_ae_ca
    GROUP BY
        case_id,
        tenant_id,
        version_num,
        ae_rec_num,
        prod_rec_num
),susp_relatedness AS (
    SELECT
        case_id,
        tenant_id,
        version_num,
        prod_rec_num,
        ae_rec_num,
        DECODE(abc.derived_causality,3,3,5,5,3) cons_causality
    FROM
        abc
) SELECT
    a.case_id,
    a.version_num,
    a.tenant_id,
    a.prod_rec_num,
    a.ae_rec_num,
    a.rpt_causality,
    a.det_causality,
    b.cons_causality
  FROM
    c_prod_ae_ca a
    JOIN susp_relatedness b ON ( a.case_id = b.case_id
                                 AND a.version_num = b.version_num
                                 AND a.tenant_id = b.tenant_id
                                 AND a.prod_rec_num = b.prod_rec_num
                                 AND a.ae_rec_num = b.ae_rec_num )
    JOIN abc c ON ( a.case_id = c.case_id
                    AND a.version_num = c.version_num
                    AND a.tenant_id = c.tenant_id
                    AND a.prod_rec_num = c.prod_rec_num
                    AND a.ae_rec_num = c.ae_rec_num )
)
qry ON (
    ct.tenant_id = qry.tenant_id
    AND ct.case_id = qry.case_id
    AND ct.version_num = qry.version_num
    AND ct.prod_rec_num = qry.prod_rec_num
    AND ct.ae_rec_num = qry.ae_rec_num
)
WHEN MATCHED THEN UPDATE SET flag_relatedness_1 = qry.det_causality,
flag_relatedness_3 = qry.rpt_causality,
flag_conservative_relatedness = qry.cons_causality';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_CONSERVATIVE_REPT_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_CONSERVATIVE_REPT_JOB -> ERROR OCCURED IN P_CONSERVATIVE_REPT_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error
                                   (-20001,
                                    'ERROR OCCURED IN P_CONSERVATIVE_REPT_JOB'
                                   );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_PROD_AE_CAUSALITY');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
          (g_etl_seq_value,
           'C_PROD_AE_CAUSALITY',
           'P_UPDATE_CONSERVATIVE_REPT',
           g_row_count,
           'UPDATING Conservative Reportability Field IN C_PROD_AE_CAUSALITY',
           'SUCCESS',
           NULL,
           gvc_sql
          );
      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                 (g_etl_seq_value,
                  'C_AE_IDENTIFICATION_FU',
                  'P_UPDATE_SUSP_RELATEDNESS',
                  NULL,
                  'UPDATING SUSPECT RELATEDNESS Field IN C_PROD_AE_CAUSALITY',
                  'START',
                  NULL,
                  NULL
                 );
      gvc_sql :=
            'MERGE INTO c_ae_identification_fu cai USING ( SELECT
    cif.case_id,
    cif.tenant_id,
    cif.version_num,
    cif.ae_rec_num,
    MIN(least(
        CASE
          WHEN result_assessment_3_id = 5  THEN 5
            WHEN result_assessment_3_id = 3  THEN 3
            ELSE 6
        END,
        CASE
            WHEN result_assessment_1_id = 5  THEN 5
            WHEN result_assessment_1_id = 3  THEN 3
            ELSE 6
        END
    ) ) causality
                                              FROM
    pvr_case_revisions_temp pcr,'
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_ae_identification_fu'
               ELSE 's_ae_identification_fu'
            END
         || ' cif
    JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_prod_ae_causality'
               ELSE 's_prod_ae_causality'
            END
         || ' ci ON ( cif.case_id = ci.case_id
                                     AND cif.version_num = ci.version_num
                                     AND cif.tenant_id = ci.tenant_id
                                     AND cif.ae_rec_num = ci.ae_rec_num )
                                              WHERE
    pcr.case_id = cif.case_id
    AND   pcr.version_num = cif.version_num
    AND   pcr.enterprise_id = cif.tenant_id
    AND   pcr.processed = 0 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
                                              GROUP BY
    cif.case_id,
    cif.tenant_id,
    cif.version_num,
    cif.ae_rec_num
)
qry ON (
    cai.case_id = qry.case_id
    AND cai.tenant_id = qry.tenant_id
    AND cai.version_num = qry.version_num
    AND cai.ae_rec_num = qry.ae_rec_num
)
WHEN MATCHED THEN UPDATE SET flag_all_susp_relatedness = causality';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_SUSP_RELATEDNESS_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_SUSP_RELATEDNESS_JOB -> ERROR OCCURED IN P_SUSP_RELATEDNESS_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_SUSP_RELATEDNESS_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count :=
                   pkg_etl_mart_util.f_get_rowcount ('C_AE_IDENTIFICATION_FU');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
         (g_etl_seq_value,
          'C_AE_IDENTIFICATION_FU',
          'P_UPDATE_SUSP_RELATEDNESS',
          g_row_count,
          'UPDATING SUSPECT RELATEDNESS flag Field IN C_AE_IDENTIFICATION_FU',
          'SUCCESS',
          NULL,
          gvc_sql
         );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_CONS_REPT';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_generic_name
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE l_product_addl
            SET susp_generic_name = NULL,
                conc_generic_name = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                          (g_etl_seq_value,
                           'L_PRODUCT_ADDL',
                           'P_UPDATE_SUSPECT_GENERIC',
                           NULL,
                           'UPDATING SUSPECT GENERIC Field IN L_PRODUCT_ADDL',
                           'START',
                           NULL,
                           NULL
                          );
      gvc_sql :=
            'MERGE INTO l_product_addl lpa USING (
                        SELECT
                                    case_id,
                                    version_num,
                                    tenant_id,
                                    pkg_etl_util.f_collection_to_string
                      (CAST
                          (COLLECT (susp_product ORDER BY rank_id) AS udt_varchar2_tab
                          ),
                       '',''
                      ) susp_product
                                                                                                                                                FROM
                                    (
                                                SELECT
                                                            lpi.case_id,
                                                            lpi.version_num,
                                                            lpi.tenant_id,
                                                            lpi.rank_id,
                                                            CASE WHEN (lpi.FLAG_STUDY_DRUG=1 and lsa.blind_name_j is not null) then lsa.blind_name_j
                                                            else case when to_char(lpi.generic_name) is not null then to_char(lpi.generic_name) end
                                                            end susp_product
                                                FROM
                                                            pvr_case_revisions_temp pcr join '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'l_prod_identification'
               ELSE 't_prod_identification'
            END
         || ' lpi ON(pcr.case_id = lpi.case_id
                                                                                                            AND pcr.version_num = lpi.version_num
                                                                                                            AND pcr.enterprise_id = lpi.tenant_id)  join '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'l_study_addl'
               ELSE 't_study_addl'
            END
         || ' lsa ON(lpi.case_id=lsa.case_id and lpi.tenant_id=lsa.tenant_id and lpi.version_num=lsa.version_num)
                                                            where  pcr.processed = 0 AND lpi.drug_role_id = 1  '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
                                    )
                        GROUP BY
                                    case_id,
                                    version_num,
                                    tenant_id

                        )
                        qry ON (
                                    lpa.case_id = qry.case_id
                                    AND lpa.version_num = qry.version_num
                                    AND lpa.tenant_id = qry.tenant_id
                        )
                        WHEN MATCHED THEN UPDATE SET susp_generic_name = qry.susp_product';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_SUSP_GENERIC_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_SUSP_GENERIC_JOB -> ERROR OCCURED IN P_SUSP_GENERIC_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_SUSP_GENERIC_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('L_PRODUCT_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                          (g_etl_seq_value,
                           'L_PRODUCT_ADDL',
                           'P_UPDATE_SUSPECT_GENERIC',
                           g_row_count,
                           'UPDATING SUSPECT GENERIC Field IN L_PRODUCT_ADDL',
                           'SUCCESS',
                           NULL,
                           gvc_sql
                          );
      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                          (g_etl_seq_value,
                           'L_PRODUCT_ADDL',
                           'P_UPDATE_CONCOMITANT_GENERIC',
                           NULL,
                           'UPDATING SUSPECT GENERIC Field IN L_PRODUCT_ADDL',
                           'START',
                           NULL,
                           NULL
                          );
      gvc_sql :=
            'MERGE INTO l_product_addl lpa USING (
                        SELECT
                                    case_id,
                                    version_num,
                                    tenant_id,
                                    pkg_etl_util.f_collection_to_string
                      (CAST
                          (COLLECT (conc_product ORDER BY rank_id) AS udt_varchar2_tab
                          ),
                       '',''
                      ) conc_product
                                                                                                                                                FROM
                                    (
                                                SELECT
                                                           lpi.case_id,
                                                            lpi.version_num,
                                                            lpi.tenant_id,
                                                            lpi.rank_id,
                                                            CASE WHEN (lpi.FLAG_STUDY_DRUG=1 and lsa.blind_name_j is not null) then lsa.blind_name_j
                                                            else case when to_char(lpi.generic_name) is not null then to_char(lpi.generic_name) end
                                                            end conc_product
                                                FROM
                                                            pvr_case_revisions_temp pcr join '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'l_prod_identification'
               ELSE 't_prod_identification'
            END
         || ' lpi ON(pcr.case_id = lpi.case_id
                                                                                                            AND pcr.version_num = lpi.version_num
                                                                                                            AND pcr.enterprise_id = lpi.tenant_id) join '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'l_study_addl'
               ELSE 't_study_addl'
            END
         || ' lsa ON(lpi.case_id=lsa.case_id and lpi.tenant_id=lsa.tenant_id and lpi.version_num=lsa.version_num)
                                                            where  pcr.processed = 0 AND lpi.drug_role_id = 2 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
                                    )
                        GROUP BY
                                    case_id,
                                    version_num,
                                    tenant_id
                        )
                        qry ON (
                                    lpa.case_id = qry.case_id
                                    AND lpa.version_num = qry.version_num
                                    AND lpa.tenant_id = qry.tenant_id
                        )
                        WHEN MATCHED THEN UPDATE SET conc_generic_name = qry.conc_product';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_CONC_GENERIC_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_CONC_GENERIC_JOB -> ERROR OCCURED IN P_CONC_GENERIC_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_CONC_GENERIC_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('L_PRODUCT_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                      (g_etl_seq_value,
                       'L_PRODUCT_ADDL',
                       'P_UPDATE_CONCOMITANT_GENERIC',
                       g_row_count,
                       'UPDATING CONCOMITANT GENERIC Field IN L_PRODUCT_ADDL',
                       'SUCCESS',
                       NULL,
                       gvc_sql
                      );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_GENERIC_NAME';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_pt_code
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE l_master_addl
            SET pat_other_trtmnt_hist_pt_code = NULL,
                pat_comorbidity = NULL,
                pat_comp_pt_code = NULL,
                pat_anon_pt_code = NULL,
                pat_past_disease = NULL,
                pat_other_trtmnt_hist = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                                   (g_etl_seq_value,
                                    'L_MASTER_ADDL',
                                    'P_UPDATE_PT_CODE',
                                    NULL,
                                    'UPDATING PT CODE Field IN L_MASTER_ADDL',
                                    'START',
                                    NULL,
                                    NULL
                                   );
      gvc_sql :=
            'MERGE INTO l_master_addl outer_con
        USING (
WITH pt_code AS (
    SELECT
        cph.case_id case_id,
        cph.tenant_id tenant_id,
        cph.version_num version_num,
        cph.lang_id lang_id,
        cph.mc_type_id condition_type_id,
        cph.condition condition,
        cph.reported_mc item_reptd,
        cpr.mdr_mc_pt_code item_code,
        cph.rank_id rank_id,
        cph.mc_type_desc condition_type_desc
    FROM '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'l_patient_rel_med_condn'
               ELSE 't_patient_rel_med_condn'
            END
         || ' cph
                   JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_patient_rel_med_condn'
               ELSE 's_patient_rel_med_condn'
            END
         || ' cpr
                   ON (    cph.tenant_id = cpr.tenant_id
                       AND cph.case_id = cpr.case_id
                       AND cph.version_num = cpr.version_num
                       AND cph.mc_rec_num = cpr.mc_rec_num
                      )
    UNION ALL
    SELECT
        cph.case_id case_id,
        cph.tenant_id tenant_id,
        cph.version_num version_num,
        cph.lang_id lang_id,
        cph.hd_condn_type_id condition_type_id,
        cph.coded_drug_name condition,
        cph.rptd_drug_name item_reptd,
        cpr.mdr_cprph_pt_code item_code,
        cph.rank_id rank_id,
        cph.hd_condn_type_desc condition_type_desc
    FROM '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'l_patient_rel_prod_history'
               ELSE 't_patient_rel_prod_history'
            END
         || ' cph
                   JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_patient_rel_prod_history'
               ELSE 's_patient_rel_prod_history'
            END
         || ' cpr
                   ON (    cph.tenant_id = cpr.tenant_id
                       AND cph.case_id = cpr.case_id
                       AND cph.version_num = cpr.version_num
                       AND cph.cprph_rec_num = cpr.cprph_rec_num
                      )
) SELECT
    cph.case_id, cph.tenant_id, cph.version_num, cph.lang_id,
                   pkg_etl_util.f_collection_to_string
                      (CAST
                          (COLLECT
                              (CASE
                                  WHEN cph.condition_type_id = 4
                                     THEN CASE
                                            WHEN cph.condition IS NULL
                                            AND cph.item_reptd IS NOT NULL
                                               THEN ''99999999''
                                            ELSE NVL (cph.item_code,
                                                      ''99999999''
                                                     )
                                         END
                                  ELSE NULL
                               END ORDER BY cph.rank_id
                              ) AS udt_varchar2_tab
                          ),
                       '','') comp_pt_code,
                   pkg_etl_util.f_collection_to_string
                      (CAST
                          (COLLECT
                              (CASE
                                  WHEN cph.condition_type_id = 4
                                     THEN CASE
                                            WHEN cph.condition IS NULL
                                            AND cph.item_reptd IS NOT NULL
                                               THEN (   ''[''
                                                     || cph.item_reptd
                                                     || '']''
                                                    )
                                            ELSE NVL (cph.condition,
                                                      ''XXXXXXXX''
                                                     )
                                         END
                                  ELSE NULL
                               END ORDER BY cph.rank_id
                              ) AS udt_varchar2_tab
                          ),
                       '','') reported,
                   pkg_etl_util.f_collection_to_string
                      (CAST
                          (COLLECT
                              (CASE
                                  WHEN cph.condition_type_id = 1
                                     THEN CASE
                                            WHEN cph.condition IS NULL
                                            AND cph.item_reptd IS NOT NULL
                                               THEN ''99999999''
                                            ELSE NVL (cph.item_code,
                                                      ''99999999''
                                                     )
                                         END
                                  ELSE NULL
                               END ORDER BY cph.rank_id
                              ) AS udt_varchar2_tab
                          ),
                       '','') anon_pt_code,
                   pkg_etl_util.f_collection_to_string
                      (CAST
                          (COLLECT
                              (CASE
                                  WHEN cph.condition_type_id = 1
                                     THEN CASE
                                            WHEN cph.condition IS NULL
                                           AND cph.item_reptd IS NOT NULL
                                               THEN (   ''[''
                                                    || cph.item_reptd
                                                     || '']''
                                                    )
                                            ELSE NVL (cph.condition,
                                                      ''XXXXXXXX''
                                                     )
                                         END
                                  ELSE NULL
                               END ORDER BY cph.rank_id
                              ) AS udt_varchar2_tab
                          ),
                       '','') past_disease,
                   pkg_etl_util.f_collection_to_string
                      (CAST
                          (COLLECT
                              (CASE
                                  WHEN cph.condition_type_id IS NULL
                                   OR cph.condition_type_id NOT IN (1, 4)
                                     THEN CASE
                                            WHEN cph.condition IS NULL
                                            AND cph.item_reptd IS NOT NULL
                                               THEN ''99999999''
                                            ELSE NVL (cph.item_code,
                                                      ''99999999''
                                                     )
                                         END
                                  ELSE NULL
                               END ORDER BY cph.rank_id
                              ) AS udt_varchar2_tab
                          ),
                       '','') hist_pt_code,
                   pkg_etl_util.f_collection_to_string
                      (CAST
                          (COLLECT
                              (CASE
                                  WHEN cph.condition_type_id IS NULL
                                   OR cph.condition_type_id NOT IN (1, 4)
                                     THEN CASE
                                            WHEN cph.condition IS NULL
                                            AND cph.item_reptd IS NOT NULL
                                               THEN CASE
                                                      WHEN cph.condition_type_desc IS NOT NULL
                                                         THEN (   cph.condition_type_desc
                                                               || '';''
                                                               || ''[''
                                                               || cph.item_reptd
                                                               || '']''
                                                              )
                                                      ELSE (   ''[''
                                                            || cph.item_reptd
                                                            || '']''
                                                           )
                                                   END
                                            ELSE CASE
                                            WHEN cph.condition_type_desc IS NOT NULL
                                               THEN (   cph.condition_type_desc
                                                     || '';''
                                                     || cph.condition
                                                    )
                                            ELSE NVL (cph.condition,
                                                      ''XXXXXXXX''
                                                     )
                                         END
                                         END
                                  ELSE NULL
                               END ORDER BY cph.rank_id
                              ) AS udt_varchar2_tab
                          ),
                       '','') other_trtmnt
                       FROM
    pvr_case_revisions_temp pcr JOIN pt_code cph
    ON (    pcr.case_id = cph.case_id
                       AND pcr.version_num = cph.version_num
                       AND pcr.enterprise_id = cph.tenant_id
                      )'
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
    GROUP BY cph.tenant_id, cph.version_num, cph.case_id, cph.lang_id
    )qry
   ON (    outer_con.tenant_id = qry.tenant_id
       AND outer_con.case_id = qry.case_id
       AND outer_con.version_num = qry.version_num
       AND outer_con.lang_id = qry.lang_id)
   WHEN MATCHED THEN
      UPDATE
         SET pat_other_trtmnt_hist_pt_code = qry.hist_pt_code,
             pat_comorbidity = qry.reported,
             pat_comp_pt_code = qry.comp_pt_code,
             pat_anon_pt_code = qry.anon_pt_code,
             pat_past_disease = qry.past_disease,
             pat_other_trtmnt_hist = qry.other_trtmnt';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_PT_CODE_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_PT_CODE_JOB -> ERROR OCCURED IN P_PT_CODE_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001, 'ERROR OCCURED IN P_PT_CODE_JOB');
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('L_MASTER_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                                   (g_etl_seq_value,
                                    'L_MASTER_ADDL',
                                    'P_UPDATE_PT_CODE',
                                    g_row_count,
                                    'UPDATING PT CODE Field IN L_MASTER_ADDL',
                                    'SUCCESS',
                                    NULL,
                                    gvc_sql
                                   );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_PT_CODE';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_prim_correspondent
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE c_reporters_addl
            SET prim_correspond_source = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                  (g_etl_seq_value,
                   'C_REPORTERS_ADDL',
                   'P_UPDATE_PRIMARY_CORRESPOND',
                   NULL,
                   'UPDATING PRIMARY CORRESPONDANT Field IN C_REPORTERS_ADDL',
                   'START',
                   NULL,
                   NULL
                  );
      gvc_sql :=
            'MERGE INTO c_reporters_addl outer_cr
        USING (SELECT   case_id, tenant_id, version_num, src_rec_num,
                   CASE
                      WHEN rn = 1
                         THEN 1
                      ELSE 0
                   END cstm_col
              FROM (SELECT csf.case_id, csf.tenant_id, csf.version_num,
                           csf.src_rec_num,
                           ROW_NUMBER () OVER (PARTITION BY csf.case_id, csf.tenant_id, csf.version_num ORDER BY cs.rank_id)
                                                                           rn
                      FROM pvr_case_revisions_temp pcr JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_source'
               ELSE 's_source'
            END
         || ' cs
                           ON (    pcr.case_id = cs.case_id
                               AND pcr.version_num = cs.version_num
                               AND pcr.enterprise_id = cs.tenant_id
                              )
                           JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_source_fu'
               ELSE 's_source_fu'
            END
         || ' csf
                           ON (    cs.tenant_id = csf.tenant_id
                               AND cs.case_id = csf.case_id
                               AND cs.version_num = csf.version_num
                               AND cs.src_rec_num = csf.src_rec_num
                              )
                     WHERE csf.flag_corr_contact = 1 AND pcr.processed = 0 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || ')
                                                            ) qry
   ON (    outer_cr.case_id = qry.case_id
       AND outer_cr.tenant_id = qry.tenant_id
       AND outer_cr.src_rec_num = qry.src_rec_num
       AND outer_cr.version_num = qry.version_num)
   WHEN MATCHED THEN
      UPDATE
         SET prim_correspond_source = qry.cstm_col';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                 ('PVR_CASE_REVISIONS_TEMP',
                                                  'P_PRIMARY_CORRESPOND_JOB',
                                                  100000,
                                                  gvc_sql,
                                                  3
                                                 );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_PRIMARY_CORRESPOND_JOB -> ERROR OCCURED IN P_PRIMARY_CORRESPOND_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error
                                  (-20001,
                                   'ERROR OCCURED IN P_PRIMARY_CORRESPOND_JOB'
                                  );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_REPORTERS_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                  (g_etl_seq_value,
                   'C_REPORTERS_ADDL',
                   'P_UPDATE_PRIMARY_CORRESPOND',
                   g_row_count,
                   'UPDATING PRIMARY CORRESPONDANT Field IN C_REPORTERS_ADDL',
                   'SUCCESS',
                   NULL,
                   gvc_sql
                  );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_PRIM_CORRESPONDENT';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_action_item_code
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE l_master_addl
            SET task_desc = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                               (g_etl_seq_value,
                                'L_MASTER_ADDL',
                                'P_UPDATE_ACTION_ITEM',
                                NULL,
                                'UPDATING ACTION ITEM Field IN L_MASTER_ADDL',
                                'START',
                                NULL,
                                NULL
                               );
      gvc_sql :=
            'MERGE INTO l_master_addl outer_con
        USING (SELECT   ca.case_id, ca.tenant_id, ca.version_num, ca.lang_id,
                   pkg_etl_util.f_collection_to_string
                      (CAST
                          (COLLECT
                              (   CASE
                                     WHEN ca.task_comments LIKE ''%,%''
                                        THEN SUBSTR (ca.task_comments,
                                                     1,
                                                       INSTR
                                                            (ca.task_comments,
                                                             '','',
                                                             1,
                                                             1
                                                            )
                                                     - 1
                                                    )
                                     ELSE ca.task_comments
                                  END
                               || CASE
                                     WHEN ca.task_comments IS NOT NULL AND  ca.task_code_desc IS NOT NULL
                                        THEN '' - ''
                                  END
                               || ca.task_code_desc
                              ) AS udt_varchar2_tab
                          ),
                       '',''
                      ) task
              FROM pvr_case_revisions_temp pcr JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'l_tasks_fu'
               ELSE 't_tasks_fu'
            END
         || ' ca
                   ON (    pcr.case_id = ca.case_id
                       AND pcr.version_num = ca.version_num
                       AND pcr.enterprise_id = ca.tenant_id
                      )
             WHERE ca.date_completion IS NULL
               AND ca.task_code_id IN
                      (23001924, 23001925, 23001926, 23001928, 23001929,
                       23001931, 23001998, 23001999, 23002005, 23002006,
                       23002009)
               AND pcr.processed = 0 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
          GROUP BY ca.case_id, ca.tenant_id, ca.version_num, ca.lang_id) qry
   ON (    outer_con.tenant_id = qry.tenant_id
       AND outer_con.case_id = qry.case_id
       AND outer_con.version_num = qry.version_num
       AND outer_con.lang_id = qry.lang_id)
   WHEN MATCHED THEN
      UPDATE
         SET task_desc = qry.task';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_ACTION_ITEM_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_ACTION_ITEM_JOB -> ERROR OCCURED IN P_ACTION_ITEM_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_ACTION_ITEM_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('L_MASTER_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                               (g_etl_seq_value,
                                'L_MASTER_ADDL',
                                'P_UPDATE_ACTION_ITEM',
                                g_row_count,
                                'UPDATING ACTION ITEM Field IN L_MASTER_ADDL',
                                'SUCCESS',
                                NULL,
                                gvc_sql
                               );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_ACTION_ITEM_CODE';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_partner_name
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE l_master_addl
            SET partner_name = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                              (g_etl_seq_value,
                               'L_MASTER_ADDL',
                               'P_UPDATE_PARTNER_NAME',
                               NULL,
                               'UPDATING PARTNER NAME Field IN L_MASTER_ADDL',
                               'START',
                               NULL,
                               NULL
                              );
      gvc_sql :=
            'MERGE INTO l_master_addl outer_con
        USING (SELECT   ls.case_id, ls.version_num, ls.tenant_id, ls.lang_id,
                   pkg_etl_util.f_collection_to_string
                      (CAST
                          (COLLECT (ls.last_name ORDER BY ls.src_rec_num) AS udt_varchar2_tab
                          ),
                       '',''
                      ) partner
              FROM pvr_case_revisions_temp pcr JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'l_source'
               ELSE 't_source'
            END
         || ' ls
                                           ON (    pcr.case_id = ls.case_id
                       AND pcr.version_num = ls.version_num
                       AND pcr.enterprise_id = ls.tenant_id
                      )
             WHERE ls.qualification_desc IN (SELECT REPORTER_TYPE FROM VW_LRET_REPORTER_TYPE_J WHERE RPTR_TYPE_ID = 23000202) AND pcr.processed = 0 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
          GROUP BY ls.case_id, ls.version_num, ls.tenant_id, ls.lang_id) qry
   ON (    outer_con.tenant_id = qry.tenant_id
       AND outer_con.case_id = qry.case_id
       AND outer_con.version_num = qry.version_num
       AND outer_con.lang_id = qry.lang_id)
   WHEN MATCHED THEN
      UPDATE
         SET partner_name = qry.partner';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_PARTNER_NAME_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_PARTNER_NAME_JOB -> ERROR OCCURED IN P_PARTNER_NAME_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_PARTNER_NAME_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('L_MASTER_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                              (g_etl_seq_value,
                               'L_MASTER_ADDL',
                               'P_UPDATE_PARTNER_NAME',
                               g_row_count,
                               'UPDATING PARTNER NAME Field IN L_MASTER_ADDL',
                               'SUCCESS',
                               NULL,
                               gvc_sql
                              );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_PARTNER_NAME';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_deleted_deactivated
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE c_master_addl
            SET deleted_deactivated = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                         (g_etl_seq_value,
                          'C_MASTER_ADDL',
                          'P_UPDATE_DELETE_DEACTIVATE',
                          NULL,
                          'UPDATING DELETE DEACTIVATE Field IN C_MASTER_ADDL',
                          'START',
                          NULL,
                          NULL
                         );
      gvc_sql :=
            'MERGE INTO c_master_addl outer_con
        USING (SELECT csm.case_id, csm.version_num, csm.tenant_id,
                 CASE
                    WHEN csm.workflow_state_id = 1
                       THEN ''DELETED''
                    WHEN EXISTS (
                           SELECT *
                             FROM '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_characteristics_fu'
               ELSE 's_characteristics_fu'
            END
         || ' ccc
                            WHERE csm.case_id = ccc.case_id
                              AND csm.tenant_id = ccc.tenant_id
                              AND csm.version_num = ccc.version_num
                              AND ccc.characteristic_id IN
                                               (23000101, 23000401, 23000807))
                       THEN ''DEACTIVATED''
                    ELSE NULL
                 END deleted_deactivated
            FROM pvr_case_revisions_temp pcr JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_identification_fu'
               ELSE 's_identification_fu'
            END
         || ' csm
                                         ON (    pcr.case_id = csm.case_id
                       AND pcr.version_num = csm.version_num
                       AND pcr.enterprise_id = csm.tenant_id
                      ) WHERE processed = 0 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || ') qry
   ON (    outer_con.tenant_id = qry.tenant_id
       AND outer_con.case_id = qry.case_id
       AND outer_con.version_num = qry.version_num)
   WHEN MATCHED THEN
      UPDATE
         SET deleted_deactivated = qry.deleted_deactivated';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                 ('PVR_CASE_REVISIONS_TEMP',
                                                  'P_DELETED_DEACTIVATE_JOB',
                                                  100000,
                                                  gvc_sql,
                                                  3
                                                 );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_DELETED_DEACTIVATE_JOB -> ERROR OCCURED IN P_DELETED_DEACTIVATE_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error
                                  (-20001,
                                   'ERROR OCCURED IN P_DELETED_DEACTIVATE_JOB'
                                  );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_MASTER_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                         (g_etl_seq_value,
                          'C_MASTER_ADDL',
                          'P_UPDATE_DELETE_DEACTIVATE',
                          g_row_count,
                          'UPDATING DELETE DEACTIVATE Field IN C_MASTER_ADDL',
                          'SUCCESS',
                          NULL,
                          gvc_sql
                         );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_DELETED_DEACTIVATED';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_lock_date_time
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE c_master_addl
            SET lock_date_global = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);

         UPDATE l_master_addl
            SET lock_date_local = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                           (g_etl_seq_value,
                            'C_MASTER_ADDL',
                            'P_UPDATE_GLOBAL_LOCK',
                            NULL,
                            'UPDATING GLOAL LOCK DATE Field IN C_MASTER_ADDL',
                            'START',
                            NULL,
                            NULL
                           );
      gvc_sql :=
            'MERGE INTO c_master_addl outer_con
        USING (SELECT   case_id, tenant_id, version_num,
                   MAX (date_workflow_updt) lock_date
              FROM (SELECT cwf.case_id, cwf.tenant_id, cwf.version_num,
                           cwf.date_workflow_updt
                      FROM pvr_case_revisions_temp pcr JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_workflow_fu'
               ELSE 's_workflow_fu'
            END
         || ' cwf
                           ON (    pcr.case_id = cwf.case_id
                               AND pcr.version_num = cwf.version_num
                               AND pcr.enterprise_id = cwf.tenant_id
                              )
                           JOIN vw_username usr
                           ON (cwf.user_id = usr.user_id)
                     WHERE pcr.processed = 0
                       AND usr.site_id <> 23000805
                       AND (cwf.workflow_updt_comments LIKE ''Case Locked%'' OR cwf.workflow_updt_comments LIKE ''Case Locally Locked%'' OR cwf.workflow_updt_comments LIKE ''Case Globally and Locally Locked%'' OR cwf.workflow_updt_comments LIKE ''%Case Locked with significant follow%'') '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || ')
          GROUP BY case_id, tenant_id, version_num) qry
   ON (    outer_con.tenant_id = qry.tenant_id
       AND outer_con.case_id = qry.case_id
       AND outer_con.version_num = qry.version_num)
   WHEN MATCHED THEN
      UPDATE
         SET lock_date_global = qry.lock_date';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_GLOBAL_LOCK_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_GLOBAL_LOCK_JOB -> ERROR OCCURED IN P_GLOBAL_LOCK_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_GLOBAL_LOCK_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_MASTER_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                          (g_etl_seq_value,
                           'C_MASTER_ADDL',
                           'P_UPDATE_GLOBAL_LOCK',
                           g_row_count,
                           'UPDATING GLOBAL LOCK DATE Field IN C_MASTER_ADDL',
                           'SUCCESS',
                           NULL,
                           gvc_sql
                          );
      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                           (g_etl_seq_value,
                            'L_MASTER_ADDL',
                            'P_UPDATE_GLOBAL_LOCK',
                            NULL,
                            'UPDATING GLOAL LOCK DATE Field IN L_MASTER_ADDL',
                            'START',
                            NULL,
                            NULL
                           );
      gvc_sql :=
            'MERGE INTO l_master_addl outer_con
        USING (SELECT   case_id, tenant_id, version_num,
                   MAX (date_workflow_updt) lock_date
              FROM (SELECT cwf.case_id, cwf.tenant_id, cwf.version_num,
                           usr.user_id, cwf.user_id, usr.site_id,
                           cwf.workflow_updt_comments, cwf.date_workflow_updt
                      FROM pvr_case_revisions_temp pcr JOIN '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_workflow_fu'
               ELSE 's_workflow_fu'
            END
         || ' cwf
                           ON (    pcr.case_id = cwf.case_id
                               AND pcr.version_num = cwf.version_num
                               AND pcr.enterprise_id = cwf.tenant_id
                              )
                           JOIN vw_username usr
                           ON (cwf.user_id = usr.user_id)
                     WHERE pcr.processed = 0
                       AND usr.site_id = 23000805
                       AND (cwf.workflow_updt_comments LIKE ''Case Locked%'' OR cwf.workflow_updt_comments LIKE ''Case Locally Locked%'' OR cwf.workflow_updt_comments LIKE ''Case Globally and Locally Locked%'' OR cwf.workflow_updt_comments LIKE ''%Case Locked with significant follow%'') '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || ')
          GROUP BY case_id, tenant_id, version_num) qry
   ON (    outer_con.tenant_id = qry.tenant_id
       AND outer_con.case_id = qry.case_id
       AND outer_con.version_num = qry.version_num)
   WHEN MATCHED THEN
      UPDATE
         SET lock_date_local = qry.lock_date';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_JAPAN_LOCK_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_JAPAN_LOCK_JOB -> ERROR OCCURED IN P_JAPAN_LOCK_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_JAPAN_LOCK_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('L_MASTER_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                           (g_etl_seq_value,
                            'L_MASTER_ADDL',
                            'P_UPDATE_JAPAN_LOCK',
                            g_row_count,
                            'UPDATING JAPAN LOCK DATE Field IN L_MASTER_ADDL',
                            'SUCCESS',
                            NULL,
                            gvc_sql
                           );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_LOCK_DATE_TIME';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_latest_not_submitted
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE rpt_reg_reports_addl
            SET flag_pmda = NULL
          WHERE (tenant_id, processed_report_id) IN (
                                         SELECT tenant_id,
                                                processed_report_id
                                           FROM pvr_report_revisions_temp
                                          WHERE per_report_flag = 1);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                          (g_etl_seq_value,
                           'RPT_REG_REPORTS_ADDL',
                           'P_UPDATE_PMDA_FLAG',
                           NULL,
                           'UPDATING PMDA FLAG Field IN RPT_REG_REPORTS_ADDL',
                           'START',
                           NULL,
                           NULL
                          );
      gvc_sql :=
         'MERGE INTO rpt_reg_reports_addl rrra
        USING (SELECT case_id, tenant_id, flag_db_source, followup,
                 processed_report_id, report_form_type, date_aware,
                 aware_method, max_aware,
                 CASE
                    WHEN aware_method <= max_aware
                       THEN 0
                    ELSE 1
                 END custom_flag, date_schedule, date_submission
            FROM (SELECT   rra.case_id, rra.tenant_id, rra.flag_db_source,
                           cs.followup# followup, rra.processed_report_id,
                           rra.report_form_type, csf.date_aware,
                           rra.aware_method,
                           CASE
                              WHEN cs.date_submission IS NOT NULL
                                 THEN rra.aware_method
                              ELSE 0
                           END id1,
                           MAX
                              (CASE
                                  WHEN cs.date_submission IS NOT NULL
                                     THEN rra.aware_method
                                  ELSE 0
                               END
                              ) OVER (PARTITION BY rra.case_id ORDER BY NULL)
                                                                    max_aware,
                           csf.date_schedule, cs.date_submission
                      FROM pvr_report_revisions_temp prr JOIN c_submissions cs
                           ON (    prr.tenant_id = cs.tenant_id
                               AND prr.processed_report_id =
                                                        cs.processed_report_id
                               AND cs.flag_db_source = 0
                              )
                           JOIN c_submissions_fu csf
                           ON (    cs.tenant_id = csf.tenant_id
                               AND cs.flag_db_source = csf.flag_db_source
                               AND cs.processed_report_id =
                                                       csf.processed_report_id
                               AND cs.rec_type = csf.rec_type
                              )
                           JOIN rpt_reg_reports_addl rra
                           ON (    cs.tenant_id = rra.tenant_id
                               AND cs.flag_db_source = rra.flag_db_source
                               AND cs.processed_report_id =
                                                       rra.processed_report_id
                              )
                     WHERE report_form_type IN (1, 2) AND country_id = 107
                  ORDER BY csf.case_id,
                           rra.aware_method,
                           csf.date_schedule,
                           cs.date_submission)) qry
   ON (    rrra.flag_db_source = qry.flag_db_source
       AND rrra.tenant_id = qry.tenant_id
       AND rrra.processed_report_id = qry.processed_report_id)
   WHEN MATCHED THEN
      UPDATE
         SET flag_pmda = qry.custom_flag';

      IF ln_execute_status = 0
      THEN
         l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
         pkg_etl_util.p_insert_stg_excp
            (l_etl_seq_value,
             NULL,
             'ERROR OCCURED IN P_PMDA_FLAG_JOB -> ERROR OCCURED IN P_PMDA_FLAG_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
             SQLCODE,
             TO_CHAR (SQLERRM || '->' || DBMS_UTILITY.format_error_backtrace)
            );
         ROLLBACK;
         raise_application_error (-20001, 'ERROR OCCURED IN P_PMDA_FLAG_JOB');
      END IF;

      EXECUTE IMMEDIATE gvc_sql;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('RPT_REG_REPORTS_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                          (g_etl_seq_value,
                           'RPT_REG_REPORTS_ADDL',
                           'P_UPDATE_PMDA_FLAG',
                           g_row_count,
                           'UPDATING PMDA FLAG Field IN RPT_REG_REPORTS_ADDL',
                           'SUCCESS',
                           NULL,
                           gvc_sql
                          );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_LATEST_NOT_SUBMITTED';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_pmda_submission_date
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE c_master_addl
            SET pmda_submissions = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                          (g_etl_seq_value,
                           'C_MASTER_ADDL',
                           'P_UPDATE_PMDA_SUBMISSIONS',
                           NULL,
                           'UPDATING PMDA SUBMISSIONS Field IN C_MASTER_ADDL',
                           'START',
                           NULL,
                           NULL
                          );
      gvc_sql :=
            'MERGE INTO c_master_addl outer_con
        USING (SELECT   vcs.case_id, vcs.tenant_id, vcs.version_num,
                   pkg_etl_util.f_collection_to_string
                      (CAST
                          (COLLECT
                                  (to_char(vcs.date_submission,''YYYY/MM/DD'') ORDER BY vcs.processed_report_id
                                  ) AS udt_varchar2_tab
                          ),
                       '','') submissions
              FROM pvr_case_revisions_temp pcr JOIN v_c_submissions_all vcs
                                      ON (    pcr.case_id = vcs.case_id
                               AND pcr.version_num = vcs.version_num
                               AND pcr.enterprise_id = vcs.tenant_id
                              )
             WHERE pcr.processed = 0 AND vcs.destination_id IN
                      (5002302, 23074006, 23080176, 23080305, 23080364, 
                       23080365, 23080367, 1000000055, 1000000056, 1000000057) '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
          GROUP BY vcs.case_id, vcs.tenant_id, vcs.version_num) qry
   ON (    outer_con.tenant_id = qry.tenant_id
       AND outer_con.case_id = qry.case_id
       AND outer_con.version_num = qry.version_num)
   WHEN MATCHED THEN
      UPDATE
         SET pmda_submissions = qry.submissions';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_PMDA_SUBMISSIONS_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_PMDA_SUBMISSIONS_JOB -> ERROR OCCURED IN P_PMDA_SUBMISSIONS_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_PMDA_SUBMISSIONS_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_MASTER_ADDL');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                          (g_etl_seq_value,
                           'C_MASTER_ADDL',
                           'P_UPDATE_PMDA_SUBMISSIONS',
                           g_row_count,
                           'UPDATING PMDA SUBMISSIONS Field IN C_MASTER_ADDL',
                           'SUCCESS',
                           NULL,
                           gvc_sql
                          );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_PMDA_SUBMISSION_DATE';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_cons_rept_j
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE l_prod_ae_causality
            SET flag_relatedness_1 = NULL,
                flag_relatedness_3 = NULL,
                flag_conservative_relatedness = NULL
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
          (g_etl_seq_value,
           'L_PROD_AE_CAUSALITY',
           'P_UPDATE_PROD_CAUSALITY_J',
           NULL,
           'UPDATING Conservative Reportability Field IN L_PROD_AE_CAUSALITY',
           'START',
           NULL,
           NULL
          );
      gvc_sql :=
            'MERGE INTO l_prod_ae_causality ct USING ( WITH l_prod_ae_ca AS (
    SELECT
        cpa.case_id,
        cpa.tenant_id,
        cpa.version_num,
        cpa.prod_rec_num,
        cpa.ae_rec_num,
        DECODE(cpa.result_assessment_3_id,3,3,5,5,NULL,NULL,6) "RPT_CAUSALITY",
        DECODE(cpa.result_assessment_1_id,3,3,5,5,NULL,NULL,6) "DET_CAUSALITY"
    FROM
        pvr_case_revisions_temp pcr,
        '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'l_prod_ae_causality'
               ELSE 't_prod_ae_causality'
            END
         || ' cpa
    WHERE
        pcr.case_id = cpa.case_id
        AND   pcr.version_num = cpa.version_num
        AND   pcr.enterprise_id = cpa.tenant_id
        AND   pcr.processed = 0 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
),abc AS (
    SELECT
        case_id,
        tenant_id,
        version_num,
        prod_rec_num,
        ae_rec_num,
        CASE WHEN ((rpt_causality = 5 AND det_causality = 5) OR (rpt_causality IS NULL AND det_causality = 5) OR (rpt_causality = 5 AND det_causality IS NULL)
        OR (rpt_causality IS NULL AND det_causality IS NULL)) THEN 5 ELSE
        3 END derived_causality
    FROM
        l_prod_ae_ca
),susp_relatedness AS (
    SELECT
        case_id,
        tenant_id,
        version_num,
        prod_rec_num,
        ae_rec_num,
        DECODE(abc.derived_causality,3,3,5,5,3) cons_causality
    FROM
        abc
) SELECT
    a.case_id,
    a.version_num,
    a.tenant_id,
    a.prod_rec_num,
    a.ae_rec_num,
    a.rpt_causality,
    a.det_causality,
    b.cons_causality
  FROM
    l_prod_ae_ca a
    JOIN susp_relatedness b ON ( a.case_id = b.case_id
                                 AND a.version_num = b.version_num
                                 AND a.tenant_id = b.tenant_id
                                 AND a.prod_rec_num = b.prod_rec_num
                                 AND a.ae_rec_num = b.ae_rec_num )
    JOIN abc c ON ( a.case_id = c.case_id
                    AND a.version_num = c.version_num
                    AND a.tenant_id = c.tenant_id
                    AND a.prod_rec_num = c.prod_rec_num
                    AND a.ae_rec_num = c.ae_rec_num )
)
qry ON (
    ct.tenant_id = qry.tenant_id
    AND ct.case_id = qry.case_id
    AND ct.version_num = qry.version_num
    AND ct.prod_rec_num = qry.prod_rec_num
    AND ct.ae_rec_num = qry.ae_rec_num
)
WHEN MATCHED THEN UPDATE SET flag_relatedness_1 = qry.det_causality,
flag_relatedness_3 = qry.rpt_causality,
flag_conservative_relatedness = qry.cons_causality';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                ('PVR_CASE_REVISIONS_TEMP',
                                                 'P_CONSERVATIVE_REPT_J_JOB',
                                                 100000,
                                                 gvc_sql,
                                                 3
                                                );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_CONSERVATIVE_REPT_J_JOB -> ERROR OCCURED IN P_CONSERVATIVE_REPT_J_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error
                                 (-20001,
                                  'ERROR OCCURED IN P_CONSERVATIVE_REPT_J_JOB'
                                 );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('L_PROD_AE_CAUSALITY');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
          (g_etl_seq_value,
           'L_PROD_AE_CAUSALITY',
           'P_UPDATE_PROD_CAUSALITY_J',
           g_row_count,
           'UPDATING Conservative Reportability Field IN L_PROD_AE_CAUSALITY',
           'SUCCESS',
           NULL,
           gvc_sql
          );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_CONS_REPT_J';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_update_first_last_dose
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE c_drug_dosage_fu
            SET flag_first_dose = 0,
                flag_last_dose = 0
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);

         UPDATE l_drug_dosage_fu
            SET flag_first_dose = 0,
                flag_last_dose = 0
          WHERE (case_id, tenant_id, version_num) IN (
                                    SELECT case_id, enterprise_id,
                                           version_num
                                      FROM pvr_case_revisions_temp
                                     WHERE processed = 0);
      END IF;

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                        (g_etl_seq_value,
                         'C_DRUG_DOSAGE_FU',
                         'P_UPDATE_FIRST_DOSE',
                         NULL,
                         'UPDATING FIRST DOSE FLAG Field IN C_DRUG_DOSAGE_FU',
                         'START',
                         NULL,
                         NULL
                        );
      gvc_sql :=
            'MERGE INTO c_drug_dosage_fu cdf
         USING (SELECT   cdd.tenant_id, cdd.case_id, cdd.version_num, cdd.prod_rec_num,
                   MIN (rank_id) min_rank_id
              FROM pvr_case_revisions_temp pcr, '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_drug_dosage_fu'
               ELSE 's_drug_dosage_fu'
            END
         || ' cdd
             WHERE pcr.case_id = cdd.case_id
               AND pcr.version_num = cdd.version_num
               AND pcr.enterprise_id = cdd.tenant_id
               AND pcr.processed = 0 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
          GROUP BY cdd.tenant_id, cdd.case_id, cdd.version_num, cdd.prod_rec_num) qry
      ON (    cdf.tenant_id = qry.tenant_id
          AND cdf.case_id = qry.case_id
          AND cdf.version_num = qry.version_num
          AND cdf.prod_rec_num = qry.prod_rec_num
          AND cdf.rank_id = qry.min_rank_id)
      WHEN MATCHED THEN
         UPDATE
            SET cdf.flag_first_dose = 1';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_FIRST_DOSE_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_FIRST_DOSE_JOB -> ERROR OCCURED IN P_FIRST_DOSE_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_FIRST_DOSE_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_DRUG_DOSAGE_FU');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                        (g_etl_seq_value,
                         'C_DRUG_DOSAGE_FU',
                         'P_UPDATE_FIRST_DOSE',
                         g_row_count,
                         'UPDATING FIRST DOSE FLAG Field IN C_DRUG_DOSAGE_FU',
                         'SUCCESS',
                         NULL,
                         gvc_sql
                        );

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                        (g_etl_seq_value,
                         'C_DRUG_DOSAGE_FU',
                         'P_UPDATE_LAST_DOSE',
                         NULL,
                         'UPDATING LAST DOSE FLAG Field IN C_DRUG_DOSAGE_FU',
                         'START',
                         NULL,
                         NULL
                        );
      gvc_sql :=
            'MERGE INTO c_drug_dosage_fu cdf
         USING (SELECT   cdd.tenant_id, cdd.case_id, cdd.version_num, cdd.prod_rec_num,
                   MAX (rank_id) max_rank_id
              FROM pvr_case_revisions_temp pcr, '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'c_drug_dosage_fu'
               ELSE 's_drug_dosage_fu'
            END
         || ' cdd
             WHERE pcr.case_id = cdd.case_id
               AND pcr.version_num = cdd.version_num
               AND pcr.enterprise_id = cdd.tenant_id
               AND pcr.processed = 0 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
          GROUP BY cdd.tenant_id, cdd.case_id, cdd.version_num, cdd.prod_rec_num) qry
      ON (    cdf.tenant_id = qry.tenant_id
          AND cdf.case_id = qry.case_id
          AND cdf.version_num = qry.version_num
          AND cdf.prod_rec_num = qry.prod_rec_num
          AND cdf.rank_id = qry.max_rank_id)
      WHEN MATCHED THEN
         UPDATE
            SET cdf.flag_last_dose = 1';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_LAST_DOSE_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_LAST_DOSE_JOB -> ERROR OCCURED IN P_LAST_DOSE_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_LAST_DOSE_JOB'
                                    );
         END IF;
      ELSE
        EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('C_DRUG_DOSAGE_FU');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                        (g_etl_seq_value,
                         'C_DRUG_DOSAGE_FU',
                         'P_UPDATE_LAST_DOSE',
                         g_row_count,
                         'UPDATING LAST DOSE FLAG Field IN C_DRUG_DOSAGE_FU',
                         'SUCCESS',
                         NULL,
                         gvc_sql
                        );
      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                        (g_etl_seq_value,
                         'L_DRUG_DOSAGE_FU',
                         'P_UPDATE_FIRST_DOSE_J',
                         NULL,
                         'UPDATING FIRST DOSE FLAG Field IN L_DRUG_DOSAGE_FU',
                         'START',
                         NULL,
                         NULL
                        );
      gvc_sql :=
            'MERGE INTO l_drug_dosage_fu cdf
         USING (SELECT   cdd.tenant_id, cdd.case_id, cdd.version_num, cdd.prod_rec_num,
                   MIN (rank_id) min_rank_id
              FROM pvr_case_revisions_temp pcr, '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'l_drug_dosage_fu'
               ELSE 't_drug_dosage_fu'
            END
         || ' cdd
             WHERE pcr.case_id = cdd.case_id
               AND pcr.version_num = cdd.version_num
               AND pcr.enterprise_id = cdd.tenant_id
               AND pcr.processed = 0 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
          GROUP BY cdd.tenant_id, cdd.case_id, cdd.version_num, cdd.prod_rec_num) qry
      ON (    cdf.tenant_id = qry.tenant_id
          AND cdf.case_id = qry.case_id
          AND cdf.version_num = qry.version_num
          AND cdf.prod_rec_num = qry.prod_rec_num
          AND cdf.rank_id = qry.min_rank_id)
      WHEN MATCHED THEN
         UPDATE
            SET cdf.flag_first_dose = 1';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_FIRST_DOSE_J_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_FIRST_DOSE_J_JOB -> ERROR OCCURED IN P_FIRST_DOSE_J_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_FIRST_DOSE_J_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('L_DRUG_DOSAGE_FU');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                        (g_etl_seq_value,
                         'L_DRUG_DOSAGE_FU',
                         'P_UPDATE_FIRST_DOSE_J',
                         g_row_count,
                         'UPDATING FIRST DOSE FLAG Field IN L_DRUG_DOSAGE_FU',
                         'SUCCESS',
                         NULL,
                         gvc_sql
                        );

      g_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log
                        (g_etl_seq_value,
                         'L_DRUG_DOSAGE_FU',
                         'P_UPDATE_LAST_DOSE_J',
                         NULL,
                         'UPDATING LAST DOSE FLAG Field IN L_DRUG_DOSAGE_FU',
                         'START',
                         NULL,
                         NULL
                        );
      gvc_sql :=
            'MERGE INTO l_drug_dosage_fu cdf
         USING (SELECT   cdd.tenant_id, cdd.case_id, cdd.version_num, cdd.prod_rec_num,
                   MAX (rank_id) max_rank_id
              FROM pvr_case_revisions_temp pcr, '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN 'l_drug_dosage_fu'
               ELSE 't_drug_dosage_fu'
            END
         || ' cdd
             WHERE pcr.case_id = cdd.case_id
               AND pcr.version_num = cdd.version_num
               AND pcr.enterprise_id = cdd.tenant_id
               AND pcr.processed = 0 '
         || CASE
               WHEN g_etl_mode = 'INIT'
                  THEN ' and pcr.ROWID BETWEEN :start_id AND :end_id'
               ELSE ''
            END
         || '
          GROUP BY cdd.tenant_id, cdd.case_id, cdd.version_num, cdd.prod_rec_num) qry
      ON (    cdf.tenant_id = qry.tenant_id
          AND cdf.case_id = qry.case_id
          AND cdf.version_num = qry.version_num
          AND cdf.prod_rec_num = qry.prod_rec_num
          AND cdf.rank_id = qry.max_rank_id)
      WHEN MATCHED THEN
         UPDATE
            SET cdf.flag_last_dose = 1';

      IF g_etl_mode = 'INIT'
      THEN
         ln_execute_status :=
            pkg_etl_util.f_run_task_parallel_byrowid
                                                  ('PVR_CASE_REVISIONS_TEMP',
                                                   'P_LAST_DOSE_J_JOB',
                                                   100000,
                                                   gvc_sql,
                                                   3
                                                  );

         IF ln_execute_status = 0
         THEN
            l_etl_seq_value := pkg_etl_util.f_get_pvr_etl_seq_value;
            pkg_etl_util.p_insert_stg_excp
               (l_etl_seq_value,
                NULL,
                'ERROR OCCURED IN P_LAST_DOSE_J_JOB -> ERROR OCCURED IN P_LAST_DOSE_J_JOB->ERROR DUE TO PARALLEL CHUNKING - Please check table USER_PARALLEL_EXECUTE_TASKS and USER_PARALLEL_EXECUTE_CHUNKS for actual status',
                SQLCODE,
                TO_CHAR (SQLERRM || '->'
                         || DBMS_UTILITY.format_error_backtrace
                        )
               );
            ROLLBACK;
            raise_application_error (-20001,
                                     'ERROR OCCURED IN P_LAST_DOSE_J_JOB'
                                    );
         END IF;
      ELSE
         EXECUTE IMMEDIATE gvc_sql;
      END IF;

      g_row_count := pkg_etl_mart_util.f_get_rowcount ('L_DRUG_DOSAGE_FU');

      IF g_row_count IS NULL
      THEN
         g_row_count := 0;
      END IF;

      pkg_etl_util.p_insert_stg_log
                        (g_etl_seq_value,
                         'L_DRUG_DOSAGE_FU',
                         'P_UPDATE_LAST_DOSE_J',
                         g_row_count,
                         'UPDATING LAST DOSE FLAG Field IN L_DRUG_DOSAGE_FU',
                         'SUCCESS',
                         NULL,
                         gvc_sql
                        );

      UPDATE p_cstm_procedure_mapping
         SET status = 3
       WHERE procedure_name = 'P_UPDATE_FIRST_LAST_DOSE';

      IF g_etl_mode = 'INIT'
      THEN
         COMMIT;
      END IF;
   END;

   PROCEDURE p_main (pi_mode VARCHAR2)
   IS
   BEGIN
      IF g_etl_mode = 'INCR'
      THEN
         UPDATE p_cstm_procedure_mapping
            SET status = 0;
      END IF;

      FOR i IN (SELECT   *
                    FROM p_cstm_procedure_mapping
                   WHERE status <> 3
                ORDER BY proc_id)
      LOOP
         EXECUTE IMMEDIATE    'BEGIN pkg_post_case_transform.'
                           || i.procedure_name
                           || '; END;';
      END LOOP;
   END;
END;
/