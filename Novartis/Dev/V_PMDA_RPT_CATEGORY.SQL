CREATE OR REPLACE VIEW vw_pmda_rpt_category_j
AS
   SELECT code_id AS "RPT_CATEGORY_ID",
          description || ' - ' || value_attr_4 AS "RPT_CATEGORY",
          TO_NUMBER (value_attr_1) AS "REPORT_FORM_ID",
          TO_NUMBER (value_attr_2) AS "E2B_CODE",
          TO_NUMBER (value_attr_3) AS "CATEGORY_FILTER",
          value_attr_4 AS "DESCRIPTION", TO_NUMBER (value_attr_5)
                                                                 AS "DISPLAY",
          TO_NUMBER (value_attr_6) AS "PROTECTED", lang_id, selectable,
          tenant_id
     FROM pvr_code_list_master
    WHERE code_list_id = 90 AND fix_view_flag = 1;

CREATE OR REPLACE VIEW vw_pmda_rpt_category
AS
   SELECT code_id AS "RPT_CATEGORY_ID",
          description || ' - ' || value_attr_4 AS "RPT_CATEGORY",
          TO_NUMBER (value_attr_1) AS "REPORT_FORM_ID",
          TO_NUMBER (value_attr_2) AS "E2B_CODE",
          TO_NUMBER (value_attr_3) AS "CATEGORY_FILTER",
          value_attr_4 AS "DESCRIPTION", TO_NUMBER (value_attr_5)
                                                                 AS "DISPLAY",
          TO_NUMBER (value_attr_6) AS "PROTECTED", lang_id, selectable,
          tenant_id
     FROM pvr_code_list_master
    WHERE code_list_id = 3 AND fix_view_flag = 1;

GRANT SELECT ON vw_pmda_rpt_category TO &userrx.;
GRANT SELECT ON vw_pmda_rpt_category_j TO &userrx.;