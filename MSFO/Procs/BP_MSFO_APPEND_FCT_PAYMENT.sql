CREATE OR REPLACE procedure bp_msfo_Append_Fct_Payment( 
  nDoc number, nCategory number, sLabel varChar2, sDesc varChar2,
  dtStart DATE) is
/*
   Назначение  : Добавление записей в fct
   Наименование: bp_msfo_Append_Fct_Payment
   Автор       : Цейтлин П.М.
   Версия      : 1.0.0.0
   .0 

История проекта
Дата       Автор  	    Изменение
------------------------------------------------------------------------
22.07.2004 Цейтлин П.М. Создана процедура
*/
 sDebetAcc    varChar2( 200);
 sDebetGlava  varChar2( 200);
 sDebetCurr   varChar2( 200);
 sDebetDep    varChar2( 200);
 sCreditAcc   varChar2( 200);
 sCreditGlava varChar2( 200);
 sCreditCurr   varChar2( 200);
 sCreditDep    varChar2( 200);
 nSumma       number;
 bResult     boolean;
 nRecProcess number;
 payRow       fct_payment%rowtype;
begin
  --- выясним обработали уже этот документ ?
  begin
     select rec_process into nRecProcess
       from fct_Payment
     where system_code_subject = 'ATHENA'  and code = to_char( nDoc);
  exception
     when NO_DATA_FOUND then nRecProcess := 0;
  end;	 	 	
  if nRecProcess = 1 then 
    return;
  end if;	
  if bp_msfo_findCorrAccounts( nDoc, nSumma, 
     sDebetAcc, sDebetGlava, sDebetCurr, sDebetDep, 
     sCreditAcc, sCreditGlava, sCreditCurr, sCreditDep) then
    --- добавляем запись
	begin
	insert into fct_Payment( 
	  CODE, TYPEPAYMENT, PAYNUM, PAYSUM,
      PAYGROUND, DT, CODE_SUBJECT_SUBJECT, CODE_DEPARTMENT_SUBJECT,
      SYSTEM_CODE_SUBJECT, ACCOUNT_NUMBER_RECACCOUNT,
      CHAPTER_CODE_CHAPTER_REC, CURR_CODE_TXT_CURRENCY_REC,
      CODE_DEPARTMENT_DEPARTME_REC, SYSTEM_CODE_SYSTEM_REC,
      ACCOUNT_NUMBER_PAYACCOUNT, CHAPTER_CODE_CHAPTER_PAY,
      CURR_CODE_TXT_CURRENCY_PAY, CODE_DEPARTMENT_DEPARTME_PAY,
      SYSTEM_CODE_SYSTEM_PAY, REC_STATUS, 
   	  REC_UNLOAD, REC_PROCESS)
	values(
	  nDoc, null, substr(sLabel,1,50), nSumma,
	  substr(sDesc,1,250), to_char( dtStart, 'yyyymmdd'), null, null,
	  'ATHENA', sCreditAcc, 
	  sCreditGlava, sCreditCurr,
	  sCreditDep, 'ATHENA',
	  sDebetAcc, sDebetGlava,
	  sDebetCurr, sDebetDep,
	  'ATHENA', '0',
	  1, 0);
  exception 
    when DUP_VAL_ON_INDEX then 
	  -- такая запись уже есть
	  select * into payRow from fct_Payment 
	    where code = nDoc and system_code_subject = 'ATHENA';
	  if payRow.CODE      || payRow.TYPEPAYMENT ||
		 payRow.PAYNUM    || payRow.PAYSUM      || 
         payRow.PAYGROUND || payRow.DT          ||
		 payRow.CODE_SUBJECT_SUBJECT || payRow.CODE_DEPARTMENT_SUBJECT ||
         payRow.SYSTEM_CODE_SUBJECT  || payRow.ACCOUNT_NUMBER_RECACCOUNT || 
         payRow.CHAPTER_CODE_CHAPTER_REC   || payRow.CURR_CODE_TXT_CURRENCY_REC ||
         payRow.CODE_DEPARTMENT_DEPARTME_REC     || payRow.SYSTEM_CODE_SYSTEM_REC ||
         payRow.ACCOUNT_NUMBER_PAYACCOUNT  || payRow.CHAPTER_CODE_CHAPTER_PAY ||
         payRow.CURR_CODE_TXT_CURRENCY_PAY || payRow. CODE_DEPARTMENT_DEPARTME_PAY ||
         payRow.SYSTEM_CODE_SYSTEM_PAY  =
	     nDoc || nCategory ||
		 sLabel || nSumma ||
	     sDesc  || to_char( dtStart, 'yyyymmdd') ||
		 '' || '' ||
	     '' || sCreditAcc || 
    	 sCreditGlava || sCreditCurr ||
	     sCreditDep || 'ATHENA' ||
	     sDebetAcc  ||  sDebetGlava ||
	     sDebetCurr || sDebetDep ||
	     'ATHENA' then
		  -- поля идентичны
 	      update fct_Payment 
		    set rec_status = 0, rec_process = 1, rec_unload = 0
 	        where code = nDoc 
			  and system_code_subject = 'ATHENA'
			  and rec_Status = '1';
		else
 	      update fct_Payment 
		    set TYPEPAYMENT = null,
			    PAYNUM = substr(sLabel,1,50), 
				PAYSUM = nSumma,
                PAYGROUND = substr(sDesc,1,250), 
				DT = to_char( dtStart, 'yyyymmdd'), 
				CODE_SUBJECT_SUBJECT = '', 
				CODE_DEPARTMENT_SUBJECT = '',
                SYSTEM_CODE_SUBJECT = 'ATHENA', 
				ACCOUNT_NUMBER_RECACCOUNT = sCreditAcc,
                CHAPTER_CODE_CHAPTER_REC = sCreditGlava, 
				CURR_CODE_TXT_CURRENCY_REC = sCreditCurr,
                CODE_DEPARTMENT_DEPARTME_REC = sCreditDep, 
				SYSTEM_CODE_SYSTEM_REC = 'ATHENA',
                ACCOUNT_NUMBER_PAYACCOUNT = sDebetAcc, 
				CHAPTER_CODE_CHAPTER_PAY = sDebetGlava,
                CURR_CODE_TXT_CURRENCY_PAY = sDebetCurr, 
				CODE_DEPARTMENT_DEPARTME_PAY = sDebetDep,
                SYSTEM_CODE_SYSTEM_PAY = 'ATHENA',			
   			    rec_status = '0', rec_process = 1, rec_unload = 0
 	        where code = nDoc 
			  and system_code_subject = 'ATHENA';
		end if; 		  
  end;	  	    
  end if;		   
end;
/
