create or replace PROCEDURE p_pop_e2b_info
AS
   lvc_sql                VARCHAR2 ( 32000 ) := '';
   lvc_chunk_col          VARCHAR2 ( 100 )   := 'REPORT_ID';
   exe_sql                VARCHAR2 ( 32000 ) := '';
   ln_start_position      NUMBER;
   ln_max_position        NUMBER;
   ln_end_position        NUMBER;
   ln_dblink_chunk_size   NUMBER             := 50000;
   l_sql_1                VARCHAR2 ( 4000 )  := '';
   lvc_final_sql          VARCHAR2 ( 32000 ) := '';
   ln_etl_seq_value       NUMBER;
   ln_exec_status         NUMBER;
   ln_status              NUMBER;
   lvc_etl_mode           VARCHAR2 ( 30 )
                     := pkg_etl_util.f_get_etl_constants_value ( 'ETL_TYPE' );
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   SELECT etl_value
     INTO ln_start_position
     FROM pvr_etl_constants
    WHERE etl_key = 'E2B_INFO_CHUNK_SIZE_PROCESSED';

   SELECT execution_status
     INTO ln_exec_status
     FROM pvr_etl_master
    WHERE tgt_table_name = 'E2B_INFO';

   IF ln_exec_status IN ( 0, 2 )
   THEN
      pkg_etl_util.p_set_etl_master_status ( 'E2B_INFO', 'E2B', 'START' );
      ln_etl_seq_value    := pkg_etl_util.f_get_pvr_etl_seq_value;
      pkg_etl_util.p_insert_stg_log ( ln_etl_seq_value,
                                      'E2B_INFO',
                                      'P_POP_E2B_INFO',
                                      NULL,
                                         'PRE STAGE TO MART POPULATION IN '
                                      || 'E2B_INFO'
                                      || ' BY PROCESSING CHUNKS-SQL',
                                      'START',
                                      NULL,
                                      NULL
                                    );

      IF lvc_etl_mode = 'INIT' AND ln_start_position = 0
      THEN
         pkg_etl_mart_util.p_truncate_table ( 'E2B_INFO' );
		 pkg_etl_mart_util.p_drop_objects ( 'E2B_INFO' );
      END IF;



      IF lvc_etl_mode = 'INIT'
      THEN
         lvc_sql    :=
            'insert /*+ append parallel(3) */ into E2B_INFO (REPORT_ID,SAFETYREPORTID,SAFETYREPORTVERSION,PRIMARYSOURCECOUNTRY,OCCURCOUNTRY,TRANSMISSIONDATEFORMAT,TRANSMISSIONDATE,REPORTTYPE,SERIOUS,SERIOUSNESSDEATH,SERIOUSNESSLIFETHREATENING,SERIOUSNESSHOSPITALIZATION,SERIOUSNESSDISABLING,SERIOUSNESSCONGENITALANOMALI,SERIOUSNESSOTHER,RECEIVEDATEFORMAT,RECEIVEDATE,RECEIPTDATEFORMAT,RECEIPTDATE,ADDITIONALDOCUMENT,DOCUMENTLIST,FULFILLEXPEDITECRITERIA,COMPANYNUMB,AUTHORITYNUMB,OTHERNUMB,DUPLICATE,CASENULLIFICATION,MSG_ID,MEDICALLYCONFIRM,SENDER_AGENCY,RECEIVER_AGENCY,E2B_TYPE,CASE_XREF,STATUS,E2B,FILENAME,AGENCY_ID,PROCESSED,DATE_IMPORTED,WARN_CASE_ID,WARN_SEQ_NUM,USER_ID,LOCKED_USER_ID,E2B_TYPE_ACCEPT_AS,LAST_UPDATE_TIME,AUTOACCEPTPROCESS,SECURITY_TYPE,TENANT_ID,ERRORMESSAGECOMMENT,MESSAGEIDENTIFIER,MESSAGERECEIVERIDENTIFIER,MESSAGESENDERIDENTIFIER,MESSAGECREATIONDATE,REPORTHEADER,TRANSMISSIONDATER3,FULFILLEXPEDITECRITERIAR3,CASESENDERTYPE,ADDITIONALDOCUMENTR3,DUPLICATER3,RECEIVEDATER3,RECEIPTDATER3,NULLIFICATIONREASON,PROFILE,CASE_ID,PROCESSED_REPORT_ID,DELETED)
