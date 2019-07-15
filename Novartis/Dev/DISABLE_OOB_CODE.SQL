BEGIN
UPDATE pvr_etl_constants
   SET etl_value = 1
 WHERE etl_key = 'POPULATE_CUSTOM_PBRER_CATEGORY';
COMMIT;
END;
/ 