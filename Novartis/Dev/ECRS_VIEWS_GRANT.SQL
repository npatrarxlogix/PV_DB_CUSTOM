------------------------------------------------------
  -- GRANTS FOR ECRS VIEWS FROM PVD MART TO DB APP
------------------------------------------------------

GRANT   SELECT ON vw_ecrs_meddra_term TO &userrx. with grant option;
GRANT   SELECT ON vw_ecrs_addl TO &userrx.;
GRANT   SELECT ON vw_ecrs_risk_purpose TO &userrx.;
GRANT   SELECT ON vw_ecrs_non_compound TO &userrx.;
GRANT   SELECT ON vw_ecrs_stoi TO &userrx. with grant option;
GRANT   SELECT ON vw_ecrs_risk_purpose_drop TO &userrx.;

------------------------------------------------------
  -- GRANTS FOR ECRS VIEWS FROM PVD MART TO PVD STAGE
------------------------------------------------------

GRANT   SELECT ON ecrs_addl TO &userst.;
GRANT   SELECT ON vw_ecrs_addl TO &userst.;