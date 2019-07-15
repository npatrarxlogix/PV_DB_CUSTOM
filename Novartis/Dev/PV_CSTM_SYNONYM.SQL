BEGIN
   EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM v_j_pmda_general_ud_addl FOR &&USERTX..v_j_pmda_general_ud_addl';

   EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM vw_trade_country_j FOR &&USERTX..vw_trade_country_j';

   EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM vw_trade_country FOR &&USERTX..vw_trade_country';
END;
/