select REPORT_ID,SAFETYREPORTID,SAFETYREPORTVERSION,PRIMARYSOURCECOUNTRY,OCCURCOUNTRY,TRANSMISSIONDATEFORMAT,TRANSMISSIONDATE,REPORTTYPE,SERIOUS,SERIOUSNESSDEATH,SERIOUSNESSLIFETHREATENING,SERIOUSNESSHOSPITALIZATION,SERIOUSNESSDISABLING,SERIOUSNESSCONGENITALANOMALI,SERIOUSNESSOTHER,RECEIVEDATEFORMAT,RECEIVEDATE,RECEIPTDATEFORMAT,RECEIPTDATE,ADDITIONALDOCUMENT,DOCUMENTLIST,FULFILLEXPEDITECRITERIA,COMPANYNUMB,AUTHORITYNUMB,OTHERNUMB,DUPLICATE,CASENULLIFICATION,MSG_ID,MEDICALLYCONFIRM,SENDER_AGENCY,RECEIVER_AGENCY,E2B_TYPE,CASE_XREF,STATUS,E2B,FILENAME,AGENCY_ID,PROCESSED,DATE_IMPORTED,WARN_CASE_ID,WARN_SEQ_NUM,USER_ID,LOCKED_USER_ID,E2B_TYPE_ACCEPT_AS,LAST_UPDATE_TIME,AUTOACCEPTPROCESS,SECURITY_TYPE,ENTERPRISE_ID,ERRORMESSAGECOMMENT,MESSAGEIDENTIFIER,MESSAGERECEIVERIDENTIFIER,MESSAGESENDERIDENTIFIER,MESSAGECREATIONDATE,REPORTHEADER,TRANSMISSIONDATER3,FULFILLEXPEDITECRITERIAR3,CASESENDERTYPE,ADDITIONALDOCUMENTR3,DUPLICATER3,RECEIVEDATER3,RECEIPTDATER3,NULLIFICATIONREASON,PROFILE,CASE_ID ,REG_REPORT_ID ,DELETED from V_SAFETYREPORT@pva_to_src';
      ELSE
         lvc_sql    :=
            'SELECT sfty_rep.report_id AS report_id,
   sfty_rep.safetyreportid AS safetyreportid,
   sfty_rep.safetyreportversion AS safetyreportversion,
   sfty_rep.primarysourcecountry AS primarysourcecountry,
   sfty_rep.occurcountry AS occurcountry,
   sfty_rep.transmissiondateformat AS transmissiondateformat,
   sfty_rep.transmissiondate AS transmissiondate,
   sfty_rep.reporttype AS reporttype,
   sfty_rep.serious AS serious,
   sfty_rep.seriousnessdeath AS seriousnessdeath,
   sfty_rep.seriousnesslifethreatening AS seriousnesslifethreatening,
   sfty_rep.seriousnesshospitalization AS seriousnesshospitalization,
   sfty_rep.seriousnessdisabling AS seriousnessdisabling,
   sfty_rep.seriousnesscongenitalanomali AS seriousnesscongenitalanomali,
   sfty_rep.seriousnessother AS seriousnessother,
   sfty_rep.receivedateformat AS receivedateformat,
   sfty_rep.receivedate AS receivedate,
   sfty_rep.receiptdateformat AS receiptdateformat,
   sfty_rep.receiptdate AS receiptdate,
   sfty_rep.additionaldocument AS additionaldocument,
   sfty_rep.documentlist AS documentlist,
   sfty_rep.fulfillexpeditecriteria AS fulfillexpeditecriteria,
   sfty_rep.companynumb AS companynumb,
   sfty_rep.authoritynumb AS authoritynumb,
   sfty_rep.othernumb AS othernumb,
   sfty_rep.duplicate AS duplicate,
   sfty_rep.casenullification AS casenullification,
   sfty_rep.msg_id AS msg_id,
   sfty_rep.medicallyconfirm AS medicallyconfirm,
   sfty_rep.sender_agency AS sender_agency,
   sfty_rep.receiver_agency AS receiver_agency,
   sfty_rep.e2b_type AS e2b_type,
   sfty_rep.case_xref AS case_xref,
   sfty_rep.status AS status,
   sfty_rep.agency_id AS agency_id,
   sfty_rep.processed AS processed,
   sfty_rep.date_imported AS date_imported,
   sfty_rep.warn_case_id AS warn_case_id,
   sfty_rep.warn_seq_num AS warn_seq_num,
   sfty_rep.user_id AS user_id,
   sfty_rep.autoacceptprocess AS autoacceptprocess,
   sfty_rep.locked_user_id AS locked_user_id,
   sfty_rep.last_update_time AS last_update_time,
   sfty_rep.security_type AS security_type,
   sfty_rep.e2b AS e2b,
   sfty_rep.filename AS filename,
   sfty_rep.e2b_type_accept_as AS e2b_type_accept_as,
   sfty_rep.errormessagecomment AS errormessagecomment,
   sfty_rep.messageidentifier AS messageidentifier,
   sfty_rep.messagereceiveridentifier AS messagereceiveridentifier,
   sfty_rep.messagesenderidentifier AS messagesenderidentifier,
   sfty_rep.messagecreationdate AS messagecreationdate,
   sfty_rep.reportheader AS reportheader,
   sfty_rep.transmissiondater3 AS transmissiondater3,
   sfty_rep.fulfillexpeditecriteriar3 AS fulfillexpeditecriteriar3,
   sfty_rep.casesendertype AS casesendertype,
   sfty_rep.additionaldocumentr3 AS additionaldocumentr3,
   sfty_rep.duplicater3 AS duplicater3,
   sfty_rep.enterprise_id AS tenant_id,
   sfty_rep.receivedater3 AS receivedater3,
   sfty_rep.receiptdater3 AS receiptdater3,
   sfty_rep.nullificationreason AS nullificationreason,
   sfty_rep.profile AS profile,
   sfty_rep.case_id AS case_id,
   sfty_rep.reg_report_id AS processed_report_id,
   sfty_rep.deleted AS deleted
