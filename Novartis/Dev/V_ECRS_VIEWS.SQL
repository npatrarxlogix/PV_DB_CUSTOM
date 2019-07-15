create or replace view vw_ecrs_addl as
WITH ecrs as(
select GENERIC_TRADE, PT_CODE, PT_NAME, SAFETY_TOPIC_OF_INTEREST, LANG_ID, SELECTABLE, TENANT_ID
from (select DISTINCT TRIM(BOTH '_' FROM SUBSTR(REGEXP_REPLACE(REPLACE(GENERIC_NAME,' ',''),'[^[:alnum:]'' '']', NULL),1,12) || '_' 
|| SUBSTR(REGEXP_REPLACE(REPLACE(TRADE_NAME,' ',''),'[^[:alnum:]'' '']', NULL),1,12)) GENERIC_TRADE,
PT_CODE,PT_NAME,SAFETY_TOPIC_OF_INTEREST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID
		from ecrs_addl where COMPOUND_TYPE='COMPOUND' AND DOMAIN_NAME='MEDDRA' AND SEARCH_CRITERIA_DETAILS is null) where generic_trade is not null
)
select upper(GENERIC_TRADE) generic_trade, PT_CODE, PT_NAME, SAFETY_TOPIC_OF_INTEREST, LANG_ID, SELECTABLE, TENANT_ID from ecrs;

create or replace view vw_ecrs_meddra_term as
select a.PT_CODE,a.PT_NAME,a.MEDDRA_TERM,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from ecrs_addl a;

create or replace view vw_ecrs_risk_purpose as
select a.PT_CODE,a.PT_NAME,a.RISK_PURPOSE_LIST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from ecrs_addl a;

create or replace view vw_ecrs_non_compound as
select a.PT_CODE,a.PT_NAME,a.SAFETY_TOPIC_OF_INTEREST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from ecrs_addl a
where a.compound_type = 'NON-COMPOUND';

CREATE OR REPLACE VIEW VW_ECRS_STOI AS
SELECT COMPOUND_TYPE, GENERIC_NAME, TRADE_NAME,SAFETY_TOPIC_OF_INTEREST,MEDDRA_TERM, PT_CODE, PT_NAME,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID FROM ECRS_ADDL;

create or replace view vw_ecrs_risk_purpose_drop as
select 'A1' RISK_PURPOSE_LIST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from dual
union all
select 'A2' RISK_PURPOSE_LIST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from dual
union all
select 'CD' RISK_PURPOSE_LIST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from dual
union all
select 'DS' RISK_PURPOSE_LIST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from dual
union all
select 'ER' RISK_PURPOSE_LIST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from dual
union all
select 'IB' RISK_PURPOSE_LIST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from dual
union all
select 'MI' RISK_PURPOSE_LIST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from dual
union all
select 'OS' RISK_PURPOSE_LIST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from dual
union all
select 'PS' RISK_PURPOSE_LIST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from dual
union all
select 'RM' RISK_PURPOSE_LIST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from dual
union all
select 'SP' RISK_PURPOSE_LIST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from dual
union all
select 'UD' RISK_PURPOSE_LIST,'*' AS LANG_ID,1 AS SELECTABLE,1 AS TENANT_ID from dual;