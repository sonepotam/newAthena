CREATE OR REPLACE PROCEDURE bp_msfo_fill_fct_account(dDate IN DATE) IS
/***********************************************************************
* ���������� ������ ��� ���� - ������� FCT_ACCOUNT
* ����� - �������� �.�.
* ������ 1.2
* ���� � VSS: $/��������� ������������� ����������/�������� ��� ����/������� ��� �������� ������
************************************************************************/
 rwFctAF FCT_ACCOUNT%ROWTYPE; -- �� �����
 rwFctBUF FCT_ACCOUNT%ROWTYPE; -- �� �������
 iCnt PLS_INTEGER:=0;
 iInterval PLS_INTEGER:=100;
 dDateLast DATE;
BEGIN
 DBMS_APPLICATION_INFO.SET_MODULE('BP_MSFO_FILL_FCT_ACCOUNT','');
 dDateLast:=TRUNC(dDate)+1-1/(24*60*60);
 rwFctAF.dt:=TO_CHAR(dDateLast,'YYYYMMDD');
 rwFctAF.system_code_system:='ATHENA';
 -- ������� REC_PROCESS ��� ��������� ������ ������
 UPDATE fct_account f SET rec_process=0
  WHERE f.system_code_system=rwFctAF.system_code_system
	  AND f.dt=rwFctAF.dt;
 -- ��������� ������	  
 FOR rwAcc IN
 (
  SELECT  /*+ FIRST_ROWS */  a.code, a.classified, d.sysfilial,
    c.codeisoalph, DECODE(a.category,2,'�',3,'�',66,'�',67,'�',1001,'�') CODE_CHAPTER  
   FROM account a, doctree d, currency c
  WHERE a.doc=d.classified
   AND d.docstate IN (SELECT classified FROM docstate WHERE conststate in (1,3))
   AND a.currency=c.classified
 )
 LOOP
  BEGIN
   iCnt:=iCnt+1;
   rwFctAF.rest:=TO_CHAR(NVL(accrestout(rwAcc.classified,dDateLast,1,0),0));
   rwFctAF.debet:=TO_CHAR(NVL(accountturnde(rwAcc.classified,TRUNC(dDateLast),dDateLast,1),0));
   rwFctAF.credit:=TO_CHAR(NVL(accountturncr(rwAcc.classified,TRUNC(dDateLast),dDateLast,1),0));
   IF rwAcc.codeisoalph='RUR' THEN
    rwFctAF.rest_nat:=rwFctAF.rest;
    rwFctAF.debet_nat:=rwFctAF.debet;
    rwFctAF.credit_nat:=rwFctAF.credit;
   ELSE
    rwFctAF.rest_nat:=TO_CHAR(NVL(accrestout(rwAcc.classified,dDateLast,5,0),0));
    rwFctAF.debet_nat:=TO_CHAR(NVL(accountturnde(rwAcc.classified,TRUNC(dDateLast),dDateLast,5),0));
    rwFctAF.credit_nat:=TO_CHAR(NVL(accountturncr(rwAcc.classified,TRUNC(dDateLast),dDateLast,5),0));
   END IF;
   rwFctAF.account_number_account:=rwAcc.code;
   rwFctAF.chapter_code_chapter:=rwAcc.code_chapter;
   rwFctAF.curr_code_txt_currency:=rwAcc.codeisoalph;
   rwFctAF.code_department_department:=TO_CHAR(rwAcc.sysfilial);
   -- ���������� ����� �������
   INSERT INTO fct_account
    (
     dt, rest, rest_nat, debet, debet_nat, credit, credit_nat,
     account_number_account, chapter_code_chapter, curr_code_txt_currency,
     code_department_department, system_code_system, rec_status, rec_process, rec_unload
    )
    VALUES 
    (
     rwFctAF.dt,
     rwFctAF.rest,
     rwFctAF.rest_nat,
	 rwFctAF.debet,
	 rwFctAF.debet_nat,
	 rwFctAF.credit,
	 rwFctAF.credit_nat,
	 rwFctAF.account_number_account,
	 rwFctAF.chapter_code_chapter,
	 rwFctAF.curr_code_txt_currency,
	 rwFctAF.code_department_department,
	 rwFctAF.system_code_system,
	 '0',
	 1,
	 0
    );
  EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
    -- ����� ������ ��� ����
    -- �������� �� ����������
	SELECT * INTO rwFctBUF
	  FROM fct_account f
	 WHERE f.account_number_account=rwFctAF.account_number_account
	  AND f.code_department_department=rwFctAF.code_department_department
	  AND f.system_code_system=rwFctAF.system_code_system
	  AND f.dt=rwFctAF.dt;
	IF   
      rwFctAF.rest||
      rwFctAF.rest_nat||
  	  rwFctAF.debet||
 	  rwFctAF.debet_nat||
	  rwFctAF.credit||
	  rwFctAF.credit_nat||
	  rwFctAF.chapter_code_chapter||
	  rwFctAF.curr_code_txt_currency
	  =
      rwFctBUF.rest||
      rwFctBUF.rest_nat||
	  rwFctBUF.debet||
	  rwFctBUF.debet_nat||
	  rwFctBUF.credit||
	  rwFctBUF.credit_nat||
	  rwFctBUF.chapter_code_chapter||
	  rwFctBUF.curr_code_txt_currency
	THEN
	 -- ������ �� ��������
	 IF rwFctBuf.rec_status='1' THEN
	  -- ���������������
      UPDATE fct_account f 
	    SET rec_status='0', rec_process=1, rec_unload=0
	   WHERE f.account_number_account=rwFctAF.account_number_account
 	    AND f.code_department_department=rwFctAF.code_department_department
	    AND f.system_code_system=rwFctAF.system_code_system
	    AND f.dt=rwFctAF.dt;
	 ELSE
	  -- �� �� ������
      UPDATE fct_account f 
	    SET rec_process=1
	   WHERE f.account_number_account=rwFctAF.account_number_account
 	    AND f.code_department_department=rwFctAF.code_department_department
	    AND f.system_code_system=rwFctAF.system_code_system
	    AND f.dt=rwFctAF.dt;
	 END IF;	
	ELSE
	 -- ������ ��������  
	 UPDATE fct_account SET
      rest=rwFctAF.rest,
      rest_nat=rwFctAF.rest_nat,
	  debet=rwFctAF.debet,
	  debet_nat=rwFctAF.debet_nat,
	  credit=rwFctAF.credit,
	  credit_nat=rwFctAF.credit_nat,
	  chapter_code_chapter=rwFctAF.chapter_code_chapter,
	  curr_code_txt_currency=rwFctAF.curr_code_txt_currency,
      rec_status='0',
	  rec_process=1,
	  rec_unload=0;
	END IF; 
  END;	
  IF iCnt/iInterval=ROUND(iCnt/iInterval) THEN
   DBMS_APPLICATION_INFO.SET_ACTION(TO_CHAR(iCnt)||' accounts processed');
  END IF;
 END LOOP;
 -- ��������� ��������� ������� ��� ��������� ������ ������
 UPDATE fct_account f SET rec_status='1', rec_unload=0
  WHERE f.system_code_system=rwFctAF.system_code_system
	  AND f.dt=rwFctAF.dt
	  AND f.rec_status='0'
	  AND f.rec_process=0;
END;
/
