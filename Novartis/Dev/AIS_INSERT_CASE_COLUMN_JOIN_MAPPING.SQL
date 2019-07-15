BEGIN
   INSERT INTO case_column_join_mapping_base
               (table_name_atm_id, column_name, map_table_name_atm_id,
                map_column_name, is_deleted
               )
        VALUES ('V_J_PMDA_GENERAL_UD_ADDL', 'CASE_ID', 'V_C_IDENTIFICATION',
                'CASE_ID', 0
               );

   INSERT INTO case_column_join_mapping_base
               (table_name_atm_id, column_name, map_table_name_atm_id,
                map_column_name, is_deleted
               )
        VALUES ('C_PMDA_GENERAL_UD_ADDL', 'CASE_ID', 'V_C_IDENTIFICATION',
                'CASE_ID', 0
               );

   INSERT INTO case_column_join_mapping_base
               (column_name, is_deleted, map_column_name,
                map_table_name_atm_id, table_name_atm_id
               )
        VALUES ('CASE_ID', 0, 'CASE_ID',
                'C_PROD_IDENTIFICATION', 'GTT_SECTOR'
               );

   INSERT INTO case_column_join_mapping_base
               (column_name, is_deleted, map_column_name,
                map_table_name_atm_id, table_name_atm_id
               )
        VALUES ('PROD_REC_NUM', 0, 'PROD_REC_NUM',
                'C_PROD_IDENTIFICATION', 'GTT_SECTOR'
               );

   INSERT INTO case_column_join_mapping_base
               (column_name, is_deleted, map_column_name,
                map_table_name_atm_id, table_name_atm_id
               )
        VALUES ('CASE_ID', 0, 'CASE_ID',
                'V_C_IDENTIFICATION', 'GTT_SECTOR'
               );

   INSERT INTO case_column_join_mapping_base
               (column_name, is_deleted, map_column_name,
                map_table_name_atm_id, table_name_atm_id
               )
        VALUES ('CASE_ID', 0, 'CASE_ID',
                'REG_PMDA_AUTH_IDENTIFICATION', 'GTT_SECTOR'
               );

   INSERT INTO case_column_join_mapping_base
               (column_name, is_deleted, map_column_name,
                map_table_name_atm_id, table_name_atm_id
               )
        VALUES ('PROD_REC_NUM', 0, 'PROD_REC_NUM',
                'REG_PMDA_AUTH_IDENTIFICATION', 'GTT_SECTOR'
               );

   INSERT INTO case_column_join_mapping_base
               (column_name, is_deleted, map_column_name,
                map_table_name_atm_id, table_name_atm_id
               )
        VALUES ('AUTH_ID', 0, 'AUTH_ID',
                'REG_PMDA_AUTH_IDENTIFICATION', 'GTT_SECTOR'
               );

   COMMIT;
END;
/