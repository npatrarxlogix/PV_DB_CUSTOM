CREATE TABLE activesubstance_addl (
    report_id                     NUMBER,
    drug_id                       NUMBER,
    activesubstance_id            NUMBER,
    activesubstancename           VARCHAR2(2000),
    tenant_id                     NUMBER,
    specifiedsubstancetermid      VARCHAR2(2000),
    specifiedsubstancetermidver   VARCHAR2(2000),
    strengthunit                  VARCHAR2(500),
    strength                      NUMBER
);

ALTER TABLE activesubstance_addl
    ADD CONSTRAINT pk_activesubstance_addl PRIMARY KEY ( report_id,drug_id,tenant_id,activesubstance_id );

GRANT SELECT,INSERT,UPDATE,DELETE ON &usertx..activesubstance_addl TO &userst.;