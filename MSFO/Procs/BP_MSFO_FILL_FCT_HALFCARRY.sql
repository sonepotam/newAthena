CREATE OR REPLACE procedure bp_msfo_fill_fct_HalfCarry( dtStart DATE) is
/*
   Назначение  : Заполнение fct_HalfCarry
   Наименование: bp_msfo_fill_fct_HalfCarry
   Автор       : Цейтлин П.М.
   Версия      : 1.5.1.0.

История проекта
Дата       Автор  	    Изменение
------------------------------------------------------------------------
17.01.2005 Митушин А.С. Убрано ограничение на категорию счетов для FCT_REVAL
13.01.2005 Митушин А.С. Изменено согласно новой структуры данных
24.12.2004 Митушин А.С. Добавлено заполнение fct_reval
17.12.2004 Митушин А.С. SysFilial больше не используется
24.09.2004 Митушин А.С. Изменено согласно новой структуры данных
22.07.2004 Цейтлин П.М. Создана процедура

*/

nCB 	   number;
nRUR 	   number;
o1	   	   fct_HalfCarry%rowtype;
o2	   	   fct_Reval%rowtype;
nCounter   number := 1;
nInterval  number := 100;
RevCode	   fct_reval.code%type;

begin

	 update fct_HalfCarry set rec_process=0 where dt=to_char(dtStart,'dd-mm-yyyy');	  
	 update fct_Reval set rec_process=0 where dt=to_char(dtStart,'dd-mm-yyyy');	  
	 
  	 select classified into nCB from exchMatrix where Label = 'Курсы валют ЦБ';
	 select classified into nRUR from currency where codecb='810'; 
	 
  	 for rec in (
   	   select BP_MSFO_GetDepart(a.sysfilial)||'#ATHENA#'||to_char(mo.doc) code, 
	   mo.amount value, round( mo.amount * Rate( a.Currency, nRUR, nCB, mo.OperDate), 2) value_nat,
       dtd.label docnum, substr(dtd.description,1,250) halfcarry_ground,
	   to_char( mo.operdate, 'dd-mm-yyyy') dt,
	   '-1' roleaccount_deal_code, dtd.category, mo.doc,
	   BP_MSFO_GetDepart(a.sysfilial)||'#ATHENA#'||to_char(mo.account) account_code
   	   from onesidememoorder mo, doctree dtm, doctree dtd, account a
   	   where mo.operdate>=dtStart and mo.operdate<dtStart+1 and
	   dtm.classified=mo.doc and dtd.classified=dtm.parent and
	   a.classified=mo.account

	 ) loop
   	   if mod( nCounter, nInterval) = 0 then
	     dbms_application_info.Set_Module( 'bp_msfo_fill_fct_HalfCarry', to_char(dtStart,'DD.MM.YYYY')||'/'||to_char(nCounter));
   	   end if;
   	   nCounter := nCounter + 1;

   	   begin
   	     insert into fct_HalfCarry(
     	   code, value, value_nat, docnum,
	 	   halfcarry_ground, dt,
		   roleaccount_deal_code, account_code,
		   rec_status, rec_process, rec_unload
		 ) values(
     	   rec.code, rec.value, rec.value_nat, rec.docnum,
	 	   rec.halfcarry_ground, rec.dt,
		   rec.roleaccount_deal_code, rec.account_code,
		   '0',1,0
		 );
	   exception
         when dup_val_on_index then
	       select * into o1 from fct_HalfCarry where code=rec.code;
		   
		   if rec.value			  	  = o1.value and
		      rec.value_nat		  	  = o1.value_nat and
		      rec.docnum		  	  = o1.docnum and
	          rec.halfcarry_ground	  = o1.halfcarry_ground and
		      rec.dt			  	  = o1.dt and
			  rec.roleaccount_deal_code = o1.roleaccount_deal_code and
			  rec.account_code 		  = o1.account_code then

		   	  if o1.rec_status='1' then
  		        update fct_HalfCarry set rec_status='0', rec_process=1, rec_unload=0
		        where code=rec.code;
		   	  else
  		        update fct_HalfCarry set rec_process=1 where code=rec.code;
		   	  end if;
		   else
		     update fct_HalfCarry
		     set value = rec.value,
		         value_nat = rec.value_nat,
		         docnum = rec.docnum,
	             halfcarry_ground = rec.halfcarry_ground,
		         dt = rec.dt,
		         roleaccount_deal_code = rec.roleaccount_deal_code,
				 account_code = rec.account_code,
			   	 rec_status = '0',
				 rec_process = 1,
				 rec_unload = 0
			 where code = rec.code;
		   end if;
	   end;

	   if rec.category=20 then
	     -- Смена курса валют
		 for rev in (
		   select BP_MSFO_GetDepart(a.sysfilial)||'#ATHENA#' idPref,  
		   to_char( mo.operdate, 'dd-mm-yyyy') dt, mo.amount reval_sum,
	   	   BP_MSFO_GetDepart(a.sysfilial)||'#ATHENA#'||to_char(mo.account) account_code,
		   BP_MSFO_GetDepart(a.sysfilial)||'#ATHENA#'||to_char(mo.doc) halfcarry_code 
		   from moratediff mo, account a
		   where mo.doc=rec.doc and a.classified=mo.account
--		   a.category in (2,66) and a.isbalancehide<>1	   
		 ) loop
		   begin
		     select * into o2 from fct_Reval where dt=rev.dt and
			 halfcarry_code=rev.halfcarry_code and account_code=rev.account_code;
			 
			 if o2.reval_sum       <> rev.reval_sum then

		        update fct_reval
		     	set reval_sum = rev.reval_sum,
				    rec_status = '0',
				  	rec_process = 1,
				  	rec_unload = 0
			    where dt=rev.dt and halfcarry_code=rev.halfcarry_code and 
				account_code=rev.account_code;
			 else
		   	   if o2.rec_status='1' then
  		         update fct_reval set rec_status='0', rec_process=1, rec_unload=0
		         where dt=rev.dt and halfcarry_code=rev.halfcarry_code and 
				 account_code=rev.account_code;
		   	   else
  		         update fct_reval set rec_process=1 
				 where dt=rev.dt and halfcarry_code=rev.halfcarry_code and 
				 account_code=rev.account_code;
		   	   end if;			 
			 end if;	
		   
		   exception
		     when no_data_found then
			   
		       insert into fct_reval (
		         code, dt, reval_sum, halfcarry_code, account_code,
		         rec_status, rec_process, rec_unload
		       ) values (
		         rev.idPref||to_char(bp_seq_reval_code.nextval), 
				 rev.dt, rev.reval_sum, rev.halfcarry_code, rev.account_code,
		         '0',1,0
		       );		  			 
		   end;
	   
		 end loop;
	   end if;
	   
  	 end loop;
	 
	 update fct_HalfCarry set rec_status = '1', rec_unload = 0
	 where rec_process = 0 and rec_status = '0' and dt=to_char(dtStart,'dd-mm-yyyy');	 	 
	 update fct_Reval set rec_status = '1', rec_unload = 0
	 where rec_process = 0 and rec_status = '0' and dt=to_char(dtStart,'dd-mm-yyyy');	 	 

  	 dbms_application_info.Set_Module( '', '');
end;
/
