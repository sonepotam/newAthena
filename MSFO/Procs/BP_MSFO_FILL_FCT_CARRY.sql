CREATE OR REPLACE procedure bp_msfo_fill_fct_Carry( dtStart DATE) is
/*
   Назначение  : Заполнение fct_Carry
   Наименование: bp_msfo_fill_fct_Carry
   Автор       : Цейтлин П.М.
   Версия      : 1.4.0.0

История проекта
Дата       Автор  	    Изменение
------------------------------------------------------------------------
17.12.2004 Митушин А.С. SysFilial больше не используется
26.10.2004 Митушин А.С. Добавлено заполнение ASS_CARRYPAYMENT
30.09.2004 Митушин А.С. Изменено согласно новой структуры данных
21.07.2004 Цейтлин П.М. Создана процедура
*/

type TClntInfo is record (
	   Name	   fct_clpayment.payname%type,
	   INN	   fct_clpayment.payinn%type,
	   KPP	   fct_clpayment.paykpp%type,
	   BIC	   fct_clpayment.paybankswift%type,
	   BIK	   fct_clpayment.paybankbic%type,
	   Country fct_clpayment.paycountry%type,
	   Address fct_clpayment.payaddress%type
	 );

nCounter   number := 1;
nInterval  number := 100;

csINN	   number;
csKPP	   number;
csBIK	   number;
csBIC	   number;
nRes	   number;
nKorr	   number;
nCB 	   number;
nRUR	   number;
idBank	   number;
KorrDeb    fct_clpayment.paybankaccount%type:=null;
KorrCred   fct_clpayment.paybankaccount%type:=null;

NewRec1	   fct_carry%rowtype;
OldRec1	   fct_carry%rowtype;
NewRec2	   fct_payment%rowtype;
OldRec2	   fct_payment%rowtype;
NewRec3	   fct_clpayment%rowtype;
OldRec3	   fct_clpayment%rowtype;
NewRec4	   ass_carrypayment%rowtype;
OldRec4	   ass_carrypayment%rowtype;

Cl		   TClntInfo;
MDM_Deb	   TClntInfo;
MDM_Cred   TClntInfo;
ct		   customertransfer%rowtype;
ci		   customeriso%rowtype;

procedure FindClientInfo(idClnt in number,
		 x in out TClntInfo,
		 InnFlag in boolean default True,
		 BICFlag in boolean default True,
		 BIKFlag in boolean default True,
		 CountryFlag in boolean default True,
		 AddrFlag in boolean default True ) as

nReg	  client.clientregion%type;
cReg	  clientregiontree.label%type;
stRes	  number;
RUS		  varchar2(3) := '643';
isPhiz	  number;

