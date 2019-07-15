CREATE OR REPLACE VIEW VW_LEG_GROUP_CSTM AS 
SELECT  a.eg_id, pmh.pt_code,F.EVENT_GROUP_NAME,A.TENANT_ID
  FROM (    SELECT CONNECT_BY_ROOT child_id AS child_id, eg_id,TENANT_ID
              FROM VW_LM_EVENT_GROUP_CHILD
        CONNECT BY PRIOR eg_id = child_id
        UNION
        SELECT eg_id AS child_id, eg_id,TENANT_ID FROM VW_LEG_EVENT_GROUP_NAME) a
       LEFT JOIN VW_LEG_EVENT_GROUP_NAME F
           ON (A.EG_ID=F.EG_ID
               AND A.TENANT_ID=F.TENANT_ID)
       LEFT JOIN VW_LM_EVENT_GROUP_TERMS b
          ON (a.child_id = b.eg_id
          AND A.TENANT_ID=B.TENANT_ID)
       LEFT JOIN PVR_MD_HIERARCHY pmh
          ON (CASE
                 WHEN term_type = 1 THEN pmh.pt_code
                 WHEN term_type = 2 THEN pmh.hlt_code
                 WHEN term_type = 3 THEN pmh.hlgt_code
                 WHEN term_type = 4 THEN pmh.soc_code
              END =
                 CASE
                    WHEN term_type = 1 THEN b.PT_CODE
                    WHEN term_type = 2 THEN b.HLT_CODE
                    WHEN term_type = 3 THEN b.HLGT_CODE
                    WHEN term_type = 4 THEN b.soc_CODE
                 END
             -- AND A.TENANT_ID=PMH.TENANT_ID
              )
 WHERE pmh.pt_code IS NOT NULL AND pmh.MEDDRA_DICT_ID = (SELECT etl_value
  FROM pvr_etl_constants
 WHERE etl_key = 'MEDDRA_DICT_ID')
UNION
SELECT a.eg_id, pt_code,F.EVENT_GROUP_NAME,A.TENANT_ID
  FROM (    SELECT CONNECT_BY_ROOT child_id AS child_id, eg_id,TENANT_ID
              FROM VW_LM_EVENT_GROUP_CHILD
        CONNECT BY PRIOR eg_id = child_id
        UNION
        SELECT eg_id AS child_id, eg_id,TENANT_ID FROM VW_LEG_EVENT_GROUP_NAME) a
      JOIN VW_LEG_EVENT_GROUP_NAME F
      ON(A.EG_ID=F.EG_ID
      AND A.TENANT_ID=F.TENANT_ID)
       JOIN VW_LM_EVENT_GROUP_SMQ b
          ON (a.eg_id = b.eg_id
          AND A.TENANT_ID=B.TENANT_ID)
       JOIN meddra_smq_to_llt_pt_temp c
          ON (c.SMQ_PARENT = b.SMQ_CODE)
 WHERE pt_code IS NOT NULL;