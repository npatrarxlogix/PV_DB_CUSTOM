--TABLE GTT_SECTOR TO BE CREATED IN PVR
CREATE GLOBAL TEMPORARY TABLE gtt_sector
   (        "CASE_ID"         NUMBER,
            "TENANT_ID"     NUMBER,
            "VERSION_NUM"     NUMBER,
            "PROD_REC_NUM"     NUMBER,
            "AUTH_ID"         NUMBER,
            "TRADE_NAME"     VARCHAR2(1000 BYTE),
            "MANU_NAME"     VARCHAR2(1000 BYTE),
            "SECTOR"         VARCHAR2(50 BYTE)
   ) ON COMMIT PRESERVE ROWS;

CREATE INDEX idx_gtt_sector_1 ON gtt_sector (case_id, tenant_id, version_num, prod_rec_num);
CREATE INDEX idx_gtt_sector_2 ON gtt_sector (auth_id);

ALTER TABLE gtt_submissions_addl ADD flag_pmda NUMBER;