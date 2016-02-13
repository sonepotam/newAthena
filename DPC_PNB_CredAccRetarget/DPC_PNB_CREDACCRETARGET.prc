CREATE OR REPLACE procedure DPC_PNB_CredAccRetarget
---------------------------------------------------------------------------------------------------
-- ќписание: - процедура предназначена€ дл€_ подстановки в качестве счета кредита
-- счета перенаправлени€ - ƒоп.описание с константой -40
-- 29.11.2005 ÷ейтлин ѕ.ћ. провер€етс€ состо€ние счета кредита. ≈сли счет не в ƒ¬–, то он удал€етс€
---------------------------------------------------------------------------------------------------
as
   idCurDoc          DT.Reference default    Context.CurrentDoc; -- текущий документ
   sCredAcc          Account.Code%type;   -- счет кредита
   idBenefAccDoc     DT.Reference;        -- счет получател€_
   idAcc             DT.Reference;        -- буфер дл€ сохранени€ счетов
   sDescText         DT.Label;            -- текст доп.описани€_
   sBenefAccCode     Account.Code%type;   -- код счета получател€_
   sNewAccCode       Account.Code%type;   -- код нового счета получател€_
   -- ссылки на доп.признаки
   idDescRetarget    DT.Reference default ObjAttr.DescClass(-40);
   idPropSolutionReq DT.Reference default ObjAttr.PropClass(54);
   nCategory		 number(2);  --категори€ тек.документа
begin
   select Category into nCategory
      from DocTree
	  where Classified = idCurDoc;
   if nCategory=15 then --перевод из другого банка
      select Account into idAcc from BankOper where Doc = idCurDoc;
   elsif  nCategory=4 then  --перевод в другой банк
      select Nostro into idAcc from CustomerTransfer where Doc = idCurDoc;
   else  --друга€ категори€ - возврат
      return;
   end if;
   --select Code into sCredAcc from Account
   --      where Classified = idAcc Closed > s.ysdate;
   -- ≈сли у обрабатываемого документа не заполнен или закрыт счет кредита
   begin
     if idAcc is not null then 
       select acc.classified into idAcc 
	     from account acc, doctree dt
	     where acc.doc = dt.classified
	       and acc.classified = idAcc
		   and dt.docState = Constants.State_Start;
	 end if;	    
   exception
     when NO_DATA_FOUND then -- счет не найден или не в ƒ¬–
  	   update bankOper set Account = null where Doc = idCurDoc and nCategory = 15;
  	   update CustomerTransfer set Nostro = null 
	     where Doc = idCurDoc and nCategory = 4;		  
   end; 
   
   if idAcc is null  then
      -- счет кредита не заполнен
      -- но заполнен счет получател€,  счет получател€ заведен в Ќј
      -- и находитс€ в состо€нии <»сполнен>.
      begin
         select A.Doc,
                CT.BeneficiaryAccount
           into idBenefAccDoc,
                sBenefAccCode
           from Account          A,
                CustomerTransfer CT,
                DocTree          DT
          where CT.Doc  = idCurDoc              and
                A.Code = CT.BeneficiaryAccount  and
                A.Doc = DT.Classified           and
                DT.DocState in (Constants.State_Close, Constants.State_RollBack, Constants.State_Cancel);
         -- »щем <счет перенаправлени€> дл€ этого счета (по доп.описанию)
         idAcc  := to_number(ObjAttr.GetOneDesc(idBenefAccDoc,idDescRetarget));
         -- если дл€ обрабатываемого счета значение не задано
         if idAcc is null then
            -- ищем счет дл€ которого закрытый счет указан в качестве <счета перенаправлени€>.
            sDescText := to_char(idBenefAccDoc);
            -- найдем Classified документа <счет>
            select Obj
              into idAcc
              from ObjDesc
             where DescText = sDescText            and
                   Description = idDescRetarget    and
                   s.ysdate between ValidFromDate  and ValidToDate;
         end if;
         -- если idAcc до сих пор не найден - вылетаем на первом-же select'e
         begin
            -- проверим , открыт - ли счет (и заодно найдем Account.Classified)
            select A.Classified,
                   A.Code
              into idAcc,
                   sNewAccCode
              from Account          A,
                   DocTree          DT
             where DT.Classified = idAcc
               and DT.DocState = Constants.State_Start
               and A.Doc = DT.Classified;
            -- ≈сли значение найдено и найденный счет открыт, то
            -- проставл€ем данный счет в качестве счета кредита документа,
			if nCategory=15 then
              update BankOper set Account = idAcc where Doc = idCurDoc;
			elsif nCategory=4 then
              update CustomerTransfer set Nostro = idAcc where Doc = idCurDoc;
			end if;
            -- проставл€ем дополнительный признак <“ребует прин€ти€ решени€> (константа 54)
            -- EVG  211202 ObjAttr.SaveOneProp(idCurDoc,idCurDoc,idPropSolutionReq,1);
            -- и записываем в DocText документа <ƒокумент перенаправлен со счета
            -- <счет получател€> на счет <новый счет>>.
            tal_AddToDocText(idCurDoc,3,
               'ƒокумент перенаправлен со счета <'||sBenefAccCode||'> '||
               'на счет <'||sNewAccCode||'>');
         exception
            when NO_DATA_FOUND then
               null;
         end;
      exception
         when NO_DATA_FOUND then
            null;
      end;
   end if;
   -- блок определени€ (и перенаправлени€) счета кредита (ћ‘–) дл€ <ѕеревода из другого банка>
   DPC_PNB_BranchAccRetarget;
end DPC_PNB_CredAccRetarget;
/