FROM V_SAFETYREPORT@pva_to_src sfty_rep';
      END IF;

      SELECT NVL ( MAX ( ID ), 0 )
        INTO ln_max_position
        FROM pvr_process_data@pva_to_src
       WHERE table_type = 'E';

      IF ln_start_position = 0
      THEN
         SELECT NVL ( MIN ( ID ), 0 )
           INTO ln_start_position
           FROM pvr_process_data@pva_to_src
          WHERE table_type = 'E';
      END IF;

      SELECT MIN ( ID )
        INTO ln_end_position
        FROM pvr_process_data@pva_to_src
       WHERE table_type = 'E'
             AND ID > ln_start_position + ln_dblink_chunk_size;

      IF ln_end_position IS NULL
      THEN
         ln_end_position    := ln_max_position + 1;
      END IF;

      LOOP
         exe_sql              :=
               lvc_sql
            || ' where deleted is null and '
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
            EXECUTE IMMEDIATE 'truncate table E2B_INFO_TEMP';

            lvc_final_sql    :=
                  'INSERT /*+ APPEND */ INTO E2B_INFO_TEMP (REPORT_ID,SAFETYREPORTID,SAFETYREPORTVERSION,PRIMARYSOURCECOUNTRY,OCCURCOUNTRY,TRANSMISSIONDATEFORMAT,TRANSMISSIONDATE,REPORTTYPE,SERIOUS,SERIOUSNESSDEATH,SERIOUSNESSLIFETHREATENING,SERIOUSNESSHOSPITALIZATION,SERIOUSNESSDISABLING,SERIOUSNESSCONGENITALANOMALI,SERIOUSNESSOTHER,RECEIVEDATEFORMAT,RECEIVEDATE,RECEIPTDATEFORMAT,RECEIPTDATE,ADDITIONALDOCUMENT,DOCUMENTLIST,FULFILLEXPEDITECRITERIA,COMPANYNUMB,AUTHORITYNUMB,OTHERNUMB,DUPLICATE,CASENULLIFICATION,MSG_ID,MEDICALLYCONFIRM,SENDER_AGENCY,RECEIVER_AGENCY,E2B_TYPE,CASE_XREF,STATUS,AGENCY_ID,PROCESSED,DATE_IMPORTED,WARN_CASE_ID,WARN_SEQ_NUM,USER_ID,AUTOACCEPTPROCESS,LOCKED_USER_ID,LAST_UPDATE_TIME,SECURITY_TYPE,E2B,FILENAME,E2B_TYPE_ACCEPT_AS,ERRORMESSAGECOMMENT,MESSAGEIDENTIFIER,MESSAGERECEIVERIDENTIFIER,MESSAGESENDERIDENTIFIER,MESSAGECREATIONDATE,REPORTHEADER,TRANSMISSIONDATER3,FULFILLEXPEDITECRITERIAR3,CASESENDERTYPE,ADDITIONALDOCUMENTR3,DUPLICATER3,TENANT_ID,RECEIVEDATER3,RECEIPTDATER3,NULLIFICATIONREASON,PROFILE,CASE_ID,PROCESSED_REPORT_ID,DELETED)'
               || exe_sql;

            EXECUTE IMMEDIATE lvc_final_sql
                        USING ln_start_position, ln_end_position;

            COMMIT;
			lvc_final_sql    := '';
            lvc_final_sql    :=
                  'MERGE /*+ parallel(3) */  INTO e2b_info ct USING ( SELECT * FROM E2B_INFO_TEMP
) qry ON (
    ct.report_id = qry.report_id
AND
    ct.tenant_id = qry.tenant_id
) WHEN MATCHED THEN
UPDATE
SET safetyreportid = qry.safetyreportid,
safetyreportversion = qry.safetyreportversion,
primarysourcecountry = qry.primarysourcecountry,
occurcountry = qry.occurcountry,
transmissiondateformat = qry.transmissiondateformat,
transmissiondate = qry.transmissiondate,
reporttype = qry.reporttype,
serious = qry.serious,
seriousnessdeath = qry.seriousnessdeath,
seriousnesslifethreatening = qry.seriousnesslifethreatening,
seriousnesshospitalization = qry.seriousnesshospitalization,
seriousnessdisabling = qry.seriousnessdisabling,
seriousnesscongenitalanomali = qry.seriousnesscongenitalanomali,
seriousnessother = qry.seriousnessother,
receivedateformat = qry.receivedateformat,
receivedate = qry.receivedate,
receiptdateformat = qry.receiptdateformat,
receiptdate = qry.receiptdate,
additionaldocument = qry.additionaldocument,
documentlist = qry.documentlist,
fulfillexpeditecriteria = qry.fulfillexpeditecriteria,
companynumb = qry.companynumb,
authoritynumb = qry.authoritynumb,
othernumb = qry.othernumb,
duplicate = qry.duplicate,
casenullification = qry.casenullification,
msg_id = qry.msg_id,
medicallyconfirm = qry.medicallyconfirm,
sender_agency = qry.sender_agency,
receiver_agency = qry.receiver_agency,
e2b_type = qry.e2b_type,
case_xref = qry.case_xref,
status = qry.status,
agency_id = qry.agency_id,
processed = qry.processed,
date_imported = qry.date_imported,
warn_case_id = qry.warn_case_id,
warn_seq_num = qry.warn_seq_num,
user_id = qry.user_id,
autoacceptprocess = qry.autoacceptprocess,
locked_user_id = qry.locked_user_id,
last_update_time = qry.last_update_time,
security_type = qry.security_type,
e2b = qry.e2b,
filename = qry.filename,
e2b_type_accept_as = qry.e2b_type_accept_as,
errormessagecomment = qry.errormessagecomment,
messageidentifier = qry.messageidentifier,
messagereceiveridentifier = qry.messagereceiveridentifier,
messagesenderidentifier = qry.messagesenderidentifier,
messagecreationdate = qry.messagecreationdate,
reportheader = qry.reportheader,
transmissiondater3 = qry.transmissiondater3,
fulfillexpeditecriteriar3 = qry.fulfillexpeditecriteriar3,
casesendertype = qry.casesendertype,
additionaldocumentr3 = qry.additionaldocumentr3,
duplicater3 = qry.duplicater3,
receivedater3 = qry.receivedater3,
receiptdater3 = qry.receiptdater3,
nullificationreason = qry.nullificationreason,
profile = qry.profile,
case_id = qry.case_id,
processed_report_id = qry.processed_report_id,
deleted = qry.deleted
WHEN NOT MATCHED THEN INSERT ( report_id,safetyreportid,safetyreportversion,primarysourcecountry,occurcountry,transmissiondateformat,transmissiondate,reporttype,serious,seriousnessdeath,seriousnesslifethreatening,seriousnesshospitalization,seriousnessdisabling,seriousnesscongenitalanomali,seriousnessother,receivedateformat,receivedate,receiptdateformat,receiptdate,additionaldocument,documentlist,fulfillexpeditecriteria,companynumb,authoritynumb,othernumb,duplicate,casenullification,msg_id,medicallyconfirm,sender_agency,receiver_agency,e2b_type,case_xref,status,agency_id,processed,date_imported,warn_case_id,warn_seq_num,user_id,autoacceptprocess,locked_user_id,last_update_time,security_type,e2b,filename,e2b_type_accept_as,errormessagecomment,messageidentifier,messagereceiveridentifier,messagesenderidentifier,messagecreationdate,reportheader,transmissiondater3,fulfillexpeditecriteriar3,casesendertype,additionaldocumentr3,duplicater3,tenant_id,receivedater3,receiptdater3,nullificationreason,profile,case_id,processed_report_id,deleted ) VALUES ( qry.report_id,qry.safetyreportid,qry.safetyreportversion,qry.primarysourcecountry,qry.occurcountry,qry.transmissiondateformat,qry.transmissiondate,qry.reporttype,qry.serious,qry.seriousnessdeath,qry.seriousnesslifethreatening,qry.seriousnesshospitalization,qry.seriousnessdisabling,qry.seriousnesscongenitalanomali,qry.seriousnessother,qry.receivedateformat,qry.receivedate,qry.receiptdateformat,qry.receiptdate,qry.additionaldocument,qry.documentlist,qry.fulfillexpeditecriteria,qry.companynumb,qry.authoritynumb,qry.othernumb,qry.duplicate,qry.casenullification,qry.msg_id,qry.medicallyconfirm,qry.sender_agency,qry.receiver_agency,qry.e2b_type,qry.case_xref,qry.status,qry.agency_id,qry.processed,qry.date_imported,qry.warn_case_id,qry.warn_seq_num,qry.user_id,qry.autoacceptprocess,qry.locked_user_id,qry.last_update_time,qry.security_type,qry.e2b,qry.filename,qry.e2b_type_accept_as,qry.errormessagecomment,qry.messageidentifier,qry.messagereceiveridentifier,qry.messagesenderidentifier,qry.messagecreationdate,qry.reportheader,qry.transmissiondater3,qry.fulfillexpeditecriteriar3,qry.casesendertype,qry.additionaldocumentr3,qry.duplicater3,qry.tenant_id,qry.receivedater3,qry.receiptdater3,qry.nullificationreason,qry.profile,qry.case_id,qry.processed_report_id,qry.deleted )';

            EXECUTE IMMEDIATE lvc_final_sql;
         END IF;

         COMMIT;
         EXIT WHEN ln_end_position = ln_max_position + 1;
         ln_start_position    := ln_end_position;
         pkg_etl_util.p_set_etl_constants_value
                                            ( 'E2B_INFO_CHUNK_SIZE_PROCESSED',
                                              ln_start_position
                                            );
         l_sql_1              :=
               ' SELECT
                        MIN(id)
                    FROM
                        pvr_process_data@pva_to_src
                    WHERE table_type =''E''
                          and id > :ln_start_position +'
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
	  pkg_etl_mart_util.p_create_objects ( 'E2B_INFO', 0 );
	  pkg_etl_mart_util.p_gather_statistics ( 'E2B_INFO' );
	  END IF;
      pkg_etl_util.p_insert_stg_log ( ln_etl_seq_value,
                                      'E2B_INFO',
                                      'P_POP_E2B_INFO',
                                      SQL%ROWCOUNT,
                                         'PRE STAGE TO MART POPULATION IN '
                                      || 'E2B_INFO'
                                      || ' PROCESSED CHUNK-SQL',
                                      'SUCCESS',
                                      NULL,
                                      lvc_final_sql
                                    );
      pkg_etl_util.p_set_etl_master_status ( 'E2B_INFO', 'E2B', 'SUCCESS' );
      pkg_etl_util.p_set_etl_constants_value
                                            ( 'E2B_INFO_CHUNK_SIZE_PROCESSED',
                                              0
                                            );
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      pkg_etl_util.p_insert_stg_log ( ln_etl_seq_value,
                                      'E2B_INFO',
                                      'P_POP_E2B_INFO',
                                      SQL%ROWCOUNT,
                                         'PRE STAGE TO MART POPULATION IN '
                                      || 'E2B_INFO'
                                      || ' PROCESSED CHUNK-SQL',
                                      'ERROR',
                                      NULL,
                                      lvc_final_sql
                                    );
      pkg_etl_util.p_insert_stg_excp
                                ( ln_etl_seq_value,
                                  'E2B_INFO',
                                  'ERROR OCCURED IN P_POP_E2B_INFO',
                                  SQLCODE,
                                  TO_CHAR
                                         (    SQLERRM
                                           || '->'
                                           || DBMS_UTILITY.format_error_backtrace
                                         )
                                );
      ROLLBACK;
      pkg_etl_util.p_set_etl_master_status ( 'E2B_INFO', 'E2B', 'ERROR' );
      raise_application_error ( -20003, 'ERROR OCCURED IN P_POP_E2B_INFO' );
END;
/