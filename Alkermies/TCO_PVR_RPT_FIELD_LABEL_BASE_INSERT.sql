BEGIN 

INSERT INTO pvr_rpt_field_label_base(CODE, LOC, TEXT)
VALUES (
'app.reportField.vcmacFlagIndSubmission',  '*', 'IND Submission to FDA?'
);

INSERT INTO pvr_rpt_field_label_base (CODE, LOC, TEXT)
VALUES (
'app.reportField.vcmacFlagNdaSubmission',  '*', 'NDA Submission to FDA?'
);

INSERT INTO pvr_rpt_field_label_base (CODE, LOC, TEXT)
VALUES (
'app.reportField.vcmacFlagPeriodicSubmission', '*', 'Periodic Submission to FDA?'
);

INSERT INTO pvr_rpt_field_label_base (CODE, LOC, TEXT)
VALUES (
'app.reportField.vcmacFlagLpSubmission', '*', 'License Partner Submission?'
);

INSERT INTO pvr_rpt_field_label_base (CODE, LOC, TEXT)
VALUES (
'app.reportField.vcmacflaginvalid', '*', 'Invalid case?'
);

COMMIT;

END;
/