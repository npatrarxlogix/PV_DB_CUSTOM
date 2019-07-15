BEGIN
   INSERT INTO source_table_master_base
               (case_join_equi_outer, case_join_order, has_enterprise_id,
                is_deleted, rank_column, table_alias, table_name,
                table_type, versioned_data, deleted, primary_key
               )
        VALUES ('O', 4, 1,
                0, NULL, 'lpuda', 'V_J_PMDA_GENERAL_UD_ADDL',
                'C', 'V', NULL, 'CASE_ID,TENANT_ID,VERSION_NUM'
               );

   INSERT INTO source_table_master_base
               (case_join_equi_outer, case_join_order, has_enterprise_id,
                is_deleted, rank_column, table_alias, table_name, table_type,
                versioned_data, deleted, primary_key
               )
        VALUES ('O', 4, 1,
                0, NULL, 'cpuda', 'C_PMDA_GENERAL_UD_ADDL', 'C',
                'V', NULL, 'CASE_ID,TENANT_ID,VERSION_NUM'
               );

   INSERT INTO source_table_master_base
               (case_join_equi_outer, case_join_order, has_enterprise_id,
                is_deleted, rank_column, table_alias, table_name, table_type,
                versioned_data, deleted,
                primary_key
               )
        VALUES ('O', 6, 1,
                0, NULL, 'gsect', 'GTT_SECTOR', 'C',
                'V', NULL,
                'CASE_ID,TENANT_ID,VERSION_NUM,PROD_REC_NUM,AUTH_ID'
               );

   INSERT INTO source_table_master_base
               (has_enterprise_id, is_deleted, table_alias, table_name,
                table_type
               )
        VALUES (1, 0, 'cau', 'VW_LCAU_CONS_CAUSALITY',
                'L'
               );

   INSERT INTO source_table_master_base
               (has_enterprise_id, is_deleted, table_alias, table_name,
                table_type
               )
        VALUES (1, 0, 'cauj', 'VW_LCAU_CONS_CAUSALITY_J',
                'L'
               );

   INSERT INTO source_table_master_base
               (case_join_equi_outer, case_join_order, has_enterprise_id,
                is_deleted, rank_column, table_alias, table_name, table_type,
                versioned_data, deleted, primary_key
               )
        VALUES ('O', NULL, 1,
                0, NULL, 'vpmrc', 'VW_PMDA_RPT_CATEGORY', 'L',
                NULL, NULL, NULL
               );

   INSERT INTO source_table_master_base
               (case_join_equi_outer, case_join_order, has_enterprise_id,
                is_deleted, rank_column, table_alias, table_name, table_type,
                versioned_data, deleted, primary_key
               )
        VALUES ('O', NULL, 1,
                0, NULL, 'vpmrl', 'VW_PMDA_RPT_CATEGORY_J', 'L',
                NULL, NULL, NULL
               );

insert into source_table_master_base(CASE_JOIN_EQUI_OUTER, CASE_JOIN_ORDER, HAS_ENTERPRISE_ID, IS_DELETED, TABLE_ALIAS, TABLE_NAME, TABLE_TYPE, VERSIONED_DATA, DELETED, PRIMARY_KEY)
values(NULL,NULL,1,0,'ecrsmt','VW_ECRS_MEDDRA_TERM','L',NULL,NULL,NULL);
insert into source_table_master_base(CASE_JOIN_EQUI_OUTER, CASE_JOIN_ORDER, HAS_ENTERPRISE_ID, IS_DELETED, TABLE_ALIAS, TABLE_NAME, TABLE_TYPE, VERSIONED_DATA, DELETED, PRIMARY_KEY)
values(NULL,NULL,1,0,'ecrsrp','VW_ECRS_RISK_PURPOSE','L',NULL,NULL,NULL);
insert into source_table_master_base(CASE_JOIN_EQUI_OUTER, CASE_JOIN_ORDER, HAS_ENTERPRISE_ID, IS_DELETED, TABLE_ALIAS, TABLE_NAME, TABLE_TYPE, VERSIONED_DATA, DELETED, PRIMARY_KEY)
values(NULL,NULL,1,0,'ecrsnc','VW_ECRS_NON_COMPOUND','L',NULL,NULL,NULL);
insert into source_table_master_base(CASE_JOIN_EQUI_OUTER, CASE_JOIN_ORDER, HAS_ENTERPRISE_ID, IS_DELETED, TABLE_ALIAS, TABLE_NAME, TABLE_TYPE, VERSIONED_DATA, DELETED, PRIMARY_KEY)
values(NULL,NULL,1,0,'ecrsst','VW_ECRS_STOI','L',NULL,NULL,NULL);

   INSERT INTO SOURCE_TABLE_MASTER_BASE
            (has_enterprise_id, is_deleted, table_alias, table_name,
             table_type
            )
        VALUES (0, 0, 'vdhdr', 'V_IND_NUMBER',
             'L'
            );
   INSERT INTO SOURCE_TABLE_MASTER_BASE
            (has_enterprise_id, is_deleted, table_alias, table_name,
             table_type
            )
        VALUES (0, 0, 'vdct', 'V_DINF_CLINICAL_TRIAL_IMP01',
             'L'
            );
   INSERT INTO SOURCE_TABLE_MASTER_BASE
            (has_enterprise_id, is_deleted, table_alias, table_name,
             table_type
            )
        VALUES (0, 0, 'vevs', 'V_ESB_V_STUDY',
             'L'
            );

   COMMIT;
END;
/