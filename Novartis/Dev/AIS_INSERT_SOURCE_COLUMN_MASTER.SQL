BEGIN
   INSERT INTO source_column_master_base
               (report_item, column_name, column_type, concatenated_field,
                lm_decode_column, lm_join_column, lm_join_equi_outer,
                lm_table_name_atm_id, primary_key_id, table_name_atm_id,
                is_deleted, lang_id
               )
        VALUES ('CM_POP_MARKETING_PROGRAM', 'POP_MARKETING', 'V', NULL,
                NULL, NULL, NULL,
                NULL, NULL, 'C_MASTER_ADDL',
                0, 'en'
               );

   INSERT INTO source_column_master_base
               (table_name_atm_id, column_name, column_type, report_item,
                lm_table_name_atm_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, decode_column, concatenated_field,
                lang_id, primary_key_id, is_deleted, deleted
               )
        VALUES ('C_MASTER_ADDL', 'PMS_STUDIES', 'N', 'CM_PMS_STUDIES',
                'VW_CLP_STATE_YN', 'STATE_YN', 'ID',
                'O', NULL, NULL,
                'en', NULL, 0, NULL
               );

   INSERT INTO source_column_master_base
               (report_item, column_name, column_type, concatenated_field,
                lm_decode_column, lm_join_column, lm_join_equi_outer,
                lm_table_name_atm_id, primary_key_id, table_name_atm_id,
                is_deleted, lang_id
               )
        VALUES ('CM_MOST_RELEVANT_EVENT', 'FLAG_MOST_REL_AE', 'N', NULL,
                'STATE_YN', 'ID', 'O',
                'VW_CLP_STATE_YN', NULL, 'C_EVENT_ADDL',
                0, 'en'
               );

   INSERT INTO source_column_master_base
               (report_item, column_name, column_type, concatenated_field,
                lm_decode_column, lm_join_column, lm_join_equi_outer,
                lm_table_name_atm_id, primary_key_id, table_name_atm_id,
                is_deleted, lang_id
               )
        VALUES ('CM_DIAGNOSIS_SYMPTOM', 'diag_to_symp_pt', 'V', NULL,
                NULL, NULL, NULL,
                NULL, NULL, 'C_EVENT_ADDL',
                0, 'en'
               );

