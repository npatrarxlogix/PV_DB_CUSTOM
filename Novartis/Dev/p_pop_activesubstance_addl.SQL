create or replace PROCEDURE p_pop_activesubstance_addl
AS
   lvc_sql                VARCHAR2 ( 32000 ) := '';
   lvc_chunk_col          VARCHAR2 ( 100 )   := 'REPORT_ID';
   exe_sql                VARCHAR2 ( 32000 ) := '';
   ln_start_position      NUMBER;
   ln_max_position        NUMBER;
   ln_end_position        NUMBER;
   ln_dblink_chunk_size   NUMBER             := 50000;
   l_sql_1                VARCHAR2 ( 4000 )  := '';
   ln_etl_seq_value       NUMBER;
   ln_exec_status         NUMBER;
   lvc_final_sql          VARCHAR2 ( 32000 ) := '';
   ln_status              NUMBER;
   lvc_cons_sql           VARCHAR2(500);
   lvc_etl_mode           VARCHAR2 ( 30 )
                     := pkg_etl_util.f_get_etl_constants_value ( 'ETL_TYPE' );
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   SELECT etl_value
     INTO ln_start_position
     FROM pvr_etl_constants
    WHERE etl_key = 'ACT_SUB_CHUNK_SIZE_PROCESSED';

   SELECT execution_status
     INTO ln_exec_status
     FROM pvr_etl_master
    WHERE tgt_table_name = 'ACTIVESUBSTANCE_ADDL';

   IF ln_exec_status IN ( 0, 2 )
   THEN
      pkg_etl_util.p_set_etl_master_status ( 'ACTIVESUBSTANCE_ADDL',
                                             'E2B',
                                             'START'
                                           );
      ln_etl_seq_value    := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log ( ln_etl_seq_value,
                                      'ACTIVESUBSTANCE_ADDL',
                                      'P_POP_ACTIVESUBSTANCE_ADDL',
                                      NULL,
                                         'PRE STAGE TO MART POPULATION IN '
                                      || 'ACTIVESUBSTANCE_ADDL'
                                      || ' BY PROCESSING CHUNKS-SQL',
                                      'START',
                                      NULL,
                                      NULL
                                    );

      IF lvc_etl_mode = 'INIT' AND ln_start_position = 0
      THEN
         pkg_etl_mart_util.p_truncate_table ( 'ACTIVESUBSTANCE_ADDL' );
         lvc_cons_sql:= 'ALTER TABLE activesubstance_addl DROP CONSTRAINT pk_activesubstance_addl ';
          s_p_execute_script(lvc_cons_sql);
      END IF;
     lvc_cons_sql:='';
     
      IF lvc_etl_mode = 'INIT'
      THEN
         lvc_sql    :=
            'insert /*+ append parallel(3) */ into ACTIVESUBSTANCE_ADDL (REPORT_ID, DRUG_ID, ACTIVESUBSTANCENAME, ACTIVESUBSTANCE_ID, TENANT_ID, STRENGTH, STRENGTHUNIT, SPECIFIEDSUBSTANCETERMIDVER, SPECIFIEDSUBSTANCETERMID)
