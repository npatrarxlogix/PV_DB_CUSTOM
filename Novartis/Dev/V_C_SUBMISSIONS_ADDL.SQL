CREATE OR REPLACE VIEW v_c_submissions_addl
AS
   SELECT crr.reg_report_id AS processed_report_id, crr.case_id,
          crr.tenant_id, cmr1.voided, cmr1.version_num,
          cmr1.date_submission_determined, cmr1.GROUP_ID,
          cmr1.determined_user_id, cmr1.country_id, cmr1.pdf_id,
          cmr1.language_id, cmr1.case_rev, cmr1.priority, cmr1.state_id,
          cmr1.owner_id, cmr1.last_state_id, cmr1.auto_sched, cmr1.user_id,
          cmr1.template_id, cmr1.per_report_flag, cmr1.method,
          cmr1.output_status, cmr1.print_id, cmr1.transmit_id,
          cmr1.aware_method, cmr1.esm_report_id, cmr1.tracking_num,
          cmr1.event, cmr1.body_sys, cmr1.status_text, cmr1.generation_error,
          cmr1.protect, cmr1.rpt_comment, cmr1.comment_type_id,
          cmr1.source_report_id, cmr1.documentum_id, cmr1.mark_as_submitted,
          cmr1.ref_type_id, cmr1.notification, cmr1.documentum_id_publish,
          cmr1.prod_seq_num, cmr1.scheduled_by_id, cmr1.report_form_type,
          cmr1.auto_distribute_reports, cmr1.blind_study_product,
          cmr1.prev_esm_rpt_id, cmr1.no_followup_downgrade,
          cmr1.group_2_country_adjust_days, cmr1.local_report,
          cmr1.reg_rpt_rules_id, cmr1.schedule_method, cmr1.schedule_date,
          cmr1.generate_rpt, cmr1.amendment, cmr1.urgent_report,
          cmr1.flag_db_source, cmr1.iid_1, cmr1.flag_pmda
     FROM rpt_reg_reports_addl cmr1 JOIN c_reg_reports_addl crr
          ON (cmr1.processed_report_id = crr.reg_report_id)
    WHERE cmr1.voided = 0 AND crr.deleted IS NULL;