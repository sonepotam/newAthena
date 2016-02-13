Insert into det_subject_cat_val(SUBJECT_CAT_VAL_CODE, SUBJECT_CAT_VAL_NAME, DT, SUBJECT_CAT_CODE, REC_STATUS, REC_UNLOAD, REC_PROCESS, SYSMOMENT)
 Values('1', 'Клиент является пенсионным фондом', '01-01-1980', 'PensionFund', '0', 1, 1, TO_DATE('12/22/2004 13:13:55', 'MM/DD/YYYY HH24:MI:SS'));
Insert into det_subject_cat_val(SUBJECT_CAT_VAL_CODE, SUBJECT_CAT_VAL_NAME, DT, SUBJECT_CAT_CODE, REC_STATUS, REC_UNLOAD, REC_PROCESS, SYSMOMENT)
 Values('1', 'Клиент является банком', '01-01-1980', 'Bank', '0', 1, 1, TO_DATE('12/22/2004 20:26:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
