CREATE OR REPLACE PROCEDURE P_CALL_E2B_TABLES_UPDATE ( pi_etl_mode IN VARCHAR2 )
AS
BEGIN
   IF pi_etl_mode = 'INIT'
   THEN
      BEGIN
         DBMS_SCHEDULER.create_job
            ( job_name        => 'P_UPDATE_E2B_TABLES_JOB',
              job_action      => 'BEGIN p_update_e2b_tables; 
                                              END;',
              job_type        => 'PLSQL_BLOCK',
              enabled         => TRUE
            );
      END;
   ELSE
      EXECUTE IMMEDIATE 'begin p_update_e2b_tables; end;';
   END IF;
END;
/