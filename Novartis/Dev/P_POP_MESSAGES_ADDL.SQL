create or replace PROCEDURE p_pop_messages_addl
AS
   lvc_sql                VARCHAR2 ( 32000 ) := '';
   lvc_chunk_col          VARCHAR2 ( 100 )   := 'MSG_ID';
   exe_sql                VARCHAR2 ( 32000 ) := '';
   ln_start_position      NUMBER;
   ln_max_position        NUMBER;
   ln_end_position        NUMBER;
   ln_dblink_chunk_size   NUMBER             := 50000;
   l_sql_1                VARCHAR2 ( 4000 )  := '';
   lvc_final_sql          VARCHAR2 ( 32000 ) := '';
   ln_etl_seq_value       NUMBER;
   ln_status              NUMBER;
   ln_exec_status         NUMBER;
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
    WHERE etl_key = 'MESSAGES_CHUNK_SIZE_PROCESSED';

   SELECT execution_status
     INTO ln_exec_status
     FROM pvr_etl_master
    WHERE tgt_table_name = 'MESSAGES_ADDL';

   IF ln_exec_status IN ( 0, 2 )
   THEN
      pkg_etl_util.p_set_etl_master_status ( 'MESSAGES_ADDL', 'E2B', 'START' );
      ln_etl_seq_value    := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log ( ln_etl_seq_value,
                                      'MESSAGES_ADDL',
                                      'P_POP_MESSAGES_ADDL',
                                      NULL,
                                         'PRE STAGE TO MART POPULATION IN '
                                      || 'MESSAGES_ADDL'
                                      || ' BY PROCESSING CHUNKS-SQL',
                                      'START',
                                      NULL,
                                      NULL
                                    );

      IF lvc_etl_mode = 'INIT' AND ln_start_position = 0
      THEN
         pkg_etl_mart_util.p_truncate_table ( 'MESSAGES_ADDL' );
		 pkg_etl_mart_util.p_drop_objects ( 'MESSAGES_ADDL' );
      END IF;



      IF lvc_etl_mode = 'INIT'
      THEN
         lvc_sql    :=
            'insert /*+ append parallel(3) */ into messages_addl (MSG_ID,DATE_TRANSMITTED,DATE_RECEIVED,DATE_ACKNOWLEDGED,STATUS,EDI_TRACKING_ID,NUM_REPORTS,FILENAME,RECEIVE_FILENAME,DATE_TRANSMIT_TIMEOUT,DATE_ACK_TIMEOUT,DATE_E2B_TIMEOUT,MESSAGE,EDI_CONTROL_NO,LAST_UPDATE_TIME,TENANT_ID,GATEWAY_FILENAME,DELETED)
select MSG_ID,DATE_TRANSMITTED,DATE_RECEIVED,DATE_ACKNOWLEDGED,STATUS,EDI_TRACKING_ID,NUM_REPORTS,FILENAME,RECEIVE_FILENAME,DATE_TRANSMIT_TIMEOUT,DATE_ACK_TIMEOUT,DATE_E2B_TIMEOUT,MESSAGE,EDI_CONTROL_NO,LAST_UPDATE_TIME,ENTERPRISE_ID,GATEWAY_FILENAME,null as DELETED from ESM_OWNER.MESSAGES@pva_to_src';
      ELSE
         lvc_sql    :=
            'SELECT msg.msg_id AS msg_id,
   msg.date_transmitted AS date_transmitted,
   msg.date_received AS date_received,
   msg.date_acknowledged AS date_acknowledged,
   msg.status AS status,
   msg.edi_tracking_id AS edi_tracking_id,
   msg.num_reports AS num_reports,
   msg.filename AS filename,
   msg.receive_filename AS receive_filename,
   msg.date_transmit_timeout AS date_transmit_timeout,
   msg.date_ack_timeout AS date_ack_timeout,
   msg.date_e2b_timeout AS date_e2b_timeout,
   msg.edi_control_no AS edi_control_no,
   msg.last_update_time AS last_update_time,
   msg.message AS message,
   msg.gateway_filename AS gateway_filename,
   msg.enterprise_id AS tenant_id,
   NULL AS case_id,
   NULL AS processed_report_id,
   NULL AS DELETED
FROM MESSAGES@pva_to_src msg where msg.last_update_time>TO_DATE ('||q'[']'||lvc_e2b_date||q'[']'||',
                                 ''DD-MON-YYYY HH24:MI:SS'') and msg.last_update_time<=TO_DATE ('||q'[']'||lvc_e2b_max_date||q'[']'||',
                                 ''DD-MON-YYYY HH24:MI:SS'')';
      END IF;

      SELECT NVL ( MAX ( MSG_ID ), 0 )
        INTO ln_max_position
        FROM messages@pva_to_src;

      IF ln_start_position = 0
      THEN
         SELECT NVL ( MIN ( MSG_ID ), 0 )
           INTO ln_start_position
           FROM messages@pva_to_src;
      END IF;

      SELECT MIN ( MSG_ID )
        INTO ln_end_position
        FROM messages@pva_to_src
       WHERE MSG_ID > ln_start_position + ln_dblink_chunk_size;

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
            EXECUTE IMMEDIATE 'truncate table MESSAGES_ADDL_TEMP';

            lvc_final_sql    :=
                  'INSERT /*+ APPEND */ INTO MESSAGES_ADDL_TEMP (MSG_ID,DATE_TRANSMITTED,DATE_RECEIVED,DATE_ACKNOWLEDGED,STATUS,EDI_TRACKING_ID,NUM_REPORTS,FILENAME,RECEIVE_FILENAME,DATE_TRANSMIT_TIMEOUT,DATE_ACK_TIMEOUT,DATE_E2B_TIMEOUT,EDI_CONTROL_NO,LAST_UPDATE_TIME,MESSAGE,GATEWAY_FILENAME,TENANT_ID,case_id,processed_report_id,DELETED)'
               || exe_sql;

            EXECUTE IMMEDIATE lvc_final_sql USING ln_start_position, ln_end_position;
            COMMIT;
            lvc_final_sql    := '';
            lvc_final_sql    :=
                  'MERGE /*+ parallel(3) */  INTO messages_addl ct USING ( SELECT * FROM MESSAGES_ADDL_TEMP ) qry ON (
    ct.msg_id = qry.msg_id