begin
	 x.Name:=null;
	 x.INN:=null;
	 x.KPP:=null;
	 x.BIC:=null;
	 x.BIK:=null;
	 x.Country:=null;
	 x.Address:=null;
	 begin
	   select nvl(c.description,c.label), c.taxid, c.clientregion, t.isphys
	   into x.Name,x.INN,nReg, isPhiz
	   from client c, clienttype t where c.classified=idClnt and
	   t.classified=c.type;
	   if InnFlag then
	     -- ИНН
	     begin
		   select code into x.INN from bankcode
		   where client=idClnt and codesystem=csINN and
		   nvl(validfromdate,dtStart)<=dtStart and
		   nvl(validtodate,dtStart+1)>dtStart;
		 exception
		   when no_data_found or too_many_rows then null;
		 end;
		 -- КПП
	     begin
		   select code into x.KPP from bankcode
		   where client=idClnt and codesystem=csKPP and
		   nvl(validfromdate,dtStart)<=dtStart and
		   nvl(validtodate,dtStart+1)>dtStart;
		 exception
		   when no_data_found or too_many_rows then null;
		 end;
	   end if;

	   if BICFlag then
	     -- SWIFT
	     begin
		   select code into x.BIC from bankcode
		   where client=idClnt and codesystem=csBIC and
		   nvl(validfromdate,dtStart)<=dtStart and
		   nvl(validtodate,dtStart+1)>dtStart;
		 exception
		   when no_data_found or too_many_rows then null;
		 end;
	   end if;

	   if BIKFlag then
	     -- БИК
	     begin
		   select code into x.BIK from bankcode
		   where client=idClnt and codesystem=csBIK and
		   nvl(validfromdate,dtStart)<=dtStart and
		   nvl(validtodate,dtStart+1)>dtStart;
		 exception
		   when no_data_found or too_many_rows then null;
		 end;
	   end if;

	   if CountryFlag then
	     if nReg is not null then
	       -- Если есть, то находим название страны
	       select upper(label) into cReg from clientregiontree
		   where lev=0 start with classified=nReg
		   connect by prior parent=classified;

		   begin
		     -- Находим код страны по det_country
		     select country_code_num into x.Country
		     from det_country where country_name=cReg;
		   exception
		     when no_data_found then
		     -- не находим, считаем, что неопределено
		     x.Country:=null;
		   end;
	     else
	       -- Проверяем на резидентность
		   begin
		     select nvl(status,1) into stRes from objprop where prop=nRes and doc=idClnt;
		   exception
		     when no_data_found then
		     -- Признака нет, счтаем, что резидент
		     stRes:=1;
		   end;
		   if stRes=1 then
		     -- Резидент, считаем, что Россия
		     x.Country:=RUS;
		   else
		     -- Иначе неопределено
		     x.Country:=null;
		   end if;
	   	 end if;
	   end if;

	   if AddrFlag then
	     if isPhiz=1 then
		   x.Address:=ClientAnyAddress(idClnt,'AddressPost');
		 else
		   x.Address:=ClientAnyAddress(idClnt,'AddressJur');
		 end if;
	   end if;
	 exception
	   when no_data_found then
	     null;
	 end;
end;

