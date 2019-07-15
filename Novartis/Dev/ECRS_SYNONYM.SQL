BEGIN
   EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM vw_ecrs_meddra_term FOR &&USERTX..vw_ecrs_meddra_term';

   EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM vw_ecrs_addl FOR &&USERTX..vw_ecrs_addl';

   EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM vw_ecrs_risk_purpose FOR &&USERTX..vw_ecrs_risk_purpose';

   EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM vw_ecrs_non_compound FOR &&USERTX..vw_ecrs_non_compound';

   EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM vw_ecrs_stoi FOR &&USERTX..vw_ecrs_stoi';

   EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM vw_ecrs_risk_purpose_drop FOR &&USERTX..vw_ecrs_risk_purpose_drop';

   EXECUTE IMMEDIATE 'grant select on vw_ecrs_meddra_term to &USERPVA.';

   EXECUTE IMMEDIATE 'grant select on vw_ecrs_stoi to &USERPVA.';
END;
/