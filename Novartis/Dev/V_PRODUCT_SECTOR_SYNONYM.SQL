PROMPT --vw_psur_grp_name
CREATE OR REPLACE VIEW vw_psur_grp_name
AS
   SELECT DISTINCT ORA_HASH (text_attr_4) AS "PSUR_GROUP_ID",
                   text_attr_4 AS "PSUR_GROUP_NAME", lang_id
              FROM pvr_wide_code_list_master
             WHERE code_list_id = 16
               AND fix_view_flag = 1
               AND text_attr_4 IS NOT NULL;

CREATE OR REPLACE VIEW LINK_VIEW_100_202 AS
SELECT DISTINCT psur.psur_group_id AS COL_1, pro.product_id AS col_2,
null as col_3,null as col_4,null as col_5,null as col_6,null as col_7,
null as col_8,null as col_9,null as col_10,pro.selectable as selectable,pro.tenant_id as tenant_id,
pro.lang_id
              FROM vw_psur_grp_name psur JOIN vw_product pro
                   ON (psur.psur_group_name = pro.psur_group_name)
             WHERE pro.selectable = 1;

CREATE OR REPLACE VIEW DISP_VIEW_100 AS
SELECT psur_group_id AS COL_1, psur_group_name AS COL_2, 
null COL_3, null COL_4, null COL_5, null COL_6, null COL_7, null COL_8, null COL_9, null COL_10, selectable, tenant_id, lang_id
     FROM vw_psur_grp_name;

commit;