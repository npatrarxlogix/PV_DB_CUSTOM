BEGIN
   UPDATE pvr_src_tgt_tab_col
      SET tgt_col_expression =
             'NVL(PKG_ETL_UTIL.F_GET_CLMW_DECODE(''VW_PRODUCT'',NVL(cp.PRODUCT_ID, cp.PAT_EXPOSURE)),DBMS_LOB.SUBSTR(cp.generic_name,32000,1))'
    WHERE tgt_column_name = 'PRODUCT_NAME_CDR'
      AND tgt_table_name = 'C_PROD_IDENTIFICATION';

   UPDATE pvr_src_tgt_tab_col
      SET tgt_col_expression =
             'NVL(PKG_ETL_UTIL.F_GET_CLMW_DECODE(''VW_PRODUCT_J'',NVL(cp.PRODUCT_ID, cp.PAT_EXPOSURE)),DBMS_LOB.SUBSTR(cp.generic_name_j,32000,1))'
    WHERE tgt_column_name = 'PRODUCT_NAME_CDR'
      AND tgt_table_name = 'L_PROD_IDENTIFICATION';
END;
/