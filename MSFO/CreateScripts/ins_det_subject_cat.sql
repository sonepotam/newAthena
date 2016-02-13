Insert into det_subject_cat(SUBJECT_CAT_CODE, SUBJECT_CAT_NAME, DT, REC_STATUS, REC_UNLOAD, REC_PROCESS, SYSMOMENT)
 Values('CodeCFD', 'Привязка к ЦФУ', '01-01-1980', '0', 1, 1, TO_DATE('12/22/2004 20:18:49', 'MM/DD/YYYY HH24:MI:SS'));
Insert into det_subject_cat(SUBJECT_CAT_CODE, SUBJECT_CAT_NAME, DT, REC_STATUS, REC_UNLOAD, REC_PROCESS, SYSMOMENT)
 Values('PensionFund', 'Признак пенсионного фонда', '01-01-1980', '0', 1, 1, TO_DATE('12/22/2004 13:13:55', 'MM/DD/YYYY HH24:MI:SS'));
Insert into det_subject_cat(SUBJECT_CAT_CODE, SUBJECT_CAT_NAME, DT, REC_STATUS, REC_UNLOAD, REC_PROCESS, SYSMOMENT)
 Values('Bank', 'Признак банка', '01-01-1980', '0', 1, 1, TO_DATE('12/22/2004 20:19:15', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
