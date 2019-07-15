CREATE TABLE e2b_info_temp
    AS SELECT *
    FROM e2b_info WHERE 1 = 2;
ALTER TABLE e2b_info_temp ADD CONSTRAINT pk_e2b_info_temp PRIMARY KEY ( report_id,tenant_id );

CREATE TABLE messages_addl_temp
    AS SELECT *
    FROM messages_addl WHERE 1 = 2;
ALTER TABLE messages_addl_temp ADD CONSTRAINT pk_messages_addl_temp PRIMARY KEY ( msg_id,tenant_id );

CREATE TABLE acknowledgment_addl_temp
    AS SELECT *
    FROM acknowledgment_addl WHERE 1 = 2;
ALTER TABLE acknowledgment_addl_temp ADD CONSTRAINT pk_acknowledgment_addl_temp PRIMARY KEY ( ack_id,tenant_id );

CREATE OR REPLACE SYNONYM &userst..activesubstance_addl FOR &usertx..activesubstance_addl;

CREATE TABLE act_subs_addl_temp
    AS SELECT *
    FROM activesubstance_addl WHERE 1 = 2;
ALTER TABLE act_subs_addl_temp
    ADD CONSTRAINT pk_act_subs_addl_temp PRIMARY KEY ( report_id,drug_id,tenant_id,activesubstance_id );
	
