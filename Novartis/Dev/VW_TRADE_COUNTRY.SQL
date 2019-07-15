CREATE OR REPLACE VIEW vw_trade_country_j
AS
   SELECT vtn.license_id, vtn.country_id, vlc.country, vllt.license_type,
          vtn.lang_id, vtn.selectable, vtn.tenant_id
     FROM vw_trade_name_j vtn JOIN vw_lco_country_j vlc
          ON (vtn.country_id = vlc.country_id)
          JOIN vw_lltyp_license_type_j vllt
          ON (vtn.license_type_id = vllt.license_type_id)
          ;

CREATE OR REPLACE VIEW vw_trade_country
AS
   SELECT vtn.license_id, vtn.country_id, vlc.country, vllt.license_type,
          vtn.lang_id, vtn.selectable, vtn.tenant_id
     FROM vw_trade_name vtn JOIN vw_lco_country vlc
          ON (vtn.country_id = vlc.country_id)
          JOIN vw_lltyp_license_type vllt
          ON (vtn.license_type_id = vllt.license_type_id)
          ;