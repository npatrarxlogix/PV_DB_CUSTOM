-- Invalid case?						1. Case classification = Invalid; then display yes; otherwise no. This is at case level.
--
-- IND Submission to FDA?  				1.	UPPER(Reporting destination) contains UPPER(%FDA%IND%) then 
--						   				2.	Record is not marked as ‘Submission not required’
--						   				3.	Record is not deleted
--						   				4.	Submission is not completed; i.e. date submitted = null
-- 											If a submission record meets above 1-4 (all are AND) criteria then yes; otherwise no
--
--
-- NDA Submission to FDA?   			1.	Upper(Reporting destination) contains upper(%FDA%PM%) then 
--						   				2.	Record is not marked as ‘Submission not required’
--						   				3.	Record is not deleted
--					       				4.	Submission is not completed; i.e. date submitted = null
--											If a submission record meets above 1-4 (all are AND) criteria then yes; otherwise no
--
-- 
-- Periodic Submission to FDA?			1.	UPPER(Reporting destination) contains UPPER(% FDA%periodic%) then 
--										2.	Record is not marked as ‘Submission not required’
--										3.	Record is not deleted
--										4.	Submission is not completed; i.e. date submitted = null
--											If a submission record meets above 1-4 (all are AND) criteria then yes; otherwise no
--
--
-- License Partner Submission?			1. 	UPPER(Reporting destination) contains %Upper(%LP%) then 
--										2.	Record is not marked as ‘Submission not required’
--										3.	Record is not deleted
--										4.	Submission is not completed; i.e. date submitted = null
--											If a submission record meets above 1-4 (all are AND) criteria then yes; otherwise no



CREATE OR REPLACE VIEW V_C_MASTER_ADDL_CSTM
AS
   SELECT   case_id, tenant_id, version_num,
         MAX (flag_ind_submission) AS flag_ind_submission,
         MAX (flag_nda_submission) AS flag_nda_submission,
         MAX (flag_periodic_submission) AS flag_periodic_submission,
         MAX (flag_lp_submission) AS flag_lp_submission,
         MAX (flag_invalid) AS flag_invalid
    FROM (WITH vw_flag AS
               (SELECT case_id, tenant_id, version_num, 1 flag_invalid
                  FROM (SELECT case_id, tenant_id, version_num,
                               ROW_NUMBER () OVER (PARTITION BY case_id, tenant_id, version_num ORDER BY 1)
                                                                           rn
                          FROM c_characteristics_fu
                         WHERE characteristic_id =
                                     (SELECT ID
                                        FROM vw_lcc_characteristics
                                       WHERE characteristics = 'Invalid Case'))
                 WHERE rn = 1)
          SELECT DISTINCT ci.case_id, ci.tenant_id, ci.version_num,
                          NVL (flag_invalid, 0) AS flag_invalid,
                          CASE
                             WHEN UPPER
                                     (destination_desc) LIKE
                                           '%FDA%IND%'
                             AND NVL (flag_invalid, 0) = 0
                                THEN 1
                             ELSE 0
                          END AS flag_ind_submission,
                          CASE
                             WHEN UPPER
                                     (destination_desc) LIKE
                                           '%FDA%PM%'
                             AND NVL (flag_invalid, 0) = 0
                                THEN 1
                             ELSE 0
                          END AS flag_nda_submission,
                          CASE
                             WHEN UPPER
                                    (destination_desc
                                    ) LIKE '%FDA%PERIODIC%'
                             AND NVL (flag_invalid, 0) = 0
                                THEN 1
                             ELSE 0
                          END AS flag_periodic_submission,
                          CASE
                             WHEN UPPER
                                      (destination_desc) LIKE
                                                '%LP%'
                             AND NVL (flag_invalid, 0) = 0
                                THEN 1
                             ELSE 0
                          END AS flag_lp_submission
                     FROM c_identification ci LEFT JOIN v_c_submissions cs
                          ON (    ci.tenant_id = cs.tenant_id
                              AND ci.case_id = cs.case_id
                              AND ci.version_num = cs.version_num
                              AND date_submission IS NULL
                             )
                          LEFT JOIN v_c_submissions_fu csfu
                          ON (    csfu.tenant_id = cs.tenant_id
                              AND csfu.flag_db_source = cs.flag_db_source
                              AND csfu.processed_report_id =
                                                        cs.processed_report_id
                              AND csfu.rec_type = cs.rec_type
                              AND flag_submission_needed = 1
--                                 AND date_deleted IS NULL
                             )
                          LEFT JOIN vw_flag vw
                          ON (    ci.tenant_id = vw.tenant_id
                              AND ci.case_id = vw.case_id
                              AND ci.version_num = vw.version_num
                             )
                          )
GROUP BY case_id, tenant_id, version_num;