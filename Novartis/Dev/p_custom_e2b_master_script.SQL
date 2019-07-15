CREATE OR REPLACE PROCEDURE p_custom_e2b_master_script ( pi_etl_mode VARCHAR2 )
AS
   lvc_table_name   VARCHAR2 ( 50 )  := '';
   lvc_proc_name    VARCHAR2 ( 100 ) := '';
   ln_cnt           NUMBER;
   ln_proc_id       NUMBER;
BEGIN
   SELECT proc_id
     INTO ln_proc_id
     FROM pvd_etl_procedures
    WHERE execution_status = 1;

   IF ln_proc_id = 200
   THEN
      IF pi_etl_mode = 'INIT'
      THEN

         FOR i IN ( SELECT 'E2B_INFO' AS table_name
                     FROM DUAL
                   UNION
                   SELECT 'MESSAGES_ADDL' AS table_name
                     FROM DUAL
                   UNION
                   SELECT 'ACKNOWLEDGMENT_ADDL' AS table_name
                     FROM DUAL 
				   UNION
                   SELECT 'ACTIVESUBSTANCE_ADDL' AS table_name
                     FROM DUAL)
         LOOP
            lvc_table_name    := i.table_name;
            lvc_proc_name     := 'P_POP_' || i.table_name;
            DBMS_SCHEDULER.create_job
               ( job_name        => 'POPULATE_' || lvc_table_name,
                 job_action      =>    'BEGIN '
                                    || lvc_proc_name
                                    || '; 
                                              END;',
                 job_type        => 'PLSQL_BLOCK',
                 enabled         => TRUE
               );
         END LOOP;

      ELSE
         NULL;
      END IF;
   ELSIF ln_proc_id = 2600
   THEN
      IF pi_etl_mode = 'INCR'
      THEN
         FOR i IN ( SELECT 'E2B_INFO' AS table_name
                     FROM DUAL
                   UNION
                   SELECT 'MESSAGES_ADDL' AS table_name
                     FROM DUAL
                   UNION
                   SELECT 'ACKNOWLEDGMENT_ADDL' AS table_name
                     FROM DUAL
                   UNION
                   SELECT 'ACTIVESUBSTANCE_ADDL' AS table_name
                     FROM DUAL )
         LOOP
            lvc_proc_name    := 'P_POP_' || i.table_name;

            EXECUTE IMMEDIATE 'BEGIN  ' || lvc_proc_name || '; end;';
         END LOOP;

      END IF;
   END IF;
END;
/