CREATE OR REPLACE PROCEDURE p_update_e2b_tables
AS
   ln_cnt         NUMBER;
   lvc_etl_mode   VARCHAR2 ( 30 )
                     := pkg_etl_util.f_get_etl_constants_value ( 'ETL_TYPE' );

BEGIN
   IF lvc_etl_mode = 'INIT'
   THEN
      UPDATE pvr_etl_constants
         SET etl_value = 0
       WHERE etl_key = 'FLAG_ESM_TABLES_UPDATE';

      COMMIT;

      LOOP
         SELECT COUNT ( 1 )
           INTO ln_cnt
           FROM pvr_etl_master
          WHERE tgt_table_name IN
                       ( 'E2B_INFO', 'MESSAGES_ADDL', 'ACKNOWLEDGMENT_ADDL' )
            AND execution_status = 3;

         IF ln_cnt <> 3
         THEN
            DBMS_LOCK.sleep ( 900 );
         ELSE
            EXECUTE IMMEDIATE    'BEGIN PKG_ETL_POST_TRANSFORM_UPDATES.P_UPDATE_ESM_TABLES('''
                              || lvc_etl_mode
                              || ''');
                                              END;';

            UPDATE pvr_etl_constants
               SET etl_value = 1
             WHERE etl_key = 'FLAG_ESM_TABLES_UPDATE';

            COMMIT;
            EXIT;
         END IF;
      END LOOP;
   ELSE
      EXECUTE IMMEDIATE    'BEGIN PKG_ETL_POST_TRANSFORM_UPDATES.P_UPDATE_ESM_TABLES('''
                        || lvc_etl_mode
                        || ''');
                                              END;';
   END IF;
END;
/