/*INSERT INTO SOURCE_COLUMN_MASTER_BASE
            (column_name, column_type, is_deleted, lang_id, lm_decode_column,
             lm_join_column, lm_join_equi_outer, lm_table_name_atm_id,
             report_item, table_name_atm_id
            )
     VALUES ('STUDY_NUMBER', 'N', 0, 'en', 'HA_DOC_REFERENCE',
             'CLINICAL_TRIAL', 'O', 'V_IND_NUMBER',
             'CS_IMPACT_IND_NUMBER', 'C_STUDY_IDENTIFICATION_FU'
            );
INSERT INTO SOURCE_COLUMN_MASTER_BASE
            (column_name, column_type, is_deleted, lang_id, lm_decode_column,
             lm_join_column, lm_join_equi_outer, lm_table_name_atm_id,
             report_item, table_name_atm_id
            )
     VALUES ('STUDY_NUMBER', 'V', 0, '*', 'CASE_NON_INTEGRATED_IN',
             'TRIAL_ALIAS_CODE', 'O', 'V_DINF_CLINICAL_TRIAL_IMP01',
             'CS_IMPACT_NON_INTEGRATED', 'C_STUDY_IDENTIFICATION_FU'
            );
INSERT INTO SOURCE_COLUMN_MASTER_BASE
            (column_name, column_type, is_deleted, lang_id, lm_decode_column,
             lm_join_column, lm_join_equi_outer, lm_table_name_atm_id,
             report_item, table_name_atm_id
            )
     VALUES ('STUDY_NUMBER', 'V', 0, '*', 'STUDY_CODE_NCC',
             'STUDY_CODE_ALIAS', 'O', 'V_ESB_V_STUDY',
             'CS_IMPACT_STUDY_NCC_CODES', 'C_STUDY_IDENTIFICATION'
            );
INSERT INTO SOURCE_COLUMN_MASTER_BASE
            (column_name, column_type, is_deleted, lang_id, lm_decode_column,
             lm_join_column, lm_join_equi_outer, lm_table_name_atm_id,
             report_item, table_name_atm_id
            )
     VALUES ('PROJECT', 'V', 0, '*', 'PROJECT_CODE_NCC',
             'PROJECT_CODE_ALIAS', 'O', 'V_ESB_V_STUDY',
             'CS_IMPACT_PROJECT_NCC_CODES', 'C_STUDY_IDENTIFICATION'
            );*/
   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('UD_TEXT_6_J ', 'V', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'LPUDA_UD_TEXT_6_J', 'V_J_PMDA_GENERAL_UD_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('UD_TEXT_5_J ', 'V', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'LPUDA_UD_TEXT_5_J', 'V_J_PMDA_GENERAL_UD_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('AUTH_ID', 'N', NULL, 0,
                '*', 'LICENSE_TYPE', 'LICENSE_ID',
                'O', 'VW_TRADE_COUNTRY', NULL,
                'CEA_LICENSE_TYPE', 'C_PROD_AE_AUTH_LABELNESS_FU', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column,
                deleted
               )
        VALUES ('AUTH_ID', 'N', NULL, 0,
                '*', 'LICENSE_TYPE', 'LICENSE_ID',
                'O', 'VW_TRADE_COUNTRY_J', NULL,
                'CEA_LICENSE_TYPE_J', 'V_J_PROD_AE_AUTH_LABELNESS_FU', NULL,
                NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('UD_TEXT_1_J', 'V', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'CASE_PAT_INFO_UD_TEXT_1_J', 'V_J_PAT_INFO_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('UD_DATE_1 ', 'D', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'CPUDA_UD_DATE_1', 'C_PMDA_GENERAL_UD_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('UD_DATE_2 ', 'D', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'CPUDA_UD_DATE_2', 'C_PMDA_GENERAL_UD_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, is_deleted, lang_id,
                lm_decode_column, lm_join_column, lm_join_equi_outer,
                lm_table_name_atm_id, report_item, table_name_atm_id
               )
        VALUES ('SUSP_GENERIC_NAME', 'C', 0, '*',
                NULL, NULL, NULL,
                NULL, 'CPRODJ_SUSP_GENERIC_LIST_J', 'V_J_PRODUCT_ADDL'
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, is_deleted, lang_id,
                lm_decode_column, lm_join_column, lm_join_equi_outer,
                lm_table_name_atm_id, report_item, table_name_atm_id
               )
        VALUES ('CONC_GENERIC_NAME', 'C', 0, '*',
                NULL, NULL, NULL,
                NULL, 'CPRODJ_CONC_GENERIC_LIST_J', 'V_J_PRODUCT_ADDL'
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('PAT_COMP_PT_CODE', 'C', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'CPATI_PAT_COMP_PT_CODE_J', 'V_J_MASTER_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('SECTOR', 'V', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'GSECT_SECTOR', 'GTT_SECTOR', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('PRIM_CORRESPOND_SOURCE', 'N', NULL, 0,
                '*', 'STATE_YN', 'ID',
                'O', 'VW_CLP_STATE_YN', NULL,
                'CR_PRIM_CORR_SOURCE', 'C_REPORTERS_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('PRIM_CORRESPOND_SOURCE', 'N', NULL, 0,
                '*', 'STATE_YN', 'ID',
                'O', 'VW_CLP_STATE_YN_J', NULL,
                'CR_PRIM_CORR_SOURCE_J', 'C_REPORTERS_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('TASK_DESC', 'V', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'VCMAD_TASK_COMMENT_DESC_J', 'V_J_MASTER_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('PARTNER_NAME', 'V', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'VCMAD_PARTNER_NAME_J', 'V_J_MASTER_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('DELETED_DEACTIVATED', 'V', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'VCMAD_DELETED_DEACTIVATED_J', 'C_MASTER_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('LOCK_DATE_GLOBAL', 'D', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'VCMAD_LOCK_DATE_GLOBAL_J', 'C_MASTER_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('LOCK_DATE_LOCAL', 'D', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'VCMAD_LOCK_DATE_LOCAL_J', 'V_J_MASTER_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, is_deleted, lang_id,
                lm_decode_column, lm_join_column, lm_join_equi_outer,
                lm_table_name_atm_id, report_item, table_name_atm_id
               )
        VALUES ('FLAG_PMDA', 'N', 0, '*',
                'STATE_YN', 'ID', 'O',
                'VW_CLP_STATE_YN', 'RRA_PMDA_FLAG', 'GTT_SUBMISSIONS_ADDL'
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, is_deleted, lang_id,
                lm_decode_column, lm_join_column, lm_join_equi_outer,
                lm_table_name_atm_id, report_item, table_name_atm_id
               )
        VALUES ('FLAG_PMDA', 'N', 0, '*',
                'STATE_YN', 'ID', 'O',
                'VW_CLP_STATE_YN_J', 'RRA_PMDA_FLAG_J', 'GTT_SUBMISSIONS_ADDL'
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('PMDA_SUBMISSIONS', 'V', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'VCMAD_PMDA_SUBMISSIONS_J', 'C_MASTER_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('PAT_COMORBIDITY', 'C', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'CPATI_PAT_COMORBIDITY_J', 'V_J_MASTER_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('PAT_ANON_PT_CODE', 'C', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'CPATI_PAT_ANON_PT_CODE_J', 'V_J_MASTER_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('PAT_PAST_DISEASE', 'C', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'CPATI_PAT_PAST_DISEASE_J', 'V_J_MASTER_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column,
                deleted
               )
        VALUES ('PAT_OTHER_TRTMNT_HIST_PT_CODE', 'C', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'CPATI_OTHER_TRTMNT_HIST_PT_CODE_J', 'V_J_MASTER_ADDL', NULL,
                NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, concatenated_field, is_deleted,
                lang_id, lm_decode_column, lm_join_column,
                lm_join_equi_outer, lm_table_name_atm_id, primary_key_id,
                report_item, table_name_atm_id, decode_column, deleted
               )
        VALUES ('PAT_OTHER_TRTMNT_HIST', 'C', NULL, 0,
                '*', NULL, NULL,
                NULL, NULL, NULL,
                'CPATI_PAT_OTHER_TRTMNT_HIST_J', 'V_J_MASTER_ADDL', NULL, NULL
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, is_deleted, lang_id,
                lm_decode_column, lm_join_column, lm_join_equi_outer,
                lm_table_name_atm_id, report_item, table_name_atm_id
               )
        VALUES ('UD_NUMBER_9', 'N', 0, '*',
                'DESCRIPTION', 'ID', 'O',
                'VW_LUDV_DESC', 'CPUDA_UD_NUMBER_9', 'C_PMDA_GENERAL_UD_ADDL'
               );

   INSERT INTO source_column_master_base
               (column_name, column_type, is_deleted, lang_id,
                lm_decode_column, lm_join_column, lm_join_equi_outer,
                lm_table_name_atm_id, report_item,
                table_name_atm_id
               )
        VALUES ('UD_NUMBER_9', 'N', 0, '*',
                'DESCRIPTION', 'ID', 'O',
                'VW_LUDV_DESC_J', 'CPUDA_UD_NUMBER_9_J',
                'C_PMDA_GENERAL_UD_ADDL'
               );

   UPDATE source_column_master_base
      SET column_name = 'UD_TEXT_1_j'
    WHERE table_name_atm_id = 'V_J_EVENT_ADDL' AND column_name = 'UD_TEXT_1';

   UPDATE source_column_master_base
      SET column_name = 'UD_TEXT_1_J'
    WHERE table_name_atm_id = 'V_J_EVENT_ADDL' AND column_name = 'UD_TEXT_1';

   UPDATE source_column_master_base
      SET lm_decode_column = 'CAUSALITY',
          lm_join_column = 'CAUSALITY_ID',
          lm_table_name_atm_id = 'VW_LCAU_CONS_CAUSALITY'
    WHERE report_item = 'DCPE_CONSER_REPORTABILITY';

   UPDATE source_column_master_base
      SET lm_decode_column = 'CAUSALITY',
          lm_join_column = 'CAUSALITY_ID',
          lm_table_name_atm_id = 'VW_LCAU_CONS_CAUSALITY_J'
    WHERE report_item = 'DCPE_CONSER_REPORTABILITY_J';

   UPDATE source_column_master_base
      SET lm_decode_column = 'RPT_CATEGORY',
          lm_join_column = 'RPT_CATEGORY_ID',
          lm_join_equi_outer = 'O',
          lm_table_name_atm_id = 'VW_PMDA_RPT_CATEGORY',
          decode_column = NULL
    WHERE report_item = 'RPMAI_REPORT_TYPE_ID';

   UPDATE source_column_master_base
      SET lm_decode_column = 'RPT_CATEGORY',
          lm_join_column = 'RPT_CATEGORY_ID',
          lm_join_equi_outer = 'O',
          lm_table_name_atm_id = 'VW_PMDA_RPT_CATEGORY_J',
          decode_column = NULL
    WHERE report_item = 'RPMAI_REPORT_TYPE_ID_J';

INSERT INTO source_column_master_base (COLUMN_NAME, COLUMN_TYPE, CONCATENATED_FIELD, IS_DELETED, LANG_ID, LM_DECODE_COLUMN, LM_JOIN_COLUMN, LM_JOIN_EQUI_OUTER, 
LM_TABLE_NAME_ATM_ID, REPORT_ITEM, TABLE_NAME_ATM_ID)
VALUES('MDR_AE_PT_CODE','N',NULL,0,'*','MEDDRA_TERM','PT_CODE','O','VW_ECRS_MEDDRA_TERM','ECRS_MEDDRA_TERM','C_AE_IDENTIFICATION');
INSERT INTO source_column_master_base (COLUMN_NAME, COLUMN_TYPE, CONCATENATED_FIELD, IS_DELETED, LANG_ID, LM_DECODE_COLUMN, LM_JOIN_COLUMN, LM_JOIN_EQUI_OUTER, 
LM_TABLE_NAME_ATM_ID, REPORT_ITEM, TABLE_NAME_ATM_ID)
VALUES('MDR_AE_PT_CODE','N',NULL,0,'*','RISK_PURPOSE_LIST','PT_CODE','O','VW_ECRS_RISK_PURPOSE','ECRS_RISK_PURPOSE','C_AE_IDENTIFICATION');
INSERT INTO source_column_master_base (COLUMN_NAME, COLUMN_TYPE, CONCATENATED_FIELD, IS_DELETED, LANG_ID, LM_DECODE_COLUMN, LM_JOIN_COLUMN, LM_JOIN_EQUI_OUTER, 
LM_TABLE_NAME_ATM_ID, REPORT_ITEM, TABLE_NAME_ATM_ID)
VALUES('MDR_AE_PT_CODE','N',NULL,0,'*','PT_NAME','PT_CODE','O','VW_ECRS_NON_COMPOUND','ECRS_NON_COMPOUND','C_AE_IDENTIFICATION');
INSERT INTO source_column_master_base (COLUMN_NAME, COLUMN_TYPE, CONCATENATED_FIELD, IS_DELETED, LANG_ID, LM_DECODE_COLUMN, LM_JOIN_COLUMN, LM_JOIN_EQUI_OUTER, 
LM_TABLE_NAME_ATM_ID, REPORT_ITEM, TABLE_NAME_ATM_ID)
VALUES('MDR_AE_PT_CODE','N',NULL,0,'*','SAFETY_TOPIC_OF_INTEREST','PT_CODE','O','VW_ECRS_STOI','ECRS_SAFETY_TOPIC_OF_INTEREST','C_AE_IDENTIFICATION');

INSERT INTO SOURCE_COLUMN_MASTER_BASE
            (column_name, column_type, is_deleted, lang_id, lm_decode_column,
             lm_join_column, lm_join_equi_outer, lm_table_name_atm_id,
             report_item, table_name_atm_id
            )
     VALUES ('STUDY_NUMBER', 'N', 0, 'en', 'HA_DOC_REFERENCE',
             'CLINICAL_TRIAL', 'O', 'V_IND_NUMBER',
             'CS_IMPACT_IND_NUMBER', 'C_STUDY_IDENTIFICATION_FU'
            );
INSERT INTO SOURCE_COLUMN_MASTER_BASE
            (column_name, column_type, is_deleted, lang_id, lm_decode_column,
             lm_join_column, lm_join_equi_outer, lm_table_name_atm_id,
             report_item, table_name_atm_id
            )
     VALUES ('STUDY_NUMBER', 'V', 0, '*', 'CASE_NON_INTEGRATED_IN',
             'TRIAL_ALIAS_CODE', 'O', 'V_DINF_CLINICAL_TRIAL_IMP01',
             'CS_IMPACT_NON_INTEGRATED', 'C_STUDY_IDENTIFICATION_FU'
            );
INSERT INTO SOURCE_COLUMN_MASTER_BASE
            (column_name, column_type, is_deleted, lang_id, lm_decode_column,
             lm_join_column, lm_join_equi_outer, lm_table_name_atm_id,
             report_item, table_name_atm_id
            )
     VALUES ('STUDY_NUMBER', 'V', 0, '*', 'STUDY_CODE_NCC',
             'STUDY_CODE_ALIAS', 'O', 'V_ESB_V_STUDY',
             'CS_IMPACT_STUDY_NCC_CODES', 'C_STUDY_IDENTIFICATION'
            );
INSERT INTO SOURCE_COLUMN_MASTER_BASE
            (column_name, column_type, is_deleted, lang_id, lm_decode_column,
             lm_join_column, lm_join_equi_outer, lm_table_name_atm_id,
             report_item, table_name_atm_id
            )
     VALUES ('PROJECT', 'V', 0, '*', 'PROJECT_CODE_NCC',
             'PROJECT_CODE_ALIAS', 'O', 'V_ESB_V_STUDY',
             'CS_IMPACT_PROJECT_NCC_CODES', 'C_STUDY_IDENTIFICATION'
            );

   COMMIT;
END;
/