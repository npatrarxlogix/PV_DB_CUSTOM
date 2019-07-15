CREATE OR REPLACE PACKAGE pkg_post_case_transform
IS
   PROCEDURE p_main (pi_mode VARCHAR2);

   PROCEDURE p_update_pop_marketing;

   PROCEDURE p_update_case_category;

   PROCEDURE p_update_pms_studies;

   PROCEDURE p_update_most_relevant;

   PROCEDURE p_update_diagnosis_symptom;

   PROCEDURE p_update_cons_rept;

   PROCEDURE p_update_generic_name;

   PROCEDURE p_update_pt_code;

   PROCEDURE p_update_prim_correspondent;

   PROCEDURE p_update_action_item_code;

   PROCEDURE p_update_partner_name;

   PROCEDURE p_update_deleted_deactivated;

   PROCEDURE p_update_lock_date_time;

   PROCEDURE p_update_latest_not_submitted;

   PROCEDURE p_update_pmda_submission_date;

   PROCEDURE p_update_cons_rept_j;

   PROCEDURE p_update_first_last_dose;
END;
/