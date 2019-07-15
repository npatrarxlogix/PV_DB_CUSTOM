CREATE OR REPLACE VIEW V_IND_NUMBER AS
    SELECT
        a.study_code_alias clinical_trial,
        a.trial_no,
        b.ha_doc_reference
    FROM
        study_nvs a
        JOIN (
            SELECT
                trial_no,
                item_name,
                item_value ha_doc_reference
            FROM
                study_userdef_item_nvs
            WHERE
                item_name IN (
                    'IND/IDE Number 1',
                    'IND/IDE Number 2'
                )
                AND   item_value IS NOT NULL
        ) b ON ( a.trial_no = b.trial_no );