begin
  	 dbms_application_info.Set_Module( 'bp_msfo_fill_fct_Carry', '');

	 select classified into nKorr from accounttype where constacctype=34; -- Кор.счета
	 select classified into csBIC from codesystem where const=1;  -- SWIFTы
	 select classified into csBIK from codesystem where const=7;  -- БИКи
	 select classified into csINN from codesystem where const=20; -- ИННы
	 select classified into csKPP from codesystem where const=25; -- КППшки
	 select classified into nRes from proplist where constprop=6; -- Признак резидента
  	 select classified into nCB from exchMatrix where Label = 'Курсы валют ЦБ';
	 select classified into nRUR from currency where codecb='810';
	 	 
	 
	 update fct_Carry set rec_process=0 where dt=to_char(dtStart,'dd-mm-yyyy');	 

  	 for rec in (
	   select mo.classified idMem, mo.amount Summa, dtd.label NDoc,
       dtd.description AboutDoc, mo.operdate dt, dtd.classified idDoc,
	   dtm.label NMem, dtm.description AboutMem, mo.sysfilial SysFil,
	   ad.classified idAccDeb, ad.code AccDeb, ad.Label AccDebName,
	   ad.currency idCurDeb, tcd.codeisoalph CurDeb, ad.client idClntDeb,
	   ac.classified idAccCred, ac.code AccCred, ac.Label AccCredName,
	   ac.currency idCurCred, tcc.codeisoalph CurCred, ac.client idClntCred,
	   prd.OurBank BankDeb, prc.OurBank BankCred,
	   prd.NostroAccount idKorrDeb, prc.NostroAccount idKorrCred,
	   ad.sysfilial DebSysFil, ac.sysfilial CredSysFil,
	   dtd.Category Category
   	   from memoorder mo, doctree dtm, doctree dtd, account ad, account ac,
	   currency tcd, currency tcc, preference prd, preference prc
   	   where mo.operdate>=dtStart and mo.operdate<dtStart+1 and --mo.sysfilial=SysFil and
	   dtm.classified=mo.doc and dtd.classified=dtm.parent and
	   ad.classified=mo.accountdeb and ac.classified=mo.accountcred and
	   tcd.classified=ad.currency and tcc.classified=ac.currency and
	   prd.sysfilial=ad.sysfilial and prc.sysfilial=ac.sysfilial
	 ) loop
   	   if mod( nCounter, nInterval) = 0 then
         dbms_application_info.set_action( 'Обработано = ' || nCounter);
   	   end if;
   	   nCounter := nCounter + 1;

	   NewRec1.code := BP_MSFO_GetDepart(rec.sysfil)||'#ATHENA#'||to_char(rec.idMem);
	   NewRec1.value := rec.Summa;
	   NewRec1.value_nat := round( rec.Summa * Rate( rec.idCurDeb, nRUR, nCB, rec.dt), 2);
	   NewRec1.docnum := rec.NMem;
	   NewRec1.carry_ground := SubStr(rec.AboutMem,1,250);
	   NewRec1.dt := to_char( rec.dt, 'dd-mm-yyyy');
	   NewRec1.rolecredit_code := '-1';
	   NewRec1.roledebet_code := '-1';
	   NewRec1.account_debet_code := BP_MSFO_GetDepart(rec.DebSysFil)||'#ATHENA#'||to_char(rec.idAccDeb);
	   NewRec1.account_credit_code := BP_MSFO_GetDepart(rec.CredSysFil)||'#ATHENA#'||to_char(rec.idAccCred);

   	   begin
   	     insert into fct_Carry(
     	   code, value, value_nat, docnum,
	 	   carry_ground, dt,
	 	   rolecredit_code, roledebet_code,
	 	   account_credit_code, account_debet_code,
		   rec_status, rec_process, rec_unload
		 ) values(
     	   NewRec1.code, NewRec1.value, NewRec1.value_nat, NewRec1.docnum,
	 	   NewRec1.carry_ground, NewRec1.dt,
	 	   NewRec1.rolecredit_code, NewRec1.roledebet_code,
	 	   NewRec1.account_credit_code, NewRec1.account_debet_code,
		   '0',1,0
		 );
	   exception
         when dup_val_on_index then
	   	   select * into OldRec1 from fct_carry where code=NewRec1.code;

	   	   if NewRec1.value          <> OldRec1.value or
	   		  NewRec1.value_nat		 <> OldRec1.value_nat or
	   		  NewRec1.docnum		 <> OldRec1.docnum or
	   		  NewRec1.carry_ground   <> OldRec1.carry_ground or
	   		  NewRec1.dt			 <> OldRec1.dt or
	   		  NewRec1.rolecredit_code<> OldRec1.rolecredit_code or
	   		  NewRec1.roledebet_code <> OldRec1.roledebet_code then

		   	  update fct_carry r
			  set value = NewRec1.value,
		          value_nat = NewRec1.value_nat,
				  docnum = NewRec1.docnum,
				  carry_ground = NewRec1.carry_ground,
				  dt = NewRec1.dt,
				  rolecredit_code = NewRec1.rolecredit_code,
				  roledebet_code = NewRec1.roledebet_code,
				  account_credit_code = NewRec1.account_credit_code,
				  account_debet_code = NewRec1.account_debet_code,
				  rec_status = '0',
				  rec_process = 1,
				  rec_unload = 0
			  where code = NewRec1.code;
		   else
		   	  if OldRec1.rec_status='1' then
  		        update fct_carry set rec_status='0', rec_process=1, rec_unload=0
		        where code=NewRec1.code;
		   	  else
  		        update fct_carry set rec_process=1 where code=NewRec1.code;
		   	  end if;
		   end if;
	   end;
