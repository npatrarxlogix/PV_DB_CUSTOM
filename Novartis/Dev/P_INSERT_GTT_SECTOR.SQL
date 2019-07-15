--PROCEDURE TO BE INSERTED BEFORE PKG_CREATE_REPORT_SQL.P_MAIQUERY

CREATE OR REPLACE PROCEDURE p_insert_gtt_sector
IS
   l_count         NUMBER;
   l_sql           VARCHAR2 (32000);
   g_report_name   VARCHAR2 (1000);
   g_seq_num       NUMBER;
   g_row_count     NUMBER;
BEGIN
   g_seq_num := app_excp_seq.NEXTVAL;

   SELECT param_value
     INTO g_report_name
     FROM gtt_report_input_params
    WHERE param_key = 'REPORT_NAME';

   pkg_app_util.p_insert_app_excp (g_seq_num,
                                   g_report_name,
                                   'GTT_SECTOR INSERT',
                                   'p_insert_gtt_sector',
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   1,
                                   NULL,
                                   NULL
                                  );

   SELECT COUNT (*)
     INTO l_count
     FROM gtt_sector;

   IF l_count = 0
   THEN
      INSERT INTO gtt_sector
                  (case_id, tenant_id, version_num, prod_rec_num, auth_id,
                   trade_name, manu_name, sector)
         SELECT a.case_id, a.tenant_id, a.version_num, a.prod_rec_num,
                a.auth_id, b.trade_name, c.manu_name,
                CASE
                   WHEN c.manufacturer_id IN
                             (10087, 200000035, 202000608, 202000609)
                      THEN 'NPKK'
                   WHEN c.manufacturer_id = 10090
                      THEN 'SKK'
                   WHEN c.manufacturer_id = 202000610
                      THEN 'ALJ'
                END sector
           FROM reg_pmda_auth_identification a JOIN gtt_versions gtt
                ON (    a.case_id = gtt.case_id
                    AND a.tenant_id = gtt.tenant_id
                    AND a.version_num = gtt.version_num
                   )
                LEFT OUTER JOIN vw_trade_name_j b ON (a.auth_id = b.license_id and b.deleted is null
                                                     )
                LEFT OUTER JOIN vw_lm_manu_name_j c
                ON (b.manufacturer_id = c.manufacturer_id)
                ;
   END IF;

   g_row_count := SQL%ROWCOUNT;
   pkg_app_util.p_update_sql_count (g_seq_num, SYSTIMESTAMP, g_row_count);
END;
/