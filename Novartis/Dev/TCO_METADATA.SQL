begin
pkg_cstm_obj.p_ins_created_table_log (
    'DSUR_MV_ADVERSE_EVENT',
    'DEDW',
    'ADVERSE_EVENT_NVS',
    'PVD_HUB_CSTM',
    'S_DSUR_MV_ADVERSE_EVENT',
    'PVA_TO_DEDW',
    'P_S_ADVERSE_EVENT',
    'P_M_ADVERSE_EVENT'
);

pkg_cstm_obj.p_ins_created_table_log (
    'DSUR_MV_CLINICAL_SUBJECT',
    'DEDW',
    'CLINICAL_SUBJECT_NVS',
    'PVD_HUB_CSTM',
    'S_DSUR_MV_CLINICAL_SUBJECT',
    'PVA_TO_DEDW',
    'P_S_CLINICAL_SUBJECT',
    'P_M_CLINICAL_SUBJECT'
);

pkg_cstm_obj.p_ins_created_table_log (
    'DIND_MV_DRUG_ADMINISTRATION',
    'DEDW',
    'DRUG_ADMINISTRATION_NVS',
    'PVD_HUB_CSTM',
    'S_DIND_MV_DRUG_ADMINISTRATION',
    'PVA_TO_DEDW',
    'P_S_DRUG_ADMINISTRATION',
    'P_M_DRUG_ADMINISTRATION'
);

pkg_cstm_obj.p_ins_created_table_log (
    'DSUR_MV_INFECTIONS',
    'DEDW',
    'INFECTIONS_NVS',
    'PVD_HUB_CSTM',
    'S_DSUR_MV_INFECTIONS',
    'PVA_TO_DEDW',
    'P_S_INFECTIONS',
    'P_M_INFECTIONS'
);

pkg_cstm_obj.p_ins_created_table_log (
    'DSUR_MV_TRIAL_COMPLETION',
    'DEDW',
    'TRIAL_COMPLETION_NVS',
    'PVD_HUB_CSTM',
    'S_DSUR_MV_TRIAL_COMPLETION',
    'PVA_TO_DEDW',
    'P_S_TRIAL_COMPLETION',
    'P_M_TRIAL_COMPLETION'
);

--ODH TABLE

pkg_cstm_obj.p_ins_created_table_log (
    'ESB_V_DOSAGE_FREQUENCY_HIST',
    'ODH',
    'DOSAGE_FREQUENCY_NVS',
    'PVD_HUB_CSTM',
    's_esb_v_dosage_frequency',
    NULL,
    'P_S_DOSAGE_FREQUENCY',
    'P_M_DOSAGE_FREQUENCY'
);

pkg_cstm_obj.p_ins_created_table_log (
    'REF_STUDY_MAP_HIST',
    'ODH',
    'REF_STUDY_MAP_NVS',
    'PVD_HUB_CSTM',
    'S_REF_STUDY_MAP',
    NULL,
    'P_S_REF_STUDY_MAP',
    'P_M_REF_STUDY_MAP'
);

pkg_cstm_obj.p_ins_created_table_log (
    'ESB_V_PROJECT_INDICATION_HIST',
    'ODH',
    'PROJECT_INDICATION_NVS',
    'PVD_HUB_CSTM',
    'S_ESB_V_PROJECT_INDICATION',
    NULL,
    'P_S_PROJECT_INDICATION',
    'P_M_PROJECT_INDICATION'
);

pkg_cstm_obj.p_ins_created_table_log (
    'ESB_V_PROJECT_HIST',
    'ODH',
    'PROJECT_NVS',
    'PVD_HUB_CSTM',
    'S_ESB_V_PROJECT',
    NULL,
    'P_S_PROJECT',
    'P_M_PROJECT'
);

pkg_cstm_obj.p_ins_created_table_log (
    'ESB_V_STUDY_COUNTRY_HIST',
    'ODH',
    'STUDY_COUNTRY_NVS',
    'PVD_HUB_CSTM',
    'S_ESB_V_STUDY_COUNTRY',
    NULL,
    'P_S_STUDY_COUNTRY',
    'P_M_STUDY_COUNTRY'
);

pkg_cstm_obj.p_ins_created_table_log (
    'ESB_V_STUDY_DESIGN_FACTOR_HIST',
    'ODH',
    'STUDY_DESIGN_FACTOR_NVS',
    'PVD_HUB_CSTM',
    'S_ESB_V_STUDY_DESIGN_FACTOR',
    NULL,
    'P_S_STUDY_DESIGN_FACTOR',
    'P_M_STUDY_DESIGN_FACTOR'
);

pkg_cstm_obj.p_ins_created_table_log (
    'ESB_V_STUDY_EVENT_HIST',
    'ODH',
    'STUDY_EVENT_NVS',
    'PVD_HUB_CSTM',
    'S_ESB_V_STUDY_EVENT',
    NULL,
    'P_S_STUDY_EVENT',
    'P_M_STUDY_EVENT'
);

pkg_cstm_obj.p_ins_created_table_log (
    'ESB_V_STUDY_HIST',
    'ODH',
    'STUDY_NVS',
    'PVD_HUB_CSTM',
    'S_ESB_V_STUDY',
    NULL,
    'P_S_STUDY',
    'P_M_STUDY'
);

pkg_cstm_obj.p_ins_created_table_log (
    'ESB_V_STUDY_SUBJ_FIG_ALL_HIST',
    'ODH',
    'STUDY_SUBJ_FIG_ALL_NVS',
    'PVD_HUB_CSTM',
    'S_ESB_V_STUDY_SUBJ_FIG_ALL',
    NULL,
    'P_S_STUDY_SUBJ_FIG_ALL',
    'P_M_STUDY_SUBJ_FIG_ALL'
);

pkg_cstm_obj.p_ins_created_table_log (
    'ESB_V_STUDY_THERAPY_HIST',
    'ODH',
    'STUDY_THERAPY_NVS',
    'PVD_HUB_CSTM',
    'S_ESB_V_STUDY_THERAPY',
    NULL,
    'P_S_STUDY_THERAPY',
    'P_M_STUDY_THERAPY'
);

pkg_cstm_obj.p_ins_created_table_log (
    'ESB_V_STUDY_USERDEF_ITEM_HIST',
    'ODH',
    'STUDY_USERDEF_ITEM_NVS',
    'PVD_HUB_CSTM',
    'S_ESB_V_STUDY_USERDEF_ITEM',
    NULL,
    'P_S_STUDY_USERDEF_ITEM',
    'P_M_STUDY_USERDEF_ITEM'
);

--LSH

pkg_cstm_obj.p_ins_created_table_log (
    'DIALADM.V_ICRS_AE',
    'DIAL_LSH',
    'AE_NVS',
    'PVD_HUB_CSTM',
    'S_AE',
    'PVA_TO_LSH',
    'P_S_AE',
    'P_M_AE'
);

pkg_cstm_obj.p_ins_created_table_log (
    'DIALADM.V_ICRS_DM',
    'DIAL_LSH',
    'DM_NVS',
    'PVD_HUB_CSTM',
    'S_DM',
    'PVA_TO_LSH',
    'P_S_DM',
    'P_M_DM'
);

pkg_cstm_obj.p_ins_created_table_log (
    'DIALADM.V_ICRS_EC',
    'DIAL_LSH',
    'EC_NVS',
    'PVD_HUB_CSTM',
    'S_EC',
    'PVA_TO_LSH',
    'P_S_EC',
    'P_M_EC'
);
end;
/



 
 