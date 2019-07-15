create or replace PROCEDURE p_ecrs_field_update IS
    LV_SOURCE_TABLE_MASTER      SOURCE_TABLE_MASTER_BASE%ROWTYPE;
    LV_SOURCE_COLUMN_MASTER     SOURCE_COLUMN_MASTER_BASE%ROWTYPE;
    LV_RPT_FIELD                RPT_FIELD_BASE%ROWTYPE;
    LV_PVR_RPT_FIELD_LABEL_F    PVR_RPT_FIELD_LABEL_BASE%ROWTYPE;
    LV_PVR_RPT_FIELD_LABEL_DROP PVR_RPT_FIELD_LABEL_BASE%ROWTYPE;
    LVC_APP_USER                VARCHAR2(100);
    LN_ML_FLAG                  NUMBER;
    V_SQL                       VARCHAR2(4000);
    LVC_VIEW_SQL                VARCHAR2(4000);
    LVC_AGG_COL                 VARCHAR2(4000);
    LVC_TABLE_NAME              VARCHAR2(50);
    V_INC                       NUMBER := 0;	
BEGIN

	SELECT
        *
    INTO LV_SOURCE_TABLE_MASTER
    FROM
        SOURCE_TABLE_MASTER_BASE
    WHERE
        TABLE_NAME = 'VW_ECRS_NON_COMPOUND'
        ;

    SELECT
        *
    INTO LV_SOURCE_COLUMN_MASTER
    FROM
        SOURCE_COLUMN_MASTER_BASE
    WHERE
        TABLE_NAME_ATM_ID = 'C_AE_IDENTIFICATION'
        AND COLUMN_NAME = 'MDR_AE_PT_CODE'
        AND REPORT_ITEM = 'ECRS_NON_COMPOUND'
        ;

    SELECT
        *
    INTO LV_RPT_FIELD
    FROM
        RPT_FIELD_BASE
    WHERE
        SOURCE_COLUMN_MASTER_ID = 'ECRS_NON_COMPOUND';

    SELECT
        *
    INTO LV_PVR_RPT_FIELD_LABEL_F
    FROM
        PVR_RPT_FIELD_LABEL_BASE
    WHERE
        CODE LIKE '%ecrsNonCompound%'
        AND LOC = '*';

    SELECT
        *
    INTO LV_PVR_RPT_FIELD_LABEL_DROP
    FROM
        PVR_RPT_FIELD_LABEL_BASE
    WHERE
        CODE LIKE '%vwEcrsNonCompound'
        AND LOC = '*';

    FOR I IN (
        select DISTINCT UPPER(GENERIC_TRADE) GENERIC_TRADE from vw_ecrs_addl
    ) LOOP

	    EXECUTE IMMEDIATE ('CREATE OR REPLACE VIEW VW_' || I.GENERIC_TRADE 
                           || ' AS SELECT * FROM VW_ECRS_ADDL WHERE GENERIC_TRADE =''' || I.GENERIC_TRADE || '''' || '');

	    LV_SOURCE_TABLE_MASTER.TABLE_ALIAS := 'ecrs'
		                                      || V_INC;
		LV_SOURCE_TABLE_MASTER.TABLE_NAME := 'VW_'
                                             || I.GENERIC_TRADE;

        LV_SOURCE_COLUMN_MASTER.REPORT_ITEM := 'ECRS_'
                                               || I.GENERIC_TRADE
                                               || '_COMPOUND';

        LV_SOURCE_COLUMN_MASTER.LM_TABLE_NAME_ATM_ID := 'VW_'
                                                        || I.GENERIC_TRADE;
        LV_RPT_FIELD.NAME := 'ecrs'
                             || INITCAP(REPLACE(I.GENERIC_TRADE, '_', ''));
        LV_RPT_FIELD.RPT_FIELD_GRPNAME := 'EcrsCompoundInformation';

        LV_PVR_RPT_FIELD_LABEL_DROP.CODE := 'app.dropdown.vw' || INITCAP(REPLACE(I.GENERIC_TRADE, '_', ''));
        LV_PVR_RPT_FIELD_LABEL_F.CODE := 'app.reportField.'
                                          || LV_RPT_FIELD.NAME;
        LV_PVR_RPT_FIELD_LABEL_DROP.TEXT :=
            'select distinct SAFETY_TOPIC_OF_INTEREST from VW_'
			|| I.GENERIC_TRADE
			|| ' where SAFETY_TOPIC_OF_INTEREST is not null order by upper(SAFETY_TOPIC_OF_INTEREST) Asc';

        LV_PVR_RPT_FIELD_LABEL_F.TEXT :=
            UPPER(REPLACE(I.GENERIC_TRADE, '_', '/'))
			|| ' - ECRS';

        MERGE INTO SOURCE_TABLE_MASTER_BASE SCM USING (
                                                          SELECT
                                                              LV_SOURCE_TABLE_MASTER.CASE_JOIN_EQUI_OUTER   AS CASE_JOIN_EQUI_OUTER,
                                                              LV_SOURCE_TABLE_MASTER.CASE_JOIN_ORDER        AS CASE_JOIN_ORDER,
                                                              LV_SOURCE_TABLE_MASTER.HAS_ENTERPRISE_ID      AS HAS_ENTERPRISE_ID,
                                                              LV_SOURCE_TABLE_MASTER.IS_DELETED             AS IS_DELETED,
                                                              LV_SOURCE_TABLE_MASTER.RANK_COLUMN            AS RANK_COLUMN,
                                                              LV_SOURCE_TABLE_MASTER.TABLE_ALIAS            AS TABLE_ALIAS,
                                                              LV_SOURCE_TABLE_MASTER.TABLE_NAME             AS TABLE_NAME,
                                                              LV_SOURCE_TABLE_MASTER.TABLE_TYPE             AS TABLE_TYPE,
                                                              LV_SOURCE_TABLE_MASTER.VERSIONED_DATA         AS VERSIONED_DATA,
                                                              LV_SOURCE_TABLE_MASTER.DELETED                AS DELETED,
                                                              LV_SOURCE_TABLE_MASTER.PRIMARY_KEY            AS PRIMARY_KEY
                                                          FROM
                                                              DUAL
                                                      )
        QRY ON ( SCM.TABLE_NAME = QRY.TABLE_NAME )
        WHEN MATCHED THEN UPDATE SET SCM.CASE_JOIN_EQUI_OUTER = QRY.CASE_JOIN_EQUI_OUTER,
        SCM.CASE_JOIN_ORDER = QRY.CASE_JOIN_ORDER,
        SCM.HAS_ENTERPRISE_ID = QRY.HAS_ENTERPRISE_ID,
        SCM.IS_DELETED = QRY.IS_DELETED,
        SCM.RANK_COLUMN = QRY.RANK_COLUMN,
        SCM.TABLE_ALIAS = QRY.TABLE_ALIAS,
        SCM.TABLE_TYPE = QRY.TABLE_TYPE,
        SCM.VERSIONED_DATA = QRY.VERSIONED_DATA,
        SCM.DELETED = QRY.DELETED,
        SCM.PRIMARY_KEY = QRY.PRIMARY_KEY
        WHEN NOT MATCHED THEN INSERT (
            SCM.CASE_JOIN_EQUI_OUTER,
            SCM.CASE_JOIN_ORDER,
            SCM.HAS_ENTERPRISE_ID,
            SCM.IS_DELETED,
            SCM.RANK_COLUMN,
            SCM.TABLE_ALIAS,
            SCM.TABLE_NAME,
            SCM.TABLE_TYPE,
            SCM.VERSIONED_DATA,
            SCM.DELETED,
            SCM.PRIMARY_KEY ) VALUES (
            QRY.CASE_JOIN_EQUI_OUTER,
            QRY.CASE_JOIN_ORDER,
            QRY.HAS_ENTERPRISE_ID,
            QRY.IS_DELETED,
            QRY.RANK_COLUMN,
            QRY.TABLE_ALIAS,
            QRY.TABLE_NAME,
            QRY.TABLE_TYPE,
            QRY.VERSIONED_DATA,
            QRY.DELETED,
            QRY.PRIMARY_KEY );

        MERGE INTO SOURCE_COLUMN_MASTER_BASE SCM USING (
                                                          SELECT
                                                              LV_SOURCE_COLUMN_MASTER.COLUMN_NAME          AS COLUMN_NAME,
                                                              LV_SOURCE_COLUMN_MASTER.COLUMN_TYPE          AS COLUMN_TYPE,
                                                              LV_SOURCE_COLUMN_MASTER.CONCATENATED_FIELD   AS CONCATENATED_FIELD,
                                                              LV_SOURCE_COLUMN_MASTER.IS_DELETED           AS IS_DELETED,
                                                              LV_SOURCE_COLUMN_MASTER.LANG_ID              AS LANG_ID,
                                                              LV_SOURCE_COLUMN_MASTER.LM_DECODE_COLUMN     AS LM_DECODE_COLUMN,
                                                              LV_SOURCE_COLUMN_MASTER.LM_JOIN_COLUMN       AS LM_JOIN_COLUMN,
                                                              LV_SOURCE_COLUMN_MASTER.LM_JOIN_EQUI_OUTER   AS LM_JOIN_EQUI_OUTER,
                                                              LV_SOURCE_COLUMN_MASTER.LM_TABLE_NAME_ATM_ID AS LM_TABLE_NAME_ATM_ID,
                                                              LV_SOURCE_COLUMN_MASTER.PRIMARY_KEY_ID       AS PRIMARY_KEY_ID,
                                                              LV_SOURCE_COLUMN_MASTER.REPORT_ITEM          AS REPORT_ITEM,
                                                              LV_SOURCE_COLUMN_MASTER.TABLE_NAME_ATM_ID    AS TABLE_NAME_ATM_ID,
                                                              LV_SOURCE_COLUMN_MASTER.DECODE_COLUMN        AS DECODE_COLUMN,
                                                              LV_SOURCE_COLUMN_MASTER.DELETED              AS DELETED
                                                          FROM
                                                              DUAL
                                                      )
        QRY ON ( SCM.REPORT_ITEM = QRY.REPORT_ITEM )
        WHEN MATCHED THEN UPDATE SET SCM.COLUMN_NAME = QRY.COLUMN_NAME,
        SCM.COLUMN_TYPE = QRY.COLUMN_TYPE,
        SCM.CONCATENATED_FIELD = QRY.CONCATENATED_FIELD,
        SCM.IS_DELETED = QRY.IS_DELETED,
        SCM.LANG_ID = QRY.LANG_ID,
        SCM.LM_DECODE_COLUMN = QRY.LM_DECODE_COLUMN,
        SCM.LM_JOIN_COLUMN = QRY.LM_JOIN_COLUMN,
        SCM.LM_JOIN_EQUI_OUTER = QRY.LM_JOIN_EQUI_OUTER,
        SCM.LM_TABLE_NAME_ATM_ID = QRY.LM_TABLE_NAME_ATM_ID,
        SCM.PRIMARY_KEY_ID = QRY.PRIMARY_KEY_ID,
        SCM.TABLE_NAME_ATM_ID = QRY.TABLE_NAME_ATM_ID,
        SCM.DECODE_COLUMN = QRY.DECODE_COLUMN,
        SCM.DELETED = QRY.DELETED
        WHEN NOT MATCHED THEN INSERT (
            SCM.COLUMN_NAME,
            SCM.COLUMN_TYPE,
            SCM.CONCATENATED_FIELD,
            SCM.IS_DELETED,
            SCM.LANG_ID,
            SCM.LM_DECODE_COLUMN,
            SCM.LM_JOIN_COLUMN,
            SCM.LM_JOIN_EQUI_OUTER,
            SCM.LM_TABLE_NAME_ATM_ID,
            SCM.PRIMARY_KEY_ID,
            SCM.REPORT_ITEM,
            SCM.TABLE_NAME_ATM_ID,
            SCM.DECODE_COLUMN,
            SCM.DELETED ) VALUES (
            QRY.COLUMN_NAME,
            QRY.COLUMN_TYPE,
            QRY.CONCATENATED_FIELD,
            QRY.IS_DELETED,
            QRY.LANG_ID,
            QRY.LM_DECODE_COLUMN,
            QRY.LM_JOIN_COLUMN,
            QRY.LM_JOIN_EQUI_OUTER,
            QRY.LM_TABLE_NAME_ATM_ID,
            QRY.PRIMARY_KEY_ID,
            QRY.REPORT_ITEM,
            QRY.TABLE_NAME_ATM_ID,
            QRY.DECODE_COLUMN,
            QRY.DELETED );

        MERGE INTO RPT_FIELD_BASE RF USING (
                                              SELECT
                                                  LV_RPT_FIELD.DATA_TYPE                 AS DATA_TYPE,
                                                  LV_RPT_FIELD.DATE_FORMAT               AS DATE_FORMAT,
                                                  LV_RPT_FIELD.DESCRIPTION               AS DESCRIPTION,
                                                  LV_RPT_FIELD.DIC_LEVEL                 AS DIC_LEVEL,
                                                  LV_RPT_FIELD.DIC_TYPE                  AS DIC_TYPE,
                                                  LV_RPT_FIELD.FIXED_WIDTH               AS FIXED_WIDTH,
                                                  LV_RPT_FIELD.ISAUTOCOMPLETE            AS ISAUTOCOMPLETE,
                                                  LV_RPT_FIELD.IS_DELETED                AS IS_DELETED,
                                                  LV_RPT_FIELD.IS_TEXT                   AS IS_TEXT,
                                                  LV_RPT_FIELD.LIST_DOMAIN_CLASS         AS LIST_DOMAIN_CLASS,
                                                  LV_PVR_RPT_FIELD_LABEL_DROP.CODE       AS LMSQL,
                                                  LV_RPT_FIELD.NAME                      AS NAME,
                                                  LV_RPT_FIELD.POST_QUERY_PROCEDURE      AS POST_QUERY_PROCEDURE,
                                                  LV_RPT_FIELD.PRE_QUERY_PROCEDURE       AS PRE_QUERY_PROCEDURE,
                                                  LV_RPT_FIELD.PRE_REPORT_PROCEDURE      AS PRE_REPORT_PROCEDURE,
                                                  LV_RPT_FIELD.QUERY_SELECTABLE          AS QUERY_SELECTABLE,
                                                  LV_RPT_FIELD.RPT_FIELD_GRPNAME         AS RPT_FIELD_GRPNAME,
                                                  LV_SOURCE_COLUMN_MASTER.REPORT_ITEM    AS SOURCE_COLUMN_MASTER_ID,
                                                  LV_RPT_FIELD.TEMPLT_CLL_SELECTABLE     AS TEMPLT_CLL_SELECTABLE,
                                                  LV_RPT_FIELD.TEMPLT_DTCOL_SELECTABLE   AS TEMPLT_DTCOL_SELECTABLE,
                                                  LV_RPT_FIELD.TEMPLT_DTROW_SELECTABLE   AS TEMPLT_DTROW_SELECTABLE,
                                                  LV_RPT_FIELD.NAME                      AS TRANSFORM,
                                                  LV_RPT_FIELD.VERSION                   AS VERSION,
                                                  LV_RPT_FIELD.WIDTH_PROPORTION_INDEX    AS WIDTH_PROPORTION_INDEX,
                                                  LV_RPT_FIELD.ML_FLAG                   AS ML_FLAG
                                              FROM
                                                  DUAL
                                          )
        QRY ON ( RF.NAME = QRY.NAME )
        WHEN MATCHED THEN UPDATE SET RF.DATA_TYPE = QRY.DATA_TYPE,
        RF.DATE_FORMAT = QRY.DATE_FORMAT,
        RF.DESCRIPTION = QRY.DESCRIPTION,
        RF.DIC_LEVEL = QRY.DIC_LEVEL,
        RF.DIC_TYPE = QRY.DIC_TYPE,
        RF.FIXED_WIDTH = QRY.FIXED_WIDTH,
        RF.ISAUTOCOMPLETE = QRY.ISAUTOCOMPLETE,
        RF.IS_DELETED = QRY.IS_DELETED,
        RF.IS_TEXT = QRY.IS_TEXT,
        RF.LIST_DOMAIN_CLASS = QRY.LIST_DOMAIN_CLASS,
        RF.LMSQL = QRY.LMSQL,
        RF.POST_QUERY_PROCEDURE = QRY.POST_QUERY_PROCEDURE,
        RF.PRE_QUERY_PROCEDURE = QRY.PRE_QUERY_PROCEDURE,
        RF.PRE_REPORT_PROCEDURE = QRY.PRE_REPORT_PROCEDURE,
        RF.QUERY_SELECTABLE = QRY.QUERY_SELECTABLE,
        RF.RPT_FIELD_GRPNAME = QRY.RPT_FIELD_GRPNAME,
        RF.SOURCE_COLUMN_MASTER_ID = QRY.SOURCE_COLUMN_MASTER_ID,
        RF.TEMPLT_CLL_SELECTABLE = QRY.TEMPLT_CLL_SELECTABLE,
        RF.TEMPLT_DTCOL_SELECTABLE = QRY.TEMPLT_DTCOL_SELECTABLE,
        RF.TEMPLT_DTROW_SELECTABLE = QRY.TEMPLT_DTROW_SELECTABLE,
        RF.TRANSFORM = QRY.TRANSFORM,
        RF.VERSION = QRY.VERSION,
        RF.WIDTH_PROPORTION_INDEX = QRY.WIDTH_PROPORTION_INDEX,
        RF.ML_FLAG = QRY.ML_FLAG
        WHEN NOT MATCHED THEN INSERT (
            RF.DATA_TYPE,
            RF.DATE_FORMAT,
            RF.DESCRIPTION,
            RF.DIC_LEVEL,
            RF.DIC_TYPE,
            RF.FIXED_WIDTH,
            RF.ISAUTOCOMPLETE,
            RF.IS_DELETED,
            RF.IS_TEXT,
            RF.LIST_DOMAIN_CLASS,
            RF.LMSQL,
            RF.NAME,
            RF.POST_QUERY_PROCEDURE,
            RF.PRE_QUERY_PROCEDURE,
            RF.PRE_REPORT_PROCEDURE,
            RF.QUERY_SELECTABLE,
            RF.RPT_FIELD_GRPNAME,
            RF.SOURCE_COLUMN_MASTER_ID,
            RF.TEMPLT_CLL_SELECTABLE,
            RF.TEMPLT_DTCOL_SELECTABLE,
            RF.TEMPLT_DTROW_SELECTABLE,
            RF.TRANSFORM,
            RF.VERSION,
            RF.WIDTH_PROPORTION_INDEX,
            RF.ML_FLAG ) VALUES (
            QRY.DATA_TYPE,
            QRY.DATE_FORMAT,
            QRY.DESCRIPTION,
            QRY.DIC_LEVEL,
            QRY.DIC_TYPE,
            QRY.FIXED_WIDTH,
            QRY.ISAUTOCOMPLETE,
            QRY.IS_DELETED,
            QRY.IS_TEXT,
            QRY.LIST_DOMAIN_CLASS,
            QRY.LMSQL,
            QRY.NAME,
            QRY.POST_QUERY_PROCEDURE,
            QRY.PRE_QUERY_PROCEDURE,
            QRY.PRE_REPORT_PROCEDURE,
            QRY.QUERY_SELECTABLE,
            QRY.RPT_FIELD_GRPNAME,
            QRY.SOURCE_COLUMN_MASTER_ID,
            QRY.TEMPLT_CLL_SELECTABLE,
            QRY.TEMPLT_DTCOL_SELECTABLE,
            QRY.TEMPLT_DTROW_SELECTABLE,
            QRY.TRANSFORM,
            QRY.VERSION,
            QRY.WIDTH_PROPORTION_INDEX,
            QRY.ML_FLAG );

        MERGE INTO PVR_RPT_FIELD_LABEL_BASE PRFL USING (
                                                          SELECT
                                                              LV_PVR_RPT_FIELD_LABEL_DROP.CODE   AS CODE,
                                                              LV_PVR_RPT_FIELD_LABEL_DROP.LOC    AS LOC,
                                                              LV_PVR_RPT_FIELD_LABEL_DROP.TEXT   AS TEXT
                                                          FROM
                                                              DUAL
                                                      )
        QRY ON ( PRFL.CODE = QRY.CODE
                 AND PRFL.LOC = QRY.LOC )
        WHEN MATCHED THEN UPDATE SET PRFL.TEXT = QRY.TEXT
        WHEN NOT MATCHED THEN INSERT (
            PRFL.CODE,
            PRFL.LOC,
            PRFL.TEXT ) VALUES (
            QRY.CODE,
            QRY.LOC,
            QRY.TEXT );

        MERGE INTO PVR_RPT_FIELD_LABEL_BASE PRFL USING (
                                                          SELECT
                                                              LV_PVR_RPT_FIELD_LABEL_F.CODE   AS CODE,
                                                              LV_PVR_RPT_FIELD_LABEL_F.LOC    AS LOC,
                                                              LV_PVR_RPT_FIELD_LABEL_F.TEXT   AS TEXT
                                                          FROM
                                                              DUAL
                                                      )
        QRY ON ( PRFL.CODE = QRY.CODE
                 AND PRFL.LOC = QRY.LOC )
        WHEN MATCHED THEN UPDATE SET PRFL.TEXT = QRY.TEXT
        WHEN NOT MATCHED THEN INSERT (
            PRFL.CODE,
            PRFL.LOC,
            PRFL.TEXT ) VALUES (
            QRY.CODE,
            QRY.LOC,
            QRY.TEXT );

select nvl(max(to_number(replace(table_alias,'ecrs',''))),0) + 1 
INTO V_INC
from SOURCE_TABLE_MASTER_BASE where table_alias like 'ecrs%' and table_alias not in('ecrsnc','ecrsst','ecrsmt','ecrsrp','ecrsfg');
			
    END LOOP;		

END;
/