create or replace function bp_msfo_findCorrAccounts( nDoc in varChar2,
  nSumma out number, 
  sDebetAcc   out varChar2, sDebetGlava  out varChar2, 
  sDebetCurr  out varChar2, sDebetDep    out varChar2,
  sCreditAcc  out varChar2, sCreditGlava out varChar2, 
  sCreditCurr out varChar2, sCreditDep   out varChar2
  ) return boolean is
/*
   Назначение  : Поиск счетов для занесения в fct_payment
   Наименование: bp_msfo_findCorrAccounts
   Автор       : Цейтлин П.М.
   Версия      : 1.0.1
   .0 

История проекта
Дата       Автор  	    Изменение
------------------------------------------------------------------------
22.07.2004 Цейтлин П.М. Создана процедура
*/  
  bResult boolean := False;
  nCategory number;
begin
  nSumma     := 0 ;    
  sDebetAcc  := ''; sDebetGlava  := ''; sDebetCurr := '' ; sDebetDep  := '';
  sCreditAcc := ''; sCreditGlava := ''; sCreditCurr := ''; sCreditDep := '';
  select Category into nCategory from doctree
    where Classified = nDoc;
  if nCategory not in ( 4,5,11,12,15) then
    return bResult;
  end if;
  if nCategory = 4 then -- Перевод в другой банк
    select bo.SumAccount, 
	       accDeb.code, bp_msfo_DecodeChapter( accDeb.MainGeneralAcc),
		   accDeb.sysfilial, crDeb.codeIsoAlph, 
	       accCred.code, bp_msfo_DecodeChapter( accCred.MainGeneralAcc), 
		   accCred.sysfilial, crCred.codeIsoAlph 
	  into nSumma, 
	       sDebetAcc, sDebetGlava,
		   sDebetDep, sDebetCurr,
	       sCreditAcc, sCreditGlava,
		   sCreditDep, sCreditCurr
	  from bankOper bo, CustomerTransfer ct, 
	       account accDeb, account accCred,
		   currency crDeb, currency crCred
	  where bo.doc = nDoc
	    and ct.doc = nDoc
		and bo.Account = accDeb.Classified
		and ct.Nostro = accCred.Classified
		and accDeb.Currency = crDeb.Classified
		and accCred.Currency = crCred.Classified		
		and bo.doc = ct.doc;
	bResult := True;	
  end if;		
  if nCategory = 5 then -- Перевод внутри банка
    select bo.SumAccount, 
	       accDeb.code, bp_msfo_DecodeChapter( accDeb.MainGeneralAcc),
		   accDeb.sysfilial, crDeb.codeIsoAlph, 
	       accCred.code, bp_msfo_DecodeChapter( accCred.MainGeneralAcc), 
		   accCred.sysfilial, crCred.codeIsoAlph 
	  into nSumma, 
	       sDebetAcc, sDebetGlava,
		   sDebetDep, sDebetCurr,
	       sCreditAcc, sCreditGlava,
		   sCreditDep, sCreditCurr
	  from bankOper bo, PrepareMoney pm, 
	       account accDeb, account accCred,
		   currency crDeb, currency crCred
	  where bo.doc = nDoc
	    and pm.doc = nDoc
		and bo.Account = accDeb.Classified
		and pm.Account = accCred.Classified
		and accDeb.Currency = crDeb.Classified
		and accCred.Currency = crCred.Classified		
		and bo.doc = pm.doc;
	bResult := True;	
  end if;
  if nCategory = 11 then -- Взнос наличных денег
    select bo.SumAccount, 
	       accDeb.code, bp_msfo_DecodeChapter( accDeb.MainGeneralAcc),
		   accDeb.sysfilial, crDeb.codeIsoAlph, 
	       accCred.code, bp_msfo_DecodeChapter( accCred.MainGeneralAcc), 
		   accCred.sysfilial, crCred.codeIsoAlph 
	  into nSumma, 
	       sDebetAcc, sDebetGlava,
		   sDebetDep, sDebetCurr,
	       sCreditAcc, sCreditGlava,
		   sCreditDep, sCreditCurr
	  from bankOper bo, PrepareMoney pm, 
	       account accDeb, account accCred,
		   currency crDeb, currency crCred
	  where bo.doc = nDoc
	    and pm.doc = nDoc
		and pm.Account = accDeb.Classified
		and bo.Account = accCred.Classified
		and accDeb.Currency = crDeb.Classified
		and accCred.Currency = crCred.Classified		
		and bo.doc = pm.doc;
	bResult := True;	
  end if;
  if nCategory = 12 then -- Взнос наличных денег
    select bo.SumAccount, 
	       accDeb.code, bp_msfo_DecodeChapter( accDeb.MainGeneralAcc),
		   accDeb.sysfilial, crDeb.codeIsoAlph, 
	       accCred.code, bp_msfo_DecodeChapter( accCred.MainGeneralAcc), 
		   accCred.sysfilial, crCred.codeIsoAlph 
	  into nSumma, 
	       sDebetAcc, sDebetGlava,
		   sDebetDep, sDebetCurr,
	       sCreditAcc, sCreditGlava,
		   sCreditDep, sCreditCurr
	  from bankOper bo, PrepareMoney pm, 
	       account accDeb, account accCred,
		   currency crDeb, currency crCred
	  where bo.doc = nDoc
	    and pm.doc = nDoc
		and pm.Account = accDeb.Classified
		and bo.Account = accCred.Classified
		and accDeb.Currency = crDeb.Classified
		and accCred.Currency = crCred.Classified		
		and bo.doc = pm.doc;
	bResult := True;	
  end if;
  if nCategory = 15 then -- Перевод из другого банка
    select bo.SumAccount, 
	       accDeb.code, bp_msfo_DecodeChapter( accDeb.MainGeneralAcc),
		   accDeb.sysfilial, crDeb.codeIsoAlph, 
	       accCred.code, bp_msfo_DecodeChapter( accCred.MainGeneralAcc), 
		   accCred.sysfilial, crCred.codeIsoAlph 
	  into nSumma, 
	       sDebetAcc, sDebetGlava,
		   sDebetDep, sDebetCurr,
	       sCreditAcc, sCreditGlava,
		   sCreditDep, sCreditCurr
	  from bankOper bo, CustomerTransfer ct, 
	       account accDeb, account accCred,
		   currency crDeb, currency crCred
	  where bo.doc = nDoc
	    and ct.doc = nDoc
		and ct.Nostro = accDeb.Classified
		and bo.Account = accCred.Classified
		and accDeb.Currency = crDeb.Classified
		and accCred.Currency = crCred.Classified		
		and bo.doc = ct.doc;
	bResult := True;	
  end if;
  return bResult;	
end;  
  