select REPORT_ID, DRUG_ID, ACTIVESUBSTANCENAME, ACTIVESUBSTANCE_ID, ENTERPRISE_ID, STRENGTH, STRENGTHUNIT, SPECIFIEDSUBSTANCETERMIDVER, SPECIFIEDSUBSTANCETERMID from activesubstance@pva_to_src';
      ELSE
         lvc_sql    :=
            'SELECT act.report_id, act.drug_id, act.activesubstancename, act.activesubstance_id,
       act.enterprise_id, act.strength, act.strengthunit, act.specifiedsubstancetermidver,
       act.specifiedsubstancetermid
  FROM activesubstance@pva_to_src act join v_safetyreport@pva_to_src saf on (act.report_id=saf.report_id)';
      END IF;

      SELECT NVL ( MAX ( report_id ), 0 )
        INTO ln_max_position
        FROM activesubstance@pva_to_src;

      IF ln_start_position = 0
      THEN
         SELECT NVL ( MIN ( report_id ), 0 )
           INTO ln_start_position
           FROM activesubstance@pva_to_src;
      END IF;

      SELECT MIN ( report_id )
        INTO ln_end_position
        FROM activesubstance@pva_to_src
       WHERE report_id > ln_start_position + ln_dblink_chunk_size;

      IF ln_end_position IS NULL
      THEN
         ln_end_position    := ln_max_position + 1;
      END IF;

      LOOP
         exe_sql              :=
               lvc_sql
            || '  where act.'
            || lvc_chunk_col
            || ' >=  :ln_start_position
                         and act.'
            || lvc_chunk_col
            || ' < :ln_end_position ';

         IF lvc_etl_mode = 'INIT'
         THEN
            lvc_final_sql    := exe_sql;

            EXECUTE IMMEDIATE exe_sql
                        USING ln_start_position, ln_end_position;
         ELSE

            EXECUTE IMMEDIATE 'truncate table act_subs_addl_temp';

            lvc_final_sql    :=
                  'INSERT /*+ APPEND */ INTO act_subs_addl_temp (REPORT_ID, DRUG_ID, ACTIVESUBSTANCENAME, ACTIVESUBSTANCE_ID, TENANT_ID, STRENGTH, STRENGTHUNIT, SPECIFIEDSUBSTANCETERMIDVER, SPECIFIEDSUBSTANCETERMID)'
               || exe_sql;

            EXECUTE IMMEDIATE lvc_final_sql  USING ln_start_position, ln_end_position;

            COMMIT;
			lvc_final_sql    := '';
            lvc_final_sql    :=
                  'MERGE /*+ parallel(3) */ INTO ACTIVESUBSTANCE_ADDL ct USING (  SELECT * FROM act_subs_addl_temp
) qry ON (
    ct.report_id = qry.report_id
AND
    ct.tenant_id = qry.tenant_id
AND
    ct.drug_id = qry.drug_id
AND
    ct.activesubstance_id = qry.activesubstance_id
) WHEN MATCHED THEN
UPDATE
SET activesubstancename = qry.activesubstancename,
strength = qry.strength,
strengthunit = qry.strengthunit,
specifiedsubstancetermidver = qry.specifiedsubstancetermidver,
specifiedsubstancetermid = qry.specifiedsubstancetermid
WHEN NOT MATCHED THEN INSERT ( REPORT_ID, DRUG_ID, ACTIVESUBSTANCENAME, ACTIVESUBSTANCE_ID, TENANT_ID, STRENGTH, STRENGTHUNIT, SPECIFIEDSUBSTANCETERMIDVER, SPECIFIEDSUBSTANCETERMID ) VALUES ( qry.report_id,qry.drug_id,qry.activesubstancename,qry.activesubstance_id,qry.tenant_id,qry.strength,qry.strengthunit,qry.specifiedsubstancetermidver,qry.specifiedsubstancetermid)';

            EXECUTE IMMEDIATE lvc_final_sql;
                        
         END IF;

         COMMIT;
         EXIT WHEN ln_end_position = ln_max_position + 1;
         ln_start_position    := ln_end_position;
         pkg_etl_util.p_set_etl_constants_value
                                             ( 'ACT_SUB_CHUNK_SIZE_PROCESSED',
                                               ln_start_position
                                             );
         l_sql_1              :=
               ' SELECT
                        MIN(report_id)
                    FROM
                       ACTIVESUBSTANCE@pva_to_src
                    WHERE report_id > :ln_start_position +'
            || ln_dblink_chunk_size;

         EXECUTE IMMEDIATE l_sql_1
                      INTO ln_end_position
                     USING ln_start_position;

         IF ln_end_position IS NULL
         THEN
            ln_end_position    := ln_max_position + 1;
         END IF;

         COMMIT;
      END LOOP;

      IF lvc_etl_mode = 'INIT'
      THEN
          lvc_cons_sql:= 'ALTER TABLE activesubstance_addl ADD CONSTRAINT pk_activesubstance_addl PRIMARY KEY ( report_id,drug_id,tenant_id,activesubstance_id )';
          s_p_execute_script(lvc_cons_sql);

         pkg_etl_mart_util.p_gather_statistics ( 'ACTIVESUBSTANCE_ADDL' );
      END IF;

      pkg_etl_util.p_insert_stg_log ( ln_etl_seq_value,
                                      'ACTIVESUBSTANCE_ADDL',
                                      'P_POP_ACTIVESUBSTANCE_ADDL',
                                      SQL%ROWCOUNT,
                                         'PRE STAGE TO MART POPULATION IN '
                                      || 'ACTIVESUBSTANCE_ADDL'
                                      || ' PROCESSED CHUNK-SQL',
                                      'SUCCESS',
                                      NULL,
                                      lvc_final_sql
                                    );
      pkg_etl_util.p_set_etl_master_status ( 'ACTIVESUBSTANCE_ADDL',
                                             'E2B',
                                             'SUCCESS'
                                           );
   END IF;

   pkg_etl_util.p_set_etl_constants_value ( 'ACT_SUB_CHUNK_SIZE_PROCESSED', 0 );
EXCEPTION
   WHEN OTHERS
   THEN
      pkg_etl_util.p_insert_stg_log ( ln_etl_seq_value,
                                      'ACTIVESUBSTANCE_ADDL',
                                      'P_POP_ACTIVESUBSTANCE_ADDL',
                                      SQL%ROWCOUNT,
                                         'PRE STAGE TO MART POPULATION IN '
                                      || 'ACTIVESUBSTANCE_ADDL'
                                      || ' PROCESSED CHUNK-SQL',
                                      'ERROR',
                                      NULL,
                                      lvc_final_sql
                                    );
      pkg_etl_util.p_insert_stg_excp
                               ( ln_etl_seq_value,
                                 'ACTIVESUBSTANCE_ADDL',
                                 'ERROR OCCURED IN P_POP_ACTIVESUBSTANCE_ADDL',
                                 SQLCODE,
                                 TO_CHAR (    SQLERRM
                                           || '->'
                                           || DBMS_UTILITY.format_error_backtrace
                                         )
                               );
      ROLLBACK;
      pkg_etl_util.p_set_etl_master_status ( 'ACTIVESUBSTANCE_ADDL',
                                             'E2B',
                                             'ERROR'
                                           );
      raise_application_error ( -20003,
                                'ERROR OCCURED IN P_POP_ACTIVESUBSTANCE_ADDL'
                              );
END;
/