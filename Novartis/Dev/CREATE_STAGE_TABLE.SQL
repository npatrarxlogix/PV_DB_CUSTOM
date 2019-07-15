--------------------------------------------------------
--  DDL for Table ESB_V_ORGANIZATION_HIST
--------------------------------------------------------

  CREATE TABLE ESB_V_ORGANIZATION_HIST 
   (          ORGANIZATION_CODE VARCHAR2(50 CHAR), 
              DESCRIPTION VARCHAR2(300 CHAR), 
              ORGANIZATION_EID VARCHAR2(1000 CHAR), 
              ORGANIZATION_EID_AUTHORITY VARCHAR2(300 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER
   );
   
   
--------------------------------------------------------
--  DDL for Table REF_STUDY_MAP_HIST 
--------------------------------------------------------

    CREATE TABLE REF_STUDY_MAP_HIST 
   (        STUDY_EID VARCHAR2(200 CHAR), 
            STUDY_EID_AUTHORITY VARCHAR2(30 CHAR), 
            PROJECT_EREF VARCHAR2(200 CHAR), 
            PROJECT_EREF_AUTHORITY VARCHAR2(30 CHAR), 
            COMPOUND_EREF VARCHAR2(200 CHAR), 
            COMPOUND_EREF_AUTHORITY VARCHAR2(30 CHAR), 
            PARENT_STUDY_EREF VARCHAR2(200 CHAR), 
            PARENT_STUDY_EREF_AUTHORITY VARCHAR2(30 CHAR), 
            CLINICAL_PLAN_NO NUMBER(6,0), 
            TRIAL_NO NUMBER(6,0), 
            PARENT_TRIAL_NO NUMBER(6,0), 
            COMPOUND_CODE VARCHAR2(10 CHAR), 
            PARENT_STUDY_CODE_NCC VARCHAR2(20 CHAR), 
            PARENT_STUDY_CODE_ALIAS VARCHAR2(20 CHAR), 
            TITLE VARCHAR2(720 CHAR), 
            PROJECT_CODE_NCC VARCHAR2(20 CHAR), 
            PROJECT_CODE_ALIAS VARCHAR2(20 CHAR), 
            SHORT_DESCRIPTION VARCHAR2(60 CHAR), 
            STUDY_CODE_NCC VARCHAR2(20 CHAR), 
            STUDY_CODE_ALIAS VARCHAR2(20 CHAR), 
            PHASE_DESC VARCHAR2(40 CHAR), 
            EUDRACT_NUMBER VARCHAR2(500 CHAR), 
            NCTR_NUMBER VARCHAR2(500 CHAR), 
            STUDY_STATUS_DESC VARCHAR2(200 CHAR), 
            STUDY_ACRONYM VARCHAR2(20 CHAR),
            STUDY_CREDI VARCHAR2(20 CHAR), 
            STUDY_SUBWAY VARCHAR2(20 CHAR), 
            SUBWAY_MIGRATION_STATUS VARCHAR2(13 CHAR),
			GG_COMMIT_TIME DATE,
			BATCH NUMBER, 
            PARTITION NUMBER
   ) ;

   
   
   
--------------------------------------------------------
--  DDL for Table ESB_V_STUDY_HIST
--------------------------------------------------------
   
   CREATE TABLE ESB_V_STUDY_HIST
   (          STUDY_EID VARCHAR2(1000 CHAR), 
              STUDY_EID_AUTHORITY VARCHAR2(300 CHAR),   
              TRIAL_NO NUMBER,  
              COMPOUND_CODE VARCHAR2(200 CHAR), 
              TITLE VARCHAR2(4000 CHAR), 
              PROJECT_CODE_NCC VARCHAR2(200 CHAR), 
              PROJECT_CODE_ALIAS VARCHAR2(200 CHAR), 
              STUDY_CODE_NCC VARCHAR2(200 CHAR), 
              STUDY_CODE_ALIAS VARCHAR2(200 CHAR), 
              PHASE_CODE VARCHAR2(200 CHAR),
              DESIGN_CONFIG_CODE VARCHAR2(100 CHAR),  
              DESIGN_CONFIG_DESC VARCHAR2(400 CHAR),
              BLINDING_SCHEMA_CODE VARCHAR2(100 CHAR),
              BLINDING_SCHEMA_DESC VARCHAR2(400 CHAR),
              LAST_UPDATED_BY NUMBER, 
              AGE_MAXIMUM_ACTUAL NUMBER,
              ALLOCATION_CODE VARCHAR2(100 CHAR),
              AGE_MAXIMUM_UNITS VARCHAR2(50 CHAR), 
              AGE_MINIMUM_ACTUAL NUMBER, 
              AGE_MINIMUM_UNITS VARCHAR2(50 CHAR),
              FEMALE_PARTICIPATION_IND VARCHAR2(100 CHAR), 
              MALE_PARTICIPATION_IND VARCHAR2(100 CHAR),
              STUDY_CATEGORY_CODE VARCHAR2(50 CHAR),
              STUDY_CATEGORY_DESC VARCHAR2(1000 CHAR),
              ALLOCATION_DESC VARCHAR2(400 CHAR),
              MANAGING_ORG_EREF VARCHAR2(1000 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER
   );
--------------------------------------------------------
--  DDL for Table ESB_V_STUDY_DESIGN_FACTOR_HIST
--------------------------------------------------------


CREATE TABLE ESB_V_STUDY_DESIGN_FACTOR_HIST
   (          STUDY_DESIGN_FACTOR_EID VARCHAR2(1000 CHAR), 
              STUDY_DESIGN_FACTOR_EID_AUTH VARCHAR2(300 CHAR), 
              STUDY_EREF VARCHAR2(1000 CHAR), 
              TRIAL_NO NUMBER, 
              STUDY_DESIGN_FACTOR_CODE VARCHAR2(100 CHAR),
              STUDY_DESIGN_FACTOR_DESC VARCHAR2(400 CHAR),
              STUDY_CODE_NCC VARCHAR2(200 CHAR), 
              STUDY_CODE_ALIAS VARCHAR2(200 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER
   );
   
   
   
--------------------------------------------------------
--  DDL for Table ESB_V_STUDY_THERAPY_HIST
--------------------------------------------------------

  CREATE TABLE ESB_V_STUDY_THERAPY_HIST 
   (          STUDY_THERAPY_EID VARCHAR2(1000 CHAR), 
              STUDY_THERAPY_EID_AUTHORITY VARCHAR2(300 CHAR), 
              STUDY_EREF VARCHAR2(1000 CHAR), 
              TRIAL_NO NUMBER, 
              STUDY_CODE_NCC VARCHAR2(200 CHAR), 
              STUDY_CODE_ALIAS VARCHAR2(200 CHAR),  
              COMPOUND_CODE VARCHAR2(200 CHAR),
              ADMINISTRATION_ROUTE_DESC VARCHAR2(400 CHAR), 
              DOSAGE_FREQUENCY_DESC VARCHAR2(400 CHAR), 
              DOSE_QUANTITY_UNITS VARCHAR2(100 CHAR), 
              TARGET_RANDOMIZATION_NUMBER NUMBER,
              TREATMENT_ARM_NAME VARCHAR2(600 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER
   );
   
   
--------------------------------------------------------
--  DDL for Table ESB_V_STUDY_USERDEF_ITEM_HIST
--------------------------------------------------------

  CREATE TABLE ESB_V_STUDY_USERDEF_ITEM_HIST 
   (          STUDY_USERDEF_ITEM_EID VARCHAR2(1000 CHAR), 
              STUDY_USERDEF_ITEM_EID_AUTH VARCHAR2(300 CHAR), 
              STUDY_EREF VARCHAR2(1000 CHAR),  
              TRIAL_NO NUMBER, 
              ITEM_CODE VARCHAR2(200 CHAR), 
              ITEM_NAME VARCHAR2(400 CHAR), 
              ITEM_VALUE VARCHAR2(2000 CHAR), 
              STUDY_CODE_NCC VARCHAR2(200 CHAR), 
              STUDY_CODE_ALIAS VARCHAR2(200 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER
   );

--------------------------------------------------------
--  DDL for Table ESB_V_PROJECT_HIST
--------------------------------------------------------   
   
CREATE TABLE  ESB_V_PROJECT_HIST 
   (         PROJECT_EID  VARCHAR2(200 CHAR), 
             PROJECT_EID_AUTHORITY  VARCHAR2(30 CHAR),
             PROJECT_CODE_NCC  VARCHAR2(20 CHAR), 
             PROJECT_CODE_ALIAS  VARCHAR2(20 CHAR),
             COMPOUND_CODE VARCHAR2(200 CHAR),
			 GG_COMMIT_TIME DATE,
             BATCH NUMBER, 
             PARTITION NUMBER
   );
   


--------------------------------------------------------
--  DDL for Table ESB_V_PROJECT_INDICATION_HIST
-------------------------------------------------------- 
  
CREATE TABLE ESB_V_PROJECT_INDICATION_HIST 
   (        PROJECT_INDICATION_EID VARCHAR2(200 CHAR), 
            PROJECT_INDICATION_EID_AUTHO VARCHAR2(30 CHAR),
            PROJECT_CODE_ALIAS VARCHAR2(200 CHAR),
			PROJECT_EREF VARCHAR2(200 CHAR),
			PROJECT_EREF_AUTHORITY VARCHAR2(30 CHAR),
			GG_COMMIT_TIME DATE,
            BATCH NUMBER, 
            PARTITION NUMBER
   ) ;
   
--------------------------------------------------------
--  DDL for Table ESB_V_STUDY_COUNTRY_HIST
--------------------------------------------------------

  CREATE TABLE ESB_V_STUDY_COUNTRY_HIST
   (          STUDY_COUNTRY_EID VARCHAR2(1000 CHAR), 
              STUDY_COUNTRY_EID_AUTHORITY VARCHAR2(300 CHAR), 
              TRIAL_NO NUMBER, 
              COUNTRY_CODE VARCHAR2(50 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER
);
   
--------------------------------------------------------
--  DDL for Table ESB_V_STUDY_SUBJ_FIG_ALL_HIST
--------------------------------------------------------

  CREATE TABLE ESB_V_STUDY_SUBJ_FIG_ALL_HIST 
   (          STUDY_SUBJ_FIG_EID_SCR VARCHAR2(200 CHAR), 
              STUDY_SUBJ_FIG_EID_AUTHOR_SCR VARCHAR2(30 CHAR), 
              STUDY_SUBJ_FIG_EID_TRT VARCHAR2(200 CHAR), 
              STUDY_SUBJ_FIG_EID_AUTHOR_TRT VARCHAR2(30 CHAR), 
              STUDY_SUBJ_FIG_EID_FUP VARCHAR2(200 CHAR), 
              STUDY_SUBJ_FIG_EID_AUTHOR_FUP VARCHAR2(30 CHAR), 
              STUDY_SUBJ_FIG_EID_BAS VARCHAR2(200 CHAR), 
              STUDY_SUBJ_FIG_EID_AUTHOR_BAS VARCHAR2(30 CHAR), 
              TRIAL_NO NUMBER,
              ENTERED_TREATMENT NUMBER, 
              PATIENT_FIGURE_TYPE VARCHAR2(10 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER       
   );
   
--------------------------------------------------------
--  DDL for Table ESB_V_STUDY_EVENT_HIST
--------------------------------------------------------

  CREATE TABLE ESB_V_STUDY_EVENT_HIST 
   (          STUDY_EVENT_EID VARCHAR2(1000 CHAR), 
              STUDY_EVENT_EID_AUTHORITY VARCHAR2(300 CHAR),  
              TRIAL_NO NUMBER, 
              EVENT_NUMBER NUMBER, 
              BASELINE_DATE DATE, 
              ACTUAL_DATE DATE,
              GG_COMMIT_TIME DATE,			  
              BATCH NUMBER, 
              PARTITION NUMBER
   );
   
--------------------------------------------------------
--  DDL for Table ESB_V_DOSAGE_FREQUENCY_HIST
--------------------------------------------------------

  CREATE TABLE ESB_V_DOSAGE_FREQUENCY_HIST 
   (          DOSAGE_FREQUENCY_EID VARCHAR2(1000 CHAR), 
              DOSAGE_FREQUENCY_EID_AUTHORITY VARCHAR2(300 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER
   );



--------------------------------------------------------
--  DDL for Table S_ESB_V_ORGANIZATION
--------------------------------------------------------

  CREATE TABLE S_ESB_V_ORGANIZATION 
   (          ORGANIZATION_CODE VARCHAR2(50 CHAR), 
              DESCRIPTION VARCHAR2(300 CHAR), 
              ORGANIZATION_EID VARCHAR2(1000 CHAR), 
              ORGANIZATION_EID_AUTHORITY VARCHAR2(300 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER,
              CONSTRAINT PK_ORGANIZATION PRIMARY KEY (ORGANIZATION_EID,ORGANIZATION_EID_AUTHORITY)
   );
   
   
--------------------------------------------------------
--  DDL for Table S_REF_STUDY_MAP
--------------------------------------------------------

    CREATE TABLE S_REF_STUDY_MAP
   (        STUDY_EID VARCHAR2(200 CHAR), 
            STUDY_EID_AUTHORITY VARCHAR2(30 CHAR), 
            PROJECT_EREF VARCHAR2(200 CHAR), 
            PROJECT_EREF_AUTHORITY VARCHAR2(30 CHAR), 
            COMPOUND_EREF VARCHAR2(200 CHAR), 
            COMPOUND_EREF_AUTHORITY VARCHAR2(30 CHAR), 
            PARENT_STUDY_EREF VARCHAR2(200 CHAR), 
            PARENT_STUDY_EREF_AUTHORITY VARCHAR2(30 CHAR), 
            CLINICAL_PLAN_NO NUMBER(6,0), 
            TRIAL_NO NUMBER(6,0), 
            PARENT_TRIAL_NO NUMBER(6,0), 
            COMPOUND_CODE VARCHAR2(10 CHAR), 
            PARENT_STUDY_CODE_NCC VARCHAR2(20 CHAR), 
            PARENT_STUDY_CODE_ALIAS VARCHAR2(20 CHAR), 
            TITLE VARCHAR2(720 CHAR), 
            PROJECT_CODE_NCC VARCHAR2(20 CHAR), 
            PROJECT_CODE_ALIAS VARCHAR2(20 CHAR), 
            SHORT_DESCRIPTION VARCHAR2(60 CHAR), 
            STUDY_CODE_NCC VARCHAR2(20 CHAR), 
            STUDY_CODE_ALIAS VARCHAR2(20 CHAR), 
            PHASE_DESC VARCHAR2(40 CHAR), 
            EUDRACT_NUMBER VARCHAR2(500 CHAR), 
            NCTR_NUMBER VARCHAR2(500 CHAR), 
            STUDY_STATUS_DESC VARCHAR2(200 CHAR), 
            STUDY_ACRONYM VARCHAR2(20 CHAR),
            STUDY_CREDI VARCHAR2(20 CHAR), 
            STUDY_SUBWAY VARCHAR2(20 CHAR), 
            SUBWAY_MIGRATION_STATUS VARCHAR2(13 CHAR),
			GG_COMMIT_TIME DATE,
			BATCH NUMBER, 
            PARTITION NUMBER,
			CONSTRAINT PK_REF_STUDY_MAP PRIMARY KEY (STUDY_EID)
   ) ;

   
   
--------------------------------------------------------
--  DDL for Table S_ESB_V_STUDY
--------------------------------------------------------
   
   CREATE TABLE S_ESB_V_STUDY
   (          STUDY_EID VARCHAR2(1000 CHAR), 
              STUDY_EID_AUTHORITY VARCHAR2(300 CHAR),   
              TRIAL_NO NUMBER,  
              COMPOUND_CODE VARCHAR2(200 CHAR), 
              TITLE VARCHAR2(4000 CHAR), 
              PROJECT_CODE_NCC VARCHAR2(200 CHAR), 
              PROJECT_CODE_ALIAS VARCHAR2(200 CHAR), 
              STUDY_CODE_NCC VARCHAR2(200 CHAR), 
              STUDY_CODE_ALIAS VARCHAR2(200 CHAR), 
              PHASE_CODE VARCHAR2(200 CHAR),
              DESIGN_CONFIG_CODE VARCHAR2(100 CHAR),  
              DESIGN_CONFIG_DESC VARCHAR2(400 CHAR),
              BLINDING_SCHEMA_CODE VARCHAR2(100 CHAR),
              BLINDING_SCHEMA_DESC VARCHAR2(400 CHAR),
			  MANAGING_ORG_EREF    VARCHAR2(1000 CHAR),
              LAST_UPDATED_BY NUMBER, 
              AGE_MAXIMUM_ACTUAL NUMBER,
              ALLOCATION_CODE VARCHAR2(100 CHAR),
              AGE_MAXIMUM_UNITS VARCHAR2(50 CHAR), 
              AGE_MINIMUM_ACTUAL NUMBER, 
              AGE_MINIMUM_UNITS VARCHAR2(50 CHAR),
              FEMALE_PARTICIPATION_IND VARCHAR2(100 CHAR), 
              MALE_PARTICIPATION_IND VARCHAR2(100 CHAR),
              STUDY_CATEGORY_CODE VARCHAR2(50 CHAR),
              STUDY_CATEGORY_DESC VARCHAR2(1000 CHAR),
              ALLOCATION_DESC VARCHAR2(400 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER,
              CONSTRAINT PK_STUDY PRIMARY KEY (STUDY_EID,STUDY_EID_AUTHORITY)
   );
--------------------------------------------------------
--  DDL for Table S_ESB_V_STUDY_DESIGN_FACTOR
--------------------------------------------------------


CREATE TABLE S_ESB_V_STUDY_DESIGN_FACTOR
   (          STUDY_DESIGN_FACTOR_EID VARCHAR2(1000 CHAR), 
              STUDY_DESIGN_FACTOR_EID_AUTH VARCHAR2(300 CHAR), 
              STUDY_EREF VARCHAR2(1000 CHAR), 
              TRIAL_NO NUMBER, 
              STUDY_DESIGN_FACTOR_CODE VARCHAR2(100 CHAR),
              STUDY_DESIGN_FACTOR_DESC VARCHAR2(400 CHAR),
              STUDY_CODE_NCC VARCHAR2(200 CHAR), 
              STUDY_CODE_ALIAS VARCHAR2(200 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER,
              CONSTRAINT PK_STUDY_DESIGN_FACTOR PRIMARY KEY (STUDY_DESIGN_FACTOR_EID,STUDY_DESIGN_FACTOR_EID_AUTH)
   );
   
   
   
--------------------------------------------------------
--  DDL for Table S_ESB_V_STUDY_THERAPY
--------------------------------------------------------

  CREATE TABLE S_ESB_V_STUDY_THERAPY
   (          STUDY_THERAPY_EID VARCHAR2(1000 CHAR), 
              STUDY_THERAPY_EID_AUTHORITY VARCHAR2(300 CHAR), 
              STUDY_EREF VARCHAR2(1000 CHAR), 
              TRIAL_NO NUMBER, 
              STUDY_CODE_NCC VARCHAR2(200 CHAR), 
              STUDY_CODE_ALIAS VARCHAR2(200 CHAR),  
              COMPOUND_CODE VARCHAR2(200 CHAR),
              ADMINISTRATION_ROUTE_DESC VARCHAR2(400 CHAR), 
              DOSAGE_FREQUENCY_DESC VARCHAR2(400 CHAR), 
              DOSE_QUANTITY_UNITS VARCHAR2(100 CHAR), 
              TARGET_RANDOMIZATION_NUMBER NUMBER,
              TREATMENT_ARM_NAME VARCHAR2(600 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER,
              CONSTRAINT PK_STUDY_THERAPY PRIMARY KEY (STUDY_THERAPY_EID,STUDY_THERAPY_EID_AUTHORITY)
   );
   
   
--------------------------------------------------------
--  DDL for Table S_ESB_V_STUDY_USERDEF_ITEM
--------------------------------------------------------

  CREATE TABLE S_ESB_V_STUDY_USERDEF_ITEM 
   (          STUDY_USERDEF_ITEM_EID VARCHAR2(1000 CHAR), 
              STUDY_USERDEF_ITEM_EID_AUTH VARCHAR2(300 CHAR), 
              STUDY_EREF VARCHAR2(1000 CHAR),  
              TRIAL_NO NUMBER, 
              ITEM_CODE VARCHAR2(200 CHAR), 
              ITEM_NAME VARCHAR2(400 CHAR), 
              ITEM_VALUE VARCHAR2(2000 CHAR), 
              STUDY_CODE_NCC VARCHAR2(200 CHAR), 
              STUDY_CODE_ALIAS VARCHAR2(200 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER,
              CONSTRAINT PK_STUDY_USERDEF_ITEM PRIMARY KEY (STUDY_USERDEF_ITEM_EID,STUDY_USERDEF_ITEM_EID_AUTH)
   );

--------------------------------------------------------
--  DDL for Table S_ESB_V_PROJECT
--------------------------------------------------------   
   
CREATE TABLE  S_ESB_V_PROJECT 
   (         PROJECT_EID  VARCHAR2(200 CHAR), 
             PROJECT_EID_AUTHORITY  VARCHAR2(30 CHAR),
             PROJECT_CODE_NCC  VARCHAR2(20 CHAR), 
             PROJECT_CODE_ALIAS  VARCHAR2(20 CHAR),
             COMPOUND_CODE VARCHAR2(200 CHAR),
             GG_COMMIT_TIME DATE,
             BATCH NUMBER, 
             PARTITION NUMBER,
             CONSTRAINT PK_ESB_V_PROJECT PRIMARY KEY (PROJECT_EID_AUTHORITY,PROJECT_EID)
   );
   


--------------------------------------------------------
--  DDL for Table S_ESB_V_PROJECT_INDICATION
-------------------------------------------------------- 
  
CREATE TABLE S_ESB_V_PROJECT_INDICATION 
   (        PROJECT_INDICATION_EID VARCHAR2(200 CHAR), 
            PROJECT_INDICATION_EID_AUTHO VARCHAR2(30 CHAR),
            PROJECT_CODE_ALIAS VARCHAR2(200 CHAR),
			PROJECT_EREF VARCHAR2(200 CHAR),
			PROJECT_EREF_AUTHORITY VARCHAR2(30 CHAR),
            GG_COMMIT_TIME DATE,
            BATCH NUMBER, 
            PARTITION NUMBER,
            CONSTRAINT PK_ESB_V_PROJECT_INDICATION PRIMARY KEY (PROJECT_INDICATION_EID,PROJECT_INDICATION_EID_AUTHO)
   );
   
--------------------------------------------------------
--  DDL for Table S_ESB_V_STUDY_COUNTRY
--------------------------------------------------------

  CREATE TABLE S_ESB_V_STUDY_COUNTRY
   (          STUDY_COUNTRY_EID VARCHAR2(1000 CHAR), 
              STUDY_COUNTRY_EID_AUTHORITY VARCHAR2(300 CHAR), 
              TRIAL_NO NUMBER, 
              COUNTRY_CODE VARCHAR2(50 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER,
              CONSTRAINT PK_STUDY_COUNTRY PRIMARY KEY (STUDY_COUNTRY_EID,STUDY_COUNTRY_EID_AUTHORITY)
   );
   
--------------------------------------------------------
--  DDL for Table S_ESB_V_STUDY_SUBJ_FIG_ALL
--------------------------------------------------------

  CREATE TABLE S_ESB_V_STUDY_SUBJ_FIG_ALL 
   (          STUDY_SUBJ_FIG_EID_SCR VARCHAR2(200 CHAR), 
              STUDY_SUBJ_FIG_EID_AUTHOR_SCR VARCHAR2(30 CHAR), 
              STUDY_SUBJ_FIG_EID_TRT VARCHAR2(200 CHAR), 
              STUDY_SUBJ_FIG_EID_AUTHOR_TRT VARCHAR2(30 CHAR), 
              STUDY_SUBJ_FIG_EID_FUP VARCHAR2(200 CHAR), 
              STUDY_SUBJ_FIG_EID_AUTHOR_FUP VARCHAR2(30 CHAR), 
              STUDY_SUBJ_FIG_EID_BAS VARCHAR2(200 CHAR), 
              STUDY_SUBJ_FIG_EID_AUTHOR_BAS VARCHAR2(30 CHAR), 
              TRIAL_NO NUMBER,
              ENTERED_TREATMENT NUMBER, 
              PATIENT_FIGURE_TYPE VARCHAR2(10 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER,
              CONSTRAINT PK_STUDY_SUBJ_FIG_ALL PRIMARY KEY (STUDY_SUBJ_FIG_EID_SCR,STUDY_SUBJ_FIG_EID_AUTHOR_SCR,STUDY_SUBJ_FIG_EID_TRT,STUDY_SUBJ_FIG_EID_AUTHOR_TRT,
STUDY_SUBJ_FIG_EID_FUP,STUDY_SUBJ_FIG_EID_AUTHOR_FUP,STUDY_SUBJ_FIG_EID_BAS,STUDY_SUBJ_FIG_EID_AUTHOR_BAS)
   );
   
--------------------------------------------------------
--  DDL for Table S_ESB_V_STUDY_EVENT
--------------------------------------------------------

  CREATE TABLE S_ESB_V_STUDY_EVENT 
   (          STUDY_EVENT_EID VARCHAR2(1000 CHAR), 
              STUDY_EVENT_EID_AUTHORITY VARCHAR2(300 CHAR),  
              TRIAL_NO NUMBER, 
              EVENT_NUMBER NUMBER, 
              BASELINE_DATE DATE, 
              ACTUAL_DATE DATE,
              GG_COMMIT_TIME DATE,			  
              BATCH NUMBER, 
              PARTITION NUMBER,
              CONSTRAINT PK_STUDY_EVENT PRIMARY KEY (STUDY_EVENT_EID,STUDY_EVENT_EID_AUTHORITY)
   );
   
--------------------------------------------------------
--  DDL for Table S_ESB_V_DOSAGE_FREQUENCY
--------------------------------------------------------

  CREATE TABLE S_ESB_V_DOSAGE_FREQUENCY 
   (          DOSAGE_FREQUENCY_EID VARCHAR2(1000 CHAR), 
              DOSAGE_FREQUENCY_EID_AUTHORITY VARCHAR2(300 CHAR),
			  GG_COMMIT_TIME DATE,
              BATCH NUMBER, 
              PARTITION NUMBER,
              CONSTRAINT PK_DOSAGE_FREQUENCY PRIMARY KEY (DOSAGE_FREQUENCY_EID,DOSAGE_FREQUENCY_EID_AUTHORITY)
   );
   


--------------------------------------------------------
--  DDL for Table S_DSUR_MV_CLINICAL_SUBJECT
--------------------------------------------------------
CREATE TABLE S_DSUR_MV_CLINICAL_SUBJECT 
(
  AL_CLINICAL_TRIAL_NM VARCHAR2(100), 
  AL_TRIAL_COUNTRY_CD  VARCHAR2(20), 
  TRIAL_SITE_ID        VARCHAR2(50), 
  CLINICAL_SUBJECT_ID  VARCHAR2(80), 
  AGE_NO               NUMBER,
  RACE_DE              VARCHAR2(60),
  SEX_DE               VARCHAR2(60),
  DEDW_OPERATION_TS    DATE,
  CLINICAL_SUBJECT_SK NUMBER,
  CONSTRAINT PK_DSUR_MV_CLINICAL_SUBJECT PRIMARY KEY (CLINICAL_SUBJECT_SK)
  );
  
--------------------------------------------------------
--  DDL for Table S_DSUR_MV_ADVERSE_EVENT
-------------------------------------------------------- 
CREATE TABLE S_DSUR_MV_ADVERSE_EVENT
(
AL_CLINICAL_TRIAL_NM VARCHAR2(100), 
AL_TRIAL_COUNTRY_CD  VARCHAR2(20),
TRIAL_SITE_ID        VARCHAR2(50),
CLINICAL_SUBJECT_ID  VARCHAR2(80),
CLINICAL_VISIT_NO    NUMBER,
AL_AE_START_DT       DATE,
AE_SERIOUSNESS_CD    NUMBER,
AE_PREFERRED_TR      VARCHAR2(150),
AE_CAUSALITY_SUSPECTED_DE VARCHAR2(150),
ACTION_TAKEN_3_CD  NUMBER,
DEDW_OPERATION_TS    DATE,
ADVERSE_EVENT_SK NUMBER,
CONSTRAINT PK_DSUR_MV_ADVERSE_EVENT PRIMARY KEY (ADVERSE_EVENT_SK)
);      

--------------------------------------------------------
--  DDL for Table S_DSUR_MV_INFECTIONS
-------------------------------------------------------- 

CREATE TABLE S_DSUR_MV_INFECTIONS
(
AL_CLINICAL_TRIAL_NM VARCHAR2(100), 
AL_TRIAL_COUNTRY_CD  VARCHAR2(20),
TRIAL_SITE_ID        VARCHAR2(50),
CLINICAL_SUBJECT_ID  VARCHAR2(80),
CLINICAL_VISIT_NO    NUMBER,
AL_INF_START_DT      DATE,
INF_SERIOUSNESS_CD   VARCHAR2(40),
INF_PREFERRED_TR     VARCHAR2(250),
INF_CASUALITY_SUSP_DE VARCHAR2(80),
ACTION_TAKEN_3_CD    NUMBER,
DEDW_OPERATION_DT DATE,
INFECTION_SK NUMBER,
CONSTRAINT PK_DSUR_MV_INFECTIONS PRIMARY KEY (INFECTION_SK)
);

--------------------------------------------------------
--  DDL for Table S_DSUR_MV_TRIAL_COMPLETION
-------------------------------------------------------- 
CREATE TABLE S_DSUR_MV_TRIAL_COMPLETION
(
AL_CLINICAL_TRIAL_NM VARCHAR2(100), 
AL_TRIAL_COUNTRY_CD  VARCHAR2(20),
TRIAL_SITE_ID        VARCHAR2(50),
CLINICAL_SUBJECT_ID  VARCHAR2(80),
AL_LAST_TRIAL_TREATMENT_DT DATE,
SOURCE_SYSTEM_CD    VARCHAR2(10),
STUDY_DISCONTINUATION_DT DATE,
DEDW_OPERATION_TS    DATE,
TRIAL_COMPLETION_SK NUMBER,
CONSTRAINT PK_DSUR_MV_TRIAL_COMPLETION PRIMARY KEY (TRIAL_COMPLETION_SK)
);


--------------------------------------------------------
--  DDL for Table S_DIND_MV_DRUG_ADMINISTRATION
-------------------------------------------------------- 
CREATE TABLE S_DIND_MV_DRUG_ADMINISTRATION
(
AL_CLINICAL_TRIAL_NM  VARCHAR2(100), 
AL_TRIAL_COUNTRY_CD   VARCHAR2(20),
TRIAL_SITE_ID         VARCHAR2(50),
CLINICAL_SUBJECT_ID   VARCHAR2(80),
CLINICAL_VISIT_NO     NUMBER,
REASON_FOR_CHANGE_DICT_NM VARCHAR2(80),
TREATMENT_DISCONTINUATION_DT DATE,
DEDW_OPERATION_TS    DATE,
DRUG_ADMINISTRATION_SK NUMBER,
CONSTRAINT PK_DIND_MV_DRUG_ADMIN PRIMARY KEY (DRUG_ADMINISTRATION_SK)
);

-- DIAL_LSH TABLE
--------------------------------------------------------
--  DDL for Table S_DM
--------------------------------------------------------
CREATE TABLE S_DM 
(
  STUDY VARCHAR2(100), 
  COUNTRY  VARCHAR2(20), 
  STUDY_SITE        VARCHAR2(50), 
  PATIENT VARCHAR2(80), 
  AGEDRV  NUMBER,
  RACE    VARCHAR2(60),
  SEX     VARCHAR2(60)
  );
  
--------------------------------------------------------
--  DDL for Table S_AE
-------------------------------------------------------- 
CREATE TABLE S_AE
(
STUDY VARCHAR2(100), 
COUNTRY  VARCHAR2(20),
STUDY_SITE        VARCHAR2(50),
PATIENT  VARCHAR2(80),
VISIT_NUMBER    NUMBER,
AESTDAT       varchar(40),
AESER    varchar(10),
AEDECOD      VARCHAR2(250),
AEREL VARCHAR2(150),
AEACN  VARCHAR2(50)
); 



--------------------------------------------------------
--  DDL for Table S_EC
-------------------------------------------------------- 
CREATE TABLE S_EC
(
STUDY  VARCHAR2(100), 
COUNTRY   VARCHAR2(20),
STUDY_SITE         VARCHAR2(50),
PATIENT   VARCHAR2(80),
VISIT_NUMBER     NUMBER,
ECREASCH VARCHAR2(80),
ECSTDAT DATE
);




