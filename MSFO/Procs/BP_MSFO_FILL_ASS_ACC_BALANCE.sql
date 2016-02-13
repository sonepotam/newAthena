CREATE OR REPLACE procedure bp_msfo_fill_ASS_ACC_BALANCE is
/*
   Назначение  : Заполнение ASS_ACCOUNT_BALANCE
   Наименование: bp_msfo_fill_ASS_ACC_BALANCE 
   Автор       : Цейтлин П.М.
   Версия      : 1.0.1
   .0 

История проекта
Дата       Автор  	    Изменение
------------------------------------------------------------------------
21.07.2004 Цейтлин П.М. Создана процедура
22.07.2004 Цейтлин П.М. Переведена на новую систему признаков
*/
 assRow ASS_ACCOUNT_BALANCE%rowtype;
begin
 update ASS_ACCOUNT_BALANCE
  set rec_process = 0
  where System_Code_System = 'ATHENA';
 for rec in ( 
   select bp_msfo_decodechapter( acc.maingeneralacc) glava, 
     'BANK_RUR' planSch, acc.code,
     bp_msfo_decodechapter( acc.maingeneralacc) glavaCode, 
     cr.CodeIsoAlph, acc.sysfilial depart,
     'ATHENA' uchSystem, 
     to_Char( acc.opened, 'yyyymmdd') opened,
     substr( acc.code,1,5) balAccount
   from account acc, currency cr, doctree dt
   where acc.Currency = cr.Classified
     and acc.doc = dt.classified
	 and dt.DOCSTATE in ( Constants.State_Close, Constants.State_Start)
     and dt.doctype in (select classified from doctype WHERE category in (2,3,66,67))
	 
   ) loop
   begin
     insert into ass_account_balance( 
	   chapter_code_balance, plan_bal_code_plan_bal, account_number_account,
	   chapter_code_account, curr_code_txt_currency, code_department_department,
	   system_code_system, rec_status, dt, 
	   balance_code_balance, rec_process, rec_unload)
	 values( 
	   rec.glava, rec.planSch, rec.code,
	   rec.glavaCode, rec.CodeIsoAlph, rec.depart,
	   rec.uchSystem, '0', rec.opened,
	   rec.balAccount, 1, 0);   
     exception
       when DUP_VAL_ON_INDEX then
  	     --- 
	     --- такая запись уже есть, ставим 2 т.к. ничего не изменилось
	     ---
         select ass.* into assRow from ASS_ACCOUNT_BALANCE ass
		   where ass.Account_Number_Account = rec.code
		     and ass.Code_Department_Department = rec.depart
			 and ass.System_Code_System=  rec.uchSystem;
         if rec.glava       = assRow.chapter_code_balance       and
		    rec.planSch     = assRow.plan_bal_code_plan_bal     and
            rec.code        = assRow.account_number_account     and
			rec.glavaCode   = assRow.chapter_code_account       and
            rec.CodeIsoAlph = assRow.curr_code_txt_currency     and
            rec.depart      = assRow.code_department_department and
			rec.uchSystem   = assRow.system_code_system         and
            rec.opened      = assRow.dt                         and
			rec.balAccount  = assRow.balance_code_balance then
		   -- такая запись уже есть ставим 2
		   update ASS_ACCOUNT_BALANCE ass
		     set ass.rec_status  = decode( assRow.REC_STATUS, '1', '0', ass.rec_status),
			     ass.rec_process = 1,  
			     ass.rec_unload  = decode( assRow.REC_STATUS, '1', 0, ass.rec_unload)
		   where ass.Account_Number_Account = rec.code
		     and ass.Code_Department_Department = rec.depart
			 and ass.System_Code_System=  rec.uchSystem;
		 else
		   update ASS_ACCOUNT_BALANCE ass
             set ass.chapter_code_balance       = rec.glava,
		         ass.plan_bal_code_plan_bal     = rec.planSch,
			     ass.chapter_code_account       = rec.glavaCode,
                 ass.curr_code_txt_currency     = rec.CodeIsoAlph,
                 ass.dt                         = rec.opened,
			     ass.balance_code_balance       = rec.balAccount,
				 ass.rec_status                 = '0',
				 ass.rec_process = 1,
				 ass.rec_unload = 0
		   where ass.Account_Number_Account = rec.code
		     and ass.Code_Department_Department = rec.depart
			 and ass.System_Code_System=  rec.uchSystem;
		 end if;															 	 
   end;     
 end loop;   
 update ASS_ACCOUNT_BALANCE
  set rec_status = '1', rec_unload = 0
  where System_Code_System = 'ATHENA'
    and rec_process = 0
    and rec_status = '0';	
end;
/
