CREATE OR REPLACE VIEW V_ESB_V_STUDY AS
    SELECT
        trial_no,
        compound_code,
        project_code_ncc,
        project_code_alias,
        study_code_ncc,
        study_code_alias
    FROM
        esb_v_study;