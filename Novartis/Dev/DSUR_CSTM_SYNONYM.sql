BEGIN
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM DOSAGE_FREQUENCY_NVS FOR &USERVX..DOSAGE_FREQUENCY_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM REF_STUDY_MAP_NVS FOR &USERVX..REF_STUDY_MAP_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM STUDY_NVS FOR &USERVX..STUDY_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM STUDY_DESIGN_FACTOR_NVS FOR &USERVX..STUDY_DESIGN_FACTOR_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM PROJECT_NVS FOR &USERVX..PROJECT_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM PROJECT_INDICATION_NVS FOR &USERVX..PROJECT_INDICATION_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM STUDY_COUNTRY_NVS FOR &USERVX..STUDY_COUNTRY_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM STUDY_EVENT_NVS FOR &USERVX..STUDY_EVENT_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM STUDY_SUBJ_FIG_ALL_NVS FOR &USERVX..STUDY_SUBJ_FIG_ALL_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM STUDY_THERAPY_NVS FOR &USERVX..STUDY_THERAPY_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM STUDY_USERDEF_ITEM_NVS FOR &USERVX..STUDY_USERDEF_ITEM_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM CLINICAL_SUBJECT_NVS FOR &USERVX..CLINICAL_SUBJECT_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ADVERSE_EVENT_NVS FOR &USERVX..ADVERSE_EVENT_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM INFECTIONS_NVS FOR &USERVX..INFECTIONS_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM TRIAL_COMPLETION_NVS FOR &USERVX..TRIAL_COMPLETION_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM DRUG_ADMINISTRATION_NVS FOR &USERVX..DRUG_ADMINISTRATION_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM DM_NVS FOR &USERVX..DM_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM AE_NVS FOR &USERVX..AE_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM EC_NVS FOR &USERVX..EC_NVS';
EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM DSE_EMP_ADDL FOR &USERVX..DSE_EMP_ADDL';
END;
/