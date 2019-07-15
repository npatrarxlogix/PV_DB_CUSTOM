CREATE OR REPLACE PROCEDURE p_check_custom_e2b_jobs ( pi_etl_mode IN VARCHAR2 )
AS
   ln_cnt       NUMBER;
BEGIN
IF pi_etl_mode='INIT'
THEN
   LOOP
      SELECT etl_value
        INTO ln_cnt
        FROM pvr_etl_constants
       WHERE etl_key = 'FLAG_ESM_TABLES_UPDATE';

      IF ln_cnt <> 1
      THEN
         DBMS_LOCK.sleep ( 900 );
      ELSE
         EXIT;
      END IF;
   END LOOP;
END IF;   
END;
/