AND
    ct.tenant_id = qry.tenant_id
) WHEN MATCHED THEN
UPDATE
SET date_transmitted = qry.date_transmitted,
date_received = qry.date_received,
date_acknowledged = qry.date_acknowledged,
status = qry.status,
edi_tracking_id = qry.edi_tracking_id,
num_reports = qry.num_reports,
filename = qry.filename,
receive_filename = qry.receive_filename,
date_transmit_timeout = qry.date_transmit_timeout,
date_ack_timeout = qry.date_ack_timeout,
date_e2b_timeout = qry.date_e2b_timeout,
edi_control_no = qry.edi_control_no,
last_update_time = qry.last_update_time,
message = qry.message,
gateway_filename = qry.gateway_filename,
deleted = qry.deleted,
case_id = qry.case_id,
processed_report_id = qry.processed_report_id
WHEN NOT MATCHED THEN INSERT ( msg_id,date_transmitted,date_received,date_acknowledged,status,edi_tracking_id,num_reports,filename,receive_filename,date_transmit_timeout,date_ack_timeout,date_e2b_timeout,edi_control_no,last_update_time,message,gateway_filename,tenant_id,deleted,case_id,processed_report_id ) VALUES ( qry.msg_id,qry.date_transmitted,qry.date_received,qry.date_acknowledged,qry.status,qry.edi_tracking_id,qry.num_reports,qry.filename,qry.receive_filename,qry.date_transmit_timeout,qry.date_ack_timeout,qry.date_e2b_timeout,qry.edi_control_no,qry.last_update_time,qry.message,qry.gateway_filename,qry.tenant_id,qry.deleted,qry.case_id,qry.processed_report_id )';

            EXECUTE IMMEDIATE lvc_final_sql;
         END IF;

         COMMIT;
         EXIT WHEN ln_end_position = ln_max_position + 1;
         ln_start_position    := ln_end_position;
         pkg_etl_util.p_set_etl_constants_value
                                            ( 'MESSAGES_CHUNK_SIZE_PROCESSED',
                                              ln_start_position
                                            );
         l_sql_1              :=
               ' SELECT
                        MIN(MSG_ID)
                    FROM
                        messages@pva_to_src
                    WHERE MSG_ID > :ln_start_position +'
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
	  pkg_etl_mart_util.p_create_objects ( 'MESSAGES_ADDL', 0 );
	  pkg_etl_mart_util.p_gather_statistics ( 'MESSAGES_ADDL' );
	  END IF;
      pkg_etl_util.p_insert_stg_log ( ln_etl_seq_value,
                                      'MESSAGES_ADDL',
                                      'P_POP_MESSAGES_ADDL',
                                      SQL%ROWCOUNT,
                                         'PRE STAGE TO MART POPULATION IN '
                                      || 'MESSAGES_ADDL'
                                      || ' PROCESSED CHUNK-SQL',
                                      'SUCCESS',
                                      NULL,
                                      lvc_final_sql
                                    );
      pkg_etl_util.p_set_etl_master_status ( 'MESSAGES_ADDL', 'E2B',
                                             'SUCCESS' );
      pkg_etl_util.p_set_etl_constants_value
                                            ( 'MESSAGES_CHUNK_SIZE_PROCESSED',
                                              0
                                            );
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      pkg_etl_util.p_insert_stg_log ( ln_etl_seq_value,
                                      'MESSAGES_ADDL',
                                      'P_POP_MESSAGES_ADDL',
                                      SQL%ROWCOUNT,
                                         'PRE STAGE TO MART POPULATION IN '
                                      || 'MESSAGES_ADDL'
                                      || ' PROCESSED CHUNK-SQL',
                                      'ERROR',
                                      NULL,
                                      lvc_final_sql
                                    );
      pkg_etl_util.p_insert_stg_excp
                                ( ln_etl_seq_value,
                                  'MESSAGES_ADDL',
                                  'ERROR OCCURED IN P_POP_MESSAGES_ADDL',
                                  SQLCODE,
                                  TO_CHAR
                                         (    SQLERRM
                                           || '->'
                                           || DBMS_UTILITY.format_error_backtrace
                                         )
                                );
      ROLLBACK;
      pkg_etl_util.p_set_etl_master_status ( 'MESSAGES_ADDL', 'E2B', 'ERROR' );
      raise_application_error ( -20003,
                                'ERROR OCCURED IN P_POP_MESSAGES_ADDL' );
END;
/