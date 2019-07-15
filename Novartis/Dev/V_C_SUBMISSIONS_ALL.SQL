CREATE OR REPLACE VIEW v_c_submissions_all
AS
   SELECT crr."CASE_ID", crr."CRR_REC_NUM", crr."REG_REPORT_ID",
          crr."DATE_ASSESSED", crr."SORT_ID", crr."DELETED", crr."TENANT_ID",
          crr."DLP_REVISION_NUMBER", crr."DATE_VERSION_START",
          crr."DATE_VERSION_END", crr."DELETED_FLAG", crr."IID_1",
          crr."VERSION_NUM", crr."PERIODIC_REPORT_FLAG",
          cmr1.auth_id flag_db_source,
          crr.reg_report_id AS processed_report_id, flag_nullification,
          date_generation, cd_date_generation, txt_date_generation,
          date_rpt_due, cd_date_rpt_due, txt_date_rpt_due, date_submission,
          cd_date_submission, txt_date_submission, destination_id,
          destination_desc, submission_form_id, root_form_type_id,
          root_form_type_desc, rec_type, voided, nullification_txt,
          src_case_id, rec_creation_user_id, date_rec_creation,
          rec_modification_user_id, date_rec_modification, source_type,
          submission_form_desc, followup#,
          root_form_type_desc AS submission_form_type_desc,
          root_form_type_id AS submission_form_type_id,
          flag_nullification AS flag_report_nullification,
          nullification_txt AS report_nullification_text,
          CASE
             WHEN TO_DATE (NVL (TRIM (cmr1.date_submission), TRIM (SYSDATE))
                          ) <= TRIM (cmr1.date_rpt_due)
                THEN 1
             ELSE 0
          END AS submit_status
     FROM c_submissions cmr1 JOIN c_reg_reports_addl crr
          ON (cmr1.processed_report_id = crr.reg_report_id)
          ;