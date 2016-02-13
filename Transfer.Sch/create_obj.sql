DROP TABLE BP_TMP_REPORT CASCADE CONSTRAINTS ; 

CREATE GLOBAL TEMPORARY TABLE BP_TMP_REPORT ( 
  CLASSIFIED  NUMBER (10), 
  DEBSCHET    VARCHAR2 (20), 
  CREDSCHET   VARCHAR2 (20), 
  DOCTYPE     NUMBER (10), 
  AMOUNT      NUMBER (24,3), 
  OPERDATE    DATE, 
  PRIORITY    NUMBER (4), 
  PAR1        VARCHAR2 (250), 
  PAR2        VARCHAR2 (250), 
  PAR3        VARCHAR2 (250), 
  PAR4        VARCHAR2 (250), 
  PAR5        VARCHAR2 (250), 
  NPAR1       NUMBER (24,3), 
  NPAR2       NUMBER (24,3), 
  NPAR3       NUMBER (24,3), 
  NPAR4       NUMBER (24,3), 
  NPAR5       NUMBER (24,3) ) ; 

grant select, update, delete, insert on bp_tmp_report to BBR;