/*
	   if rec.category in (4,5,11,12,15) then
	     NewRec2.code := NewRec1.code;
		 if rec.category in (11,12) then
		   NewRec2.typepayment := -1;
		 else
		   NewRec2.typepayment := -3;
		 end if;
		 NewRec2.paynum := NewRec1.docnum;
		 NewRec2.paysum := NewRec1.value;
		 NewRec2.payground := NewRec1.carry_ground;
		 NewRec2.dt := NewRec1.dt;
		 if rec.category in (4,5) and rec.idClntDeb is not null then
		   NewRec2.subject_code := idPref||to_char(rec.idClntDeb);
		 else
		   NewRec2.subject_code := '-1';
		 end if;

		 NewRec2.payaccount_code := NewRec1.account_debet_code;
		 NewRec2.recaccount_code := NewRec1.account_credit_code;
		 	 
		 NewRec2.payfinstr_finstr_code := upper(rec.CurDeb);
		 NewRec2.recfinstr_finstr_code := upper(rec.CurCred);
		 
		 

		 begin
		   insert into fct_payment (
		     code, typepayment, paynum, paysum,
			 payground, dt, subject_code,
			 recaccount_code, payaccount_code,
			 rec_status, rec_unload, rec_process
		   ) values (
		     NewRec2.code, NewRec2.typepayment, NewRec2.paynum, NewRec2.paysum,
			 NewRec2.payground, NewRec2.dt, NewRec2.subject_code,
			 NewRec2.recaccount_code, NewRec2.payaccount_code,
		   	 '0',1,0
		   );
		 exception
		   when dup_val_on_index then
	   	     select * into OldRec2 from fct_payment where code=NewRec2.code;

			 if NewRec2.code	   		 <> OldRec2.code or
			 	NewRec2.typepayment		 <> OldRec2.typepayment or
			 	NewRec2.paynum			 <> OldRec2.paynum or
			 	NewRec2.paysum			 <> OldRec2.paysum or
			 	NewRec2.payground		 <> OldRec2.payground or
			 	NewRec2.dt				 <> OldRec2.dt or
			 	NewRec2.subject_code	 <> OldRec2.subject_code or
			 	NewRec2.recaccount_code	 <> OldRec2.recaccount_code or
			 	NewRec2.payaccount_code	 <> OldRec2.payaccount_code then

				update fct_payment
				set code = NewRec2.code,
					typepayment = NewRec2.typepayment,
					paynum = NewRec2.paynum,
					paysum = NewRec2.paysum,
					payground = NewRec2.payground,
					dt = NewRec2.dt,
					subject_code = NewRec2.subject_code,
					recaccount_code = NewRec2.recaccount_code,
					payaccount_code = NewRec2.payaccount_code,
				  	rec_status = '0',
				    rec_process = 1,
				    rec_unload = 0
			    where code = NewRec2.code;
			 else
		   	    if OldRec2.rec_status='1' then
  		          update fct_payment set rec_status='0', rec_process=1, rec_unload=0
		          where code=NewRec2.code;
		   	    else
  		          update fct_payment set rec_process=1 where code=NewRec2.code;
		   	    end if;
			 end if;
		 end;

		 NewRec4.dt := '01-01-1980';
		 NewRec4.carry_code := NewRec1.code;
		 NewRec4.payment_code := NewRec2.code;

		 begin
		   insert into ass_carrypayment (
		     dt,payment_code,carry_code,rec_status,rec_unload,rec_process
		   ) values (
		    NewRec4.dt,NewRec4.payment_code,NewRec4.carry_code,'0',1,0
		   );
		 exception
		   when dup_val_on_index then
	   	     select * into OldRec4 from ass_carrypayment where carry_code=NewRec4.carry_code;

			 if NewRec4.dt = OldRec4.dt and NewRec4.payment_code=OldRec4.payment_code then
		       if OldRec4.rec_status='1' then
  		         update ass_carrypayment set rec_status='0', rec_process=1, rec_unload=0
				 where carry_code=NewRec4.carry_code;
		   	   else
  		         update ass_carrypayment set rec_process=1
				 where carry_code=NewRec4.carry_code;
		   	   end if;
			 else
			   update ass_carrypayment
			   set dt = NewRec4.dt,
			   	   payment_code = NewRec4.payment_code,
				   rec_status = '0', rec_process = 1, rec_unload = 0
			   where carry_code=NewRec4.carry_code;
			 end if;
		 end;
		 	   
		 -- Безнал. рублевые документы
	     if rec.category in (4,5,15) and rec.idCurDeb=nRUR and rec.idCurCred=nRUR then
		   -- По умолчанию корреспондирующие счета внутренние
		   NewRec3.paydate := rec.dt;
		   NewRec3.payaccount := rec.AccDeb;
		   NewRec3.payname := rec.AccDebName;
		   NewRec3.payinn := null;
		   NewRec3.paykpp := null;
		   NewRec3.payswift := null;
		   NewRec3.payaddress := null;
		   NewRec3.paycountry := null;
		   NewRec3.recsum := NewRec1.value;
		   NewRec3.recdate := rec.dt;
		   NewRec3.recaccount := rec.AccCred;
		   NewRec3.recname := rec.AccCredName;
		   NewRec3.payment_code := NewRec1.code;
		   NewRec3.paycurrency_curr_code_txt := upper(rec.CurDeb);
		   NewRec3.reccurrency_curr_code_txt := upper(rec.CurCred);

		   -- Заполняем нашего клиента
		   -- Плательщик - наш
		   if rec.category in (4,5) then
		     FindClientInfo(rec.BankDeb,MDM_Deb,False,True,True,True,False);
			 select code into KorrDeb from account where classified=rec.idKorrDeb;	   
		   
		     NewRec3.paybankaccount := KorrDeb;
		     NewRec3.paybankname := MDM_Deb.Name;
		     NewRec3.paybankbic := MDM_Deb.BIK;
		     NewRec3.paybankswift := MDM_Deb.BIC;
		     NewRec3.paybankcountry := MDM_Deb.Country;
			 
		     if rec.idClntDeb is not null then
		       FindClientInfo(rec.idClntDeb,Cl,True,True,False,True,True);
		   	   NewRec3.payname := Cl.Name;
		   	   NewRec3.payinn := Cl.INN;
		   	   NewRec3.paykpp := Cl.KPP;
		   	   NewRec3.payswift := Cl.BIC;
		   	   NewRec3.payaddress := Cl.Address;
		   	   NewRec3.paycountry := Cl.Country;
			 end if;
		   end if;
		   
		   -- Получатель - наш
		   if rec.category in (5,11) then
		     FindClientInfo(rec.BankCred,MDM_Cred,False,True,True,True,False);
			 select code into KorrCred from account where classified=rec.idKorrCred;

		     NewRec3.recbankaccount := KorrCred;
		     NewRec3.recbankname := MDM_Cred.Name;
		     NewRec3.recbankbic := MDM_Cred.BIK;
		     NewRec3.recbankswift := MDM_Cred.BIC;
		     NewRec3.recbankcountry := MDM_Cred.Country;
		   
		     if rec.idClntCred is not null then
		       FindClientInfo(rec.idClntCred,Cl,False,False,False,False,False);
		   	   NewRec3.recname := Cl.Name;
			 end if;
		   end if;

		   -- Заполняем внешнего контрагента для кат.4 и 15
		   -- Получатель - внешний
		   if rec.category=4 then
		   	 NewRec3.recbankname := null;
			 NewRec3.recbankbic := null;
		   	 NewRec3.recbankswift := null;
		   	 NewRec3.recbankcountry := null;
		   	 NewRec3.recbankaccount := null;

		     begin
			   select * into ct from customertransfer where doc=rec.idDoc;
			   select * into ci from customeriso where doc=rec.idDoc;

			   NewRec3.recaccount:=nvl(ct.beneficiaryaccount,NewRec3.recaccount);
			   if ct.beneficiary is not null then
			     FindClientInfo(ct.beneficiary,Cl,False,False,False,False,False);
		   	 	 NewRec3.recname := Cl.Name;
			   else
			     NewRec3.recname := ct.beneficiaryname;
			   end if;
			   if ct.beneficiarybank is not null then
			     idBank:=ct.beneficiarybank;
			   elsif ci.beneficiarybankcode is not null and
			   ci.beneficiarycodetype is not null then
				 begin
				   select client into idBank from bankcode
				   where code=ci.beneficiarybankcode and
				   codesystem=ci.beneficiarycodetype and
				   nvl(validfromdate,dtStart1)<=dtStart1 and
				   nvl(validtodate,dtStart1+1)>dtStart1;
				 exception
				   when no_data_found or dup_val_on_index then
			         idBank:=null;
				 end;
			   else
			     idBank:=null;
			   end if;

			   if idBank is not null then
			     FindClientInfo(idBank,Cl,False,True,True,True,False);
		   		 NewRec3.recbankname := Cl.Name;
		   		 NewRec3.recbankbic := Cl.BIK;
		   		 NewRec3.recbankswift := Cl.BIC;
		   		 NewRec3.recbankcountry := Cl.Country;
	   			 select code into NewRec3.recbankaccount from clbankrel
				 where clbank=idBank and relation=nKorr and
				 nvl(opendate,dtStart1)<=dtStart1 and nvl(closedate,dtStart+1)>dtStart1;
			   else
		   		 NewRec3.recbankname := ci.beneficiarybankname;
			   end if;
			 exception
			   when no_data_found then
			     null;
			 end;
		   end if;
		   -- Плательщик - внешний
		   if rec.category=15 then
		     NewRec3.paybankaccount := null;
		     NewRec3.paybankname := null;
		     NewRec3.paybankbic := null;
		     NewRec3.paybankswift := null;
		     NewRec3.paybankcountry := null;
		     begin
			   select * into ct from customertransfer where doc=rec.idDoc;
			   select * into ci from customeriso where doc=rec.idDoc;

			   NewRec3.payaccount:=nvl(ct.payaccount,NewRec3.payaccount);
		   	   NewRec3.payname := ct.payname;
		   	   NewRec3.payinn := ci.paytaxid;
			   NewRec3.paykpp := ct.paykpp;
			   if ci.payclienttypecode=csBIC then
		   	     NewRec3.payswift := ci.payclientcode;
			   end if;

			   if ci.paybankcode is not null and  ci.paycodetype is not null then
				 begin
				   select client into idBank from bankcode
				   where code=ci.paybankcode and
				   codesystem=ci.paycodetype and
				   nvl(validfromdate,dtStart1)<=dtStart1 and
				   nvl(validtodate,dtStart1+1)>dtStart1;
				 exception
				   when no_data_found or dup_val_on_index then
			         idBank:=null;
				 end;
			   else
			     idBank:=null;
			   end if;

			   if idBank is not null then
			     FindClientInfo(idBank,Cl,False,True,True,True,False);
		   		 NewRec3.paybankname := Cl.Name;
		   		 NewRec3.paybankbic := Cl.BIK;
		   		 NewRec3.paybankswift := Cl.BIC;
		   		 NewRec3.paybankcountry := Cl.Country;
	   			 select code into NewRec3.paybankaccount from clbankrel
				 where clbank=idBank and relation=nKorr and
				 nvl(opendate,dtStart1)<=dtStart1 and nvl(closedate,dtStart+1)>dtStart1;
			   else
		   		 NewRec3.paybankname := ci.paybankname;
			   end if;

			 exception
			   when no_data_found then
			     null;
			 end;
		   end if;


		   begin
		     insert into fct_clpayment (
			   paydate, payaccount, payname, payinn, paykpp, payswift,
			   paycountry, payaddress, paybankaccount, paybankname,
			   paybankbic, paybankswift, paybankcountry,
			   recsum,
			   recdate, recaccount, recname, recbankaccount,
			   recbankname, recbankbic, recbankswift, recbankcountry,
			   payment_code, paycurrency_curr_code_txt, reccurrency_curr_code_txt,
			   rec_status, rec_unload, rec_process
			 ) values (
			   NewRec3.paydate, NewRec3.payaccount, NewRec3.payname, NewRec3.payinn, NewRec3.paykpp, NewRec3.payswift,
			   NewRec3.paycountry, NewRec3.payaddress, NewRec3.paybankaccount, NewRec3.paybankname,
			   NewRec3.paybankbic, NewRec3.paybankswift, NewRec3.paybankcountry,
			   NewRec3.recsum,
			   NewRec3.recdate, NewRec3.recaccount, NewRec3.recname, NewRec3.recbankaccount,
			   NewRec3.recbankname, NewRec3.recbankbic, NewRec3.recbankswift, NewRec3.recbankcountry,
			   NewRec3.payment_code, NewRec3.paycurrency_curr_code_txt, NewRec3.reccurrency_curr_code_txt,
		   	   '0',1,0
			 );
		   exception
		     when dup_val_on_index then
	   	       select * into OldRec3 from fct_clpayment where payment_code=NewRec3.payment_code;

			   if NewRec3.paydate                   <> OldRec3.paydate or
			      NewRec3.payaccount                <> OldRec3.payaccount or
				  NewRec3.payname                   <> OldRec3.payname or
				  NewRec3.payinn                    <> OldRec3.payinn or
				  NewRec3.paykpp                    <> OldRec3.paykpp or
				  NewRec3.payswift                  <> OldRec3.payswift or
				  NewRec3.paycountry                <> OldRec3.paycountry or
				  NewRec3.payaddress                <> OldRec3.payaddress or
				  NewRec3.paybankaccount            <> OldRec3.paybankaccount or
				  NewRec3.paybankname               <> OldRec3.paybankname or
				  NewRec3.paybankbic                <> OldRec3.paybankbic or
				  NewRec3.paybankswift              <> OldRec3.paybankswift or
				  NewRec3.paybankcountry            <> OldRec3.paybankcountry or
				  NewRec3.recsum                    <> OldRec3.recsum or
				  NewRec3.recdate                   <> OldRec3.recdate or
				  NewRec3.recaccount                <> OldRec3.recaccount or
				  NewRec3.recname                   <> OldRec3.recname or
				  NewRec3.recbankaccount            <> OldRec3.recbankaccount or
				  NewRec3.recbankname               <> OldRec3.recbankname or
				  NewRec3.recbankbic                <> OldRec3.recbankbic or
				  NewRec3.recbankswift              <> OldRec3.recbankswift or
				  NewRec3.recbankcountry            <> OldRec3.recbankcountry or
				  NewRec3.payment_code              <> OldRec3.payment_code or
				  NewRec3.paycurrency_curr_code_txt <> OldRec3.paycurrency_curr_code_txt or
				  NewRec3.reccurrency_curr_code_txt <> OldRec3.reccurrency_curr_code_txt then

				  update fct_clpayment
				  set paydate                   = NewRec3.paydate,
				      payaccount                = NewRec3.payaccount,
					  payname                   = NewRec3.payname,
					  payinn                    = NewRec3.payinn,
					  paykpp                    = NewRec3.paykpp,
					  payswift                  = NewRec3.payswift,
					  paycountry                = NewRec3.paycountry,
					  payaddress                = NewRec3.payaddress,
					  paybankaccount            = NewRec3.paybankaccount,
					  paybankname               = NewRec3.paybankname,
					  paybankbic                = NewRec3.paybankbic,
					  paybankswift              = NewRec3.paybankswift,
					  paybankcountry            = NewRec3.paybankcountry,
					  recsum                    = NewRec3.recsum,
					  recdate                   = NewRec3.recdate,
					  recaccount                = NewRec3.recaccount,
					  recname                   = NewRec3.recname,
					  recbankaccount            = NewRec3.recbankaccount,
					  recbankname               = NewRec3.recbankname,
					  recbankbic                = NewRec3.recbankbic,
					  recbankswift              = NewRec3.recbankswift,
					  recbankcountry            = NewRec3.recbankcountry,
					  payment_code              = NewRec3.payment_code,
					  paycurrency_curr_code_txt = NewRec3.paycurrency_curr_code_txt,
					  reccurrency_curr_code_txt = NewRec3.reccurrency_curr_code_txt,
				  	  rec_status = '0',
				      rec_process = 1,
				      rec_unload = 0
			      where payment_code = NewRec3.payment_code;
			   else
		   	      if OldRec3.rec_status='1' then
  		            update fct_clpayment set rec_status='0', rec_process=1, rec_unload=0
		            where payment_code=NewRec3.payment_code;
		   	      else
  		            update fct_clpayment set rec_process=1
					where payment_code=NewRec3.payment_code;
		   	      end if;
			   end if;
		   end;
		 end if;
	   end if; */
  	 end loop;
	 
	 update fct_Carry set rec_status = '1', rec_unload = 0
	 where rec_process = 0 and rec_status = '0' and dt=to_char(dtStart,'dd-mm-yyyy');	 

  	 dbms_application_info.Set_Module( '', '');
end;
/
