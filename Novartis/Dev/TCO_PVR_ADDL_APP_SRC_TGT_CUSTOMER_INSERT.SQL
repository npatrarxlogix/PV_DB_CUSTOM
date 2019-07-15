BEGIN
   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_MASTER_ADDL',
                'POP_MARKETING', NULL, NULL,
                'VARCHAR2', NULL, 4000,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_MASTER_ADDL',
                'PMS_STUDIES', NULL, NULL,
                'NUMBER', NULL, 22,
                0, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_EVENT_ADDL',
                'FLAG_MOST_REL_AE', NULL, NULL,
                'NUMBER', NULL, 22,
                0, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_EVENT_ADDL',
                'DIAG_TO_SYMP_PT', NULL, NULL,
                'VARCHAR2', NULL, 10000,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'L_PRODUCT_ADDL',
                'SUSP_GENERIC_NAME', NULL, NULL,
                'CLOB', NULL, 4000,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'L_PRODUCT_ADDL',
                'CONC_GENERIC_NAME', NULL, NULL,
                'CLOB', NULL, 4000,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'L_MASTER_ADDL',
                'PAT_OTHER_TRTMNT_HIST_PT_CODE', NULL, NULL,
                'CLOB', NULL, 4000,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'L_MASTER_ADDL',
                'PAT_COMORBIDITY', NULL, NULL,
                'CLOB', NULL, 4000,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'L_MASTER_ADDL',
                'PAT_COMP_PT_CODE', NULL, NULL,
                'CLOB', NULL, 4000,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'L_MASTER_ADDL',
                'PAT_ANON_PT_CODE', NULL, NULL,
                'CLOB', NULL, 4000,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'L_MASTER_ADDL',
                'PAT_PAST_DISEASE', NULL, NULL,
                'CLOB', NULL, 4000,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'L_MASTER_ADDL',
                'PAT_OTHER_TRTMNT_HIST', NULL, NULL,
                'CLOB', NULL, 4000,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_REPORTERS_ADDL',
                'PRIM_CORRESPOND_SOURCE', NULL, NULL,
                'NUMBER', NULL, 22,
                0, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'L_MASTER_ADDL',
                'TASK_DESC', NULL, NULL,
                'VARCHAR2', NULL, 10000,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'L_MASTER_ADDL',
                'PARTNER_NAME', NULL, NULL,
                'VARCHAR2', NULL, 4000,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_MASTER_ADDL',
                'DELETED_DEACTIVATED', NULL, NULL,
                'VARCHAR2', NULL, 4000,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_MASTER_ADDL',
                'LOCK_DATE_GLOBAL', NULL, NULL,
                'DATE', NULL, NULL,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'L_MASTER_ADDL',
                'LOCK_DATE_LOCAL', NULL, NULL,
                'DATE', NULL, NULL,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'RPT_REG_REPORTS_ADDL',
                'FLAG_PMDA', NULL, NULL,
                'NUMBER', NULL, 22,
                0, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_MASTER_ADDL',
                'PMDA_SUBMISSIONS', NULL, NULL,
                'VARCHAR2', NULL, 10000,
                NULL, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_MASTER_ADDL',
                'OVERDOSE_FLAG', NULL, NULL,
                'NUMBER', NULL, 22,
                0, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_MASTER_ADDL',
                'DRUG_INTERACTION_FLAG', NULL, NULL,
                'NUMBER', NULL, 22,
                0, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_MASTER_ADDL',
                'DEATH_FLAG', NULL, NULL,
                'NUMBER', NULL, 22,
                0, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_MASTER_ADDL',
                'RENAL_MEDICATION_FLAG', NULL, NULL,
                'NUMBER', NULL, 22,
                0, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_MASTER_ADDL',
                'HEPTIC_MEDICAL_CONDITIONS_FLAG', NULL, NULL,
                'NUMBER', NULL, 22,
                0, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_MASTER_ADDL',
                'PREGNANCY_FLAG', NULL, NULL,
                'NUMBER', NULL, 22,
                0, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   INSERT INTO pvr_addl_app_src_tgt
               (src_table_name, src_column_name, tgt_table_name,
                tgt_column_name, tgt_column_id, tgt_col_pk_position,
                tgt_col_data_type, tgt_col_char_used, tgt_col_data_length,
                tgt_col_data_default, tgt_col_expression, decode_flag,
                decode_view_name, key_value_flag, key_value_flag_view_name,
                hidden, tgt_col_cstm_data_type
               )
        VALUES (NULL, NULL, 'C_MASTER_ADDL',
                'FATAL_FLAG', NULL, NULL,
                'NUMBER', NULL, 22,
                0, NULL, NULL,
                NULL, NULL, NULL,
                'N', NULL
               );

   COMMIT;
END;
/