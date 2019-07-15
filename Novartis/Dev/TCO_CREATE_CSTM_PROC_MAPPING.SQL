CREATE TABLE p_cstm_procedure_mapping (proc_id NUMBER,procedure_name VARCHAR2(100),status NUMBER);

BEGIN
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (1, 'P_UPDATE_POP_MARKETING', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (2, 'P_UPDATE_CASE_CATEGORY', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (3, 'P_UPDATE_PMS_STUDIES', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (4, 'P_UPDATE_MOST_RELEVANT', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (5, 'P_UPDATE_DIAGNOSIS_SYMPTOM', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (6, 'P_UPDATE_CONS_REPT', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (7, 'P_UPDATE_GENERIC_NAME', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (8, 'P_UPDATE_PT_CODE', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (9, 'P_UPDATE_PRIM_CORRESPONDENT', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (10, 'P_UPDATE_ACTION_ITEM_CODE', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (11, 'P_UPDATE_PARTNER_NAME', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (12, 'P_UPDATE_DELETED_DEACTIVATED', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (13, 'P_UPDATE_LOCK_DATE_TIME', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (14, 'P_UPDATE_LATEST_NOT_SUBMITTED', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (15, 'P_UPDATE_PMDA_SUBMISSION_DATE', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (16, 'P_UPDATE_CONS_REPT_J', 0
            );
INSERT INTO p_cstm_procedure_mapping
            (proc_id, procedure_name, status
            )
     VALUES (17, 'P_UPDATE_FIRST_LAST_DOSE', 0
            );
COMMIT;
END;
/