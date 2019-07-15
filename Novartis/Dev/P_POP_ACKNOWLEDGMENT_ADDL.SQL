create or replace PROCEDURE p_pop_acknowledgment_addl
AS
   lvc_sql                VARCHAR2 ( 32000 ) := '';
   lvc_chunk_col          VARCHAR2 ( 100 )   := 'ACK_ID';
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
   lvc_etl_mode           VARCHAR2 ( 30 )
                     := pkg_etl_util.f_get_etl_constants_value ( 'ETL_TYPE' );
   lvc_e2b_date           VARCHAR2 ( 50 )
                     := pkg_etl_util.f_get_etl_constants_value ( 'ETL_E2B_EXECUTION_DATE' );
   lvc_e2b_max_date       VARCHAR2 ( 50 )
                     := pkg_etl_util.f_get_etl_constants_value ( 'ETL_E2B_END_DATE' );
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   SELECT etl_value
     INTO ln_start_position
     FROM pvr_etl_constants
    WHERE etl_key = 'ACK_CHUNK_SIZE_PROCESSED';

   SELECT execution_status
     INTO ln_exec_status
     FROM pvr_etl_master
    WHERE tgt_table_name = 'ACKNOWLEDGMENT_ADDL';

   IF ln_exec_status IN ( 0, 2 )
   THEN
      pkg_etl_util.p_set_etl_master_status ( 'ACKNOWLEDGMENT_ADDL',
                                             'E2B',
                                             'START'
                                           );
      ln_etl_seq_value    := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log ( ln_etl_seq_value,
                                      'ACKNOWLEDGMENT_ADDL',
                                      'P_POP_ACKNOWLEDGMENT_ADDL',
                                      NULL,
                                         'PRE STAGE TO MART POPULATION IN '
                                      || 'ACKNOWLEDGMENT_ADDL'
                                      || ' BY PROCESSING CHUNKS-SQL',
                                      'START',
                                      NULL,
                                      NULL
                                    );

      IF lvc_etl_mode = 'INIT' AND ln_start_position = 0
      THEN
         pkg_etl_mart_util.p_truncate_table ( 'ACKNOWLEDGMENT_ADDL' );
         pkg_etl_mart_util.p_drop_objects ( 'ACKNOWLEDGMENT_ADDL' );
      END IF;

      IF lvc_etl_mode = 'INIT'
      THEN
         lvc_sql    :=
            'insert /*+ append parallel(3) */ into ACKNOWLEDGMENT_ADDL (ACK_ID,MSG_ID,DATE_TRANSMITTED,DATE_RECEIVED,STATUS,FILENAME,EDI_TRACKING_ID,RECEIVE_FILENAME,ACK,EDI_CONTROL_NO,LAST_UPDATE_TIME,TENANT_ID,GATEWAY_FILENAME,ACK_R3,DELETED)
             select ACK_ID,MSG_ID,DATE_TRANSMITTED,DATE_RECEIVED,STATUS,FILENAME,EDI_TRACKING_ID,RECEIVE_FILENAME,ACK,EDI_CONTROL_NO,LAST_UPDATE_TIME,ENTERPRISE_ID,GATEWAY_FILENAME,ACK_R3,null as DELETED from ESM_OWNER.ACKNOWLEDGMENT@pva_to_src';
      ELSE
         lvc_sql    :=
            'SELECT ack.ack_id AS ack_id,
               ack.msg_id AS msg_id,
               ack.date_transmitted AS date_transmitted,
               ack.date_received AS date_received,
               ack.status AS status,
               ack.filename AS filename,
               ack.edi_tracking_id AS edi_tracking_id,
               ack.receive_filename AS receive_filename,
               ack.edi_control_no AS edi_control_no,
               ack.last_update_time AS last_update_time,
               ack.ack AS ack,
               ack.gateway_filename AS gateway_filename,
               ack.ack_r3 AS ack_r3,
               ack.enterprise_id AS tenant_id,
			   NULL as DELETED,
               NULL AS case_id,
               NULL AS processed_report_id
            FROM acknowledgment@pva_to_src ack where ack.last_update_time>TO_DATE ('||q'[']'||lvc_e2b_date||q'[']'||',
                                 ''DD-MON-YYYY HH24:MI:SS'') and ack.last_update_time<=TO_DATE ('||q'[']'||lvc_e2b_max_date||q'[']'||',
                                 ''DD-MON-YYYY HH24:MI:SS'')';
      END IF;

      SELECT NVL ( MAX ( ack_id ), 0 )
        INTO ln_max_position
        FROM acknowledgment@pva_to_src;

      IF ln_start_position = 0
      THEN
         SELECT NVL ( MIN ( ack_id ), 0 )
           INTO ln_start_position
           FROM acknowledgment@pva_to_src;
      END IF;

      SELECT MIN ( ack_id )
        INTO ln_end_position
        FROM acknowledgment@pva_to_src
       WHERE ack_id > ln_start_position + ln_dblink_chunk_size;

      IF ln_end_position IS NULL
      THEN
         ln_end_position    := ln_max_position + 1;
      END IF;

      LOOP
         exe_sql              :=
               lvc_sql
            || case when lvc_etl_mode = 'INIT' then ' where ' else ' and ' end
            || lvc_chunk_col
            || ' >=  :ln_start_position
                         and '
            || lvc_chunk_col
            || ' < :ln_end_position ';

         IF lvc_etl_mode = 'INIT'
         THEN
            lvc_final_sql    := exe_sql;

            EXECUTE IMMEDIATE exe_sql
                        USING ln_start_position, ln_end_position;
         ELSE
            EXECUTE IMMEDIATE 'truncate table ACKNOWLEDGMENT_ADDL_TEMP';

            lvc_final_sql    :=
                  'INSERT /*+ APPEND */ INTO ACKNOWLEDGMENT_ADDL_TEMP (ACK_ID,MSG_ID,DATE_TRANSMITTED,DATE_RECEIVED,STATUS,FILENAME,EDI_TRACKING_ID,RECEIVE_FILENAME,EDI_CONTROL_NO,LAST_UPDATE_TIME,ACK,GATEWAY_FILENAME,ACK_R3,TENANT_ID,DELETED,case_id,processed_report_id) '
               || exe_sql;

            EXECUTE IMMEDIATE lvc_final_sql USING ln_start_position, ln_end_position;

			COMMIT;
            lvc_final_sql    := '';
            lvc_final_sql    :=
                  'MERGE /*+ parallel(3) */ INTO acknowledgment_addl ct USING (SELECT * FROM ACKNOWLEDGMENT_ADDL_TEMP
                    ) qry ON (
                        ct.ack_id = qry.ack_id
                    AND
                        ct.tenant_id = qry.tenant_id
                    ) WHEN MATCHED THEN
                    UPDATE
                    SET msg_id = qry.msg_id,
                    date_transmitted = qry.date_transmitted,
                    date_received = qry.date_received,
                    status = qry.status,
                    filename = qry.filename,
                    edi_tracking_id = qry.edi_tracking_id,
                    receive_filename = qry.receive_filename,
                    edi_control_no = qry.edi_control_no,
                    last_update_time = qry.last_update_time,
                    ack = qry.ack,
                    gateway_filename = qry.gateway_filename,
                    ack_r3 = qry.ack_r3,
                    deleted = qry.deleted,
                    case_id = qry.case_id,
                    processed_report_id = qry.processed_report_id
                    WHEN NOT MATCHED THEN INSERT ( ACK_ID,MSG_ID,DATE_TRANSMITTED,DATE_RECEIVED,STATUS,FILENAME,EDI_TRACKING_ID,RECEIVE_FILENAME,EDI_CONTROL_NO,LAST_UPDATE_TIME,ACK,GATEWAY_FILENAME,ACK_R3,TENANT_ID,DELETED,CASE_ID,PROCESSED_REPORT_ID ) VALUES ( qry.ACK_ID,qry.MSG_ID,qry.DATE_TRANSMITTED,qry.DATE_RECEIVED,qry.STATUS,qry.FILENAME,qry.EDI_TRACKING_ID,qry.RECEIVE_FILENAME,qry.EDI_CONTROL_NO,qry.LAST_UPDATE_TIME,qry.ACK,qry.GATEWAY_FILENAME,qry.ACK_R3,qry.TENANT_ID,qry.DELETED,qry.CASE_ID,qry.PROCESSED_REPORT_ID )';

            EXECUTE IMMEDIATE lvc_final_sql;

         END IF;

         COMMIT;
         EXIT WHEN ln_end_position = ln_max_position + 1;
         ln_start_position    := ln_end_position;
         pkg_etl_util.p_set_etl_constants_value ( 'ACK_CHUNK_SIZE_PROCESSED',
                                                  ln_start_position
                                                );
         l_sql_1              :=
               ' SELECT
                        MIN(ack_id)
                    FROM
                       acknowledgment@pva_to_src
                    WHERE ack_id > :ln_start_position +'
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
         pkg_etl_mart_util.p_create_objects ( 'ACKNOWLEDGMENT_ADDL', 0 );
         pkg_etl_mart_util.p_gather_statistics ( 'ACKNOWLEDGMENT_ADDL' );
      END IF;

      pkg_etl_util.p_insert_stg_log ( ln_etl_seq_value,
                                      'ACKNOWLEDGMENT_ADDL',
                                      'P_POP_ACKNOWLEDGMENT_ADDL',
                                      SQL%ROWCOUNT,
                                         'PRE STAGE TO MART POPULATION IN '
                                      || 'ACKNOWLEDGMENT_ADDL'
                                      || ' PROCESSED CHUNK-SQL',
                                      'SUCCESS',
                                      NULL,
                                      lvc_final_sql
                                    );
      pkg_etl_util.p_set_etl_master_status ( 'ACKNOWLEDGMENT_ADDL',
                                             'E2B',
                                             'SUCCESS'
                                           );
      pkg_etl_util.p_set_etl_constants_value ( 'ACK_CHUNK_SIZE_PROCESSED', 0 );                                            
   END IF;

   
