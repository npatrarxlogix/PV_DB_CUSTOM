BEGIN
   UPDATE pvr_search_dict
      SET field_label = 'Product Synonym',
          json_column_text = 'Product Synonym'
    WHERE disp_view_name = 'DISP_VIEW_100' AND lang = 'en';
   UPDATE pvr_search_dict
      SET selectable = 0
    WHERE disp_view_name in ('DISP_VIEW_101','DISP_VIEW_102','DISP_VIEW_103');

   COMMIT;
END;
/