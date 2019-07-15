BEGIN
   INSERT INTO pvr_ui_dropdowns
               (dropdown_name, source_id, text_desc
               )
        VALUES ('LM_LCAU_CONS_CAUSALITY', 3, 'Suspected'
               );

   INSERT INTO pvr_ui_dropdowns
               (dropdown_name, source_id, text_desc
               )
        VALUES ('LM_LCAU_CONS_CAUSALITY', 5, 'Not Suspected'
               );

   INSERT INTO pvr_ui_dropdowns
               (dropdown_name, source_id, text_desc
               )
        VALUES ('LM_LCAU_CONS_CAUSALITY', 6, 'Not assessable'
               );

   INSERT INTO pvr_ui_dropdowns
               (dropdown_name, source_id, text_desc
               )
        VALUES ('LM_LCAU_CONS_CAUSALITY_J', 3, '関連あり'
               );

   INSERT INTO pvr_ui_dropdowns
               (dropdown_name, source_id, text_desc
               )
        VALUES ('LM_LCAU_CONS_CAUSALITY_J', 5, '関連なし'
               );

UPDATE pvr_ui_dropdowns
SET text_desc='Clinical Trials', source_id=1 where dropdown_name='LM_PBRER_BUCKET' and source_id=1;

UPDATE pvr_ui_dropdowns
SET text_desc='PMS', source_id=2 where dropdown_name='LM_PBRER_BUCKET' and source_id=2;

UPDATE pvr_ui_dropdowns
SET text_desc='SR/LIT', source_id=3 where dropdown_name='LM_PBRER_BUCKET' and source_id=3;

UPDATE pvr_ui_dropdowns
SET text_desc='Other', source_id=4 where dropdown_name='LM_PBRER_BUCKET' and source_id=4;

   COMMIT;
END;
/