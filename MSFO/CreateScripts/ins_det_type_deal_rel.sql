Insert into det_type_deal_rel
   (CODE, NAME, DT, REC_STATUS, REC_UNLOAD, REC_PROCESS, SYSMOMENT)
 Values
   ('SWAP', 'SWAP', '01-01-1980', '0', 1, 1, TO_DATE('12/22/2004 13:13:56', 'MM/DD/YYYY HH24:MI:SS'));
Insert into det_type_deal_rel
   (CODE, NAME, DT, REC_STATUS, REC_UNLOAD, REC_PROCESS, SYSMOMENT)
 Values
   ('Prolongation', 'Пролонгация', '01-01-1980', '0', 1, 1, TO_DATE('12/22/2004 13:13:56', 'MM/DD/YYYY HH24:MI:SS'));
Insert into det_type_deal_rel
   (CODE, NAME, DT, REC_STATUS, REC_UNLOAD, REC_PROCESS, SYSMOMENT)
 Values
   ('Guarantee', 'Обеспечение', '01-01-1980', '0', 1, 1, TO_DATE('12/22/2004 13:13:56', 'MM/DD/YYYY HH24:MI:SS'));
Insert into det_type_deal_rel
   (CODE, NAME, DT, REC_STATUS, REC_UNLOAD, REC_PROCESS, SYSMOMENT)
 Values
   ('ChildDealY', 'Дочерняя внутренняя сделка по ЦФУ', '01-01-1980', '0', 1, 1, TO_DATE('12/22/2004 13:13:56', 'MM/DD/YYYY HH24:MI:SS'));
Insert into det_type_deal_rel
   (CODE, NAME, DT, REC_STATUS, REC_UNLOAD, REC_PROCESS, SYSMOMENT)
 Values
   ('CreditLine', 'Транш в рамках кредитной линии', '01-01-1980', '0', 1, 1, TO_DATE('12/22/2004 20:31:40', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