EXCEPTION
   WHEN OTHERS
   THEN
      pkg_etl_util.p_insert_stg_log ( ln_etl_seq_value,
                                      'ACKNOWLEDGMENT_ADDL',
                                      'P_POP_ACKNOWLEDGMENT_ADDL',
                                      SQL%ROWCOUNT,
                                         'PRE STAGE TO MART POPULATION IN '
                                      || 'ACKNOWLEDGMENT_ADDL'
                                      || ' PROCESSED CHUNK-SQL',
                                      'ERROR',
                                      NULL,
                                      lvc_final_sql
                                    );
      pkg_etl_util.p_insert_stg_excp
                                ( ln_etl_seq_value,
                                  'ACKNOWLEDGMENT_ADDL',
                                  'ERROR OCCURED IN P_POP_ACKNOWLEDGMENT_ADDL',
                                  SQLCODE,
                                  TO_CHAR
                                         (    SQLERRM
                                           || '->'
                                           || DBMS_UTILITY.format_error_backtrace
                                         )
                                );
      ROLLBACK;
      pkg_etl_util.p_set_etl_master_status ( 'ACKNOWLEDGMENT_ADDL',
                                             'E2B',
                                             'ERROR'
                                           );
      raise_application_error
                             ( -20003,
                                  'ERROR OCCURED IN P_POP_ACKNOWLEDGMENT_ADDL '
                               || TO_CHAR
                                         (    SQLERRM
                                           || '->'
                                           || DBMS_UTILITY.format_error_backtrace
                                         )
                             );
END;
/