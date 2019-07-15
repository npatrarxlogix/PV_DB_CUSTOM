BEGIN
   INSERT INTO rpt_field_group_base
               (ID, is_deleted, NAME, rank_id, VERSION
               )
        VALUES (201, 0, 'EcrsCompoundInformation', 40, 0
               );

   INSERT INTO rpt_field_group_base
               (ID, is_deleted, NAME, rank_id, VERSION
               )
        VALUES (202, 0, 'EcrsInformation', 41, 0
               );

   COMMIT;
END;
/