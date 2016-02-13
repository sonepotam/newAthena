---
--- Этот скрипт содержит временную таблицу для генератора отчетов
---

DROP TABLE BP_TMP_REPORT CASCADE CONSTRAINTS ; 

CREATE GLOBAL TEMPORARY TABLE BP_TMP_REPORT ( 
  CLASSIFIED  NUMBER (10), 
  DEBSCHET    VARCHAR2 (20), 
  CREDSCHET   VARCHAR2 (20), 
  DOCTYPE     NUMBER (10), 
  AMOUNT      NUMBER (24,3), 
  OPERDATE    DATE, 
  PRIORITY    NUMBER (4) ) on commit delete rows; 

grant select, update, delete, insert on bp_tmp_report to BBR;