CREATE OR REPLACE PACKAGE TARIF_TOOLS is

 function GetAccountType( sAccCode in varChar2) return number;
 pragma restrict_references( GetAccountType, WNDS, WNPS);


 function CheckObjType( nClassified in number, sEntryList in varChar2)
   return boolean;
 pragma restrict_references( CheckObjType, WNDS, WNPS);

 function FindEntry( sEntry in varChar2, sEntryList in varChar2)
  return boolean deterministic;
 pragma restrict_references( FindEntry, WNDS, WNPS);

 function CheckAccountType( nAccClassified in Number, nAccType in Number)
   return boolean;
 pragma restrict_references( CheckAccountType, WNDS, WNPS);


 function CheckTransMessage( nMessageClassified in Number, nConstMsg in Number)
  return boolean;
 pragma restrict_references( CheckTransMessage, WNDS, WNPS);


function ReestrInitDoc( nClassified in number) return number;
 pragma restrict_references( ReestrInitDoc, WNDS, WNPS);

function IsInernalPayment( nClassified in number)return Boolean;
 pragma restrict_references( IsInernalPayment, WNDS, WNPS);

function bp_IsResAndIs(nAccount in account.classified%type) RETURN NUMBER;
pragma restrict_references(bp_IsResAndIs, WNDS, WNPS);

end;
/
CREATE OR REPLACE PACKAGE BODY TARIF_TOOLS is
 -- Версия от 24.06.2005 - Наумов С.А. - поменялось условие выбора в ReestrInitDoc
 function GetAccountType( sAccCode in varChar2) return number is
   nResult number;
 begin
   select Type into nResult from account
     where code = sAccCode and sysfilial = c_access.GetFilial;
   return nResult;
 exception
   when NO_DATA_FOUND then return null;
 end;


---
--- поиск по Classified значения из TypeTree по списку sEntryList
---
 function CheckObjType( nClassified in number, sEntryList in varChar2)
  return boolean is
    bResult boolean := False;
    sEntry  varChar2( 4000);
  begin
    select label into sEntry
      from TypeTree
      where Classified = nClassified;

    bResult := FindEntry( sEntry, sEntryList);
    return bResult;
  exception
    when NO_DATA_FOUND then return bResult;
end;

---
--- поиск значения sEntry по списку sEntryList
---
 function FindEntry( sEntry in varChar2, sEntryList in varChar2)
  return boolean is
    bResult     boolean       := False;
    sDelimiter  varChar2( 1)  := ',';
    ptr         number        := 1;
    sCurEntry   varChar2( 200);
    EntryList   varChar2( 4000);
  begin
    EntryList := sEntryList;
    loop
      ptr := InStr( EntryList, sDelimiter);
      if ptr > 0 then
        sCurEntry := SubStr( EntryList, 1, ptr - 1);
        EntryList := SubStr( EntryList, ptr + 1);
      else
        sCurEntry  := EntryList;
      end if;
      if sCurEntry = sEntry then
        bResult := True;
        Exit;
      end if;
      if ptr = 0 then Exit; end if;
    end loop;
    return bResult;
end;

 function CheckAccountType( nAccClassified in Number, nAccType in Number)
  return boolean is
  cnt number;
  bResult boolean := False;
 begin
  select 1 into cnt
    from Account
    where Classified = nAccClassified AND
          Type       =  nAccType;
  bResult := True;
  return bResult;
exception
  WHEN NO_DATA_FOUND then return bResult;
end;

function CheckTransMessage( nMessageClassified in Number, nConstMsg in Number)
  return boolean is
  cnt number;
  bResult boolean := False;
begin
  select 1 into cnt
    from TransferMessage
    where Classified = nMessageClassified AND
          ConstMsg   = nConstMsg;
  bResult := True;
  return bResult;
exception
  WHEN NO_DATA_FOUND then return bResult;
end;

function ReestrInitDoc( nClassified in number)
  return number is
  nResult number := 0;
begin
  select InitDoc into nResult
    from ReestrDoc
   where Doc in ( select NotblObj from BankOper
                   where Doc = nClassified );
  return nResult;
exception
  when NO_DATA_FOUND then
     begin
        select InitialDoc into nResult
          from Orders where Doc = nClassified;
        return nResult;
     exception
        when NO_DATA_FOUND then
           return 0;
     end;
end;

function IsInernalPayment( nClassified in number)
  return Boolean is
  sOurBank     varChar2( 35);
  sCurBank     varChar2( 35);
  sCurBankCode number;
  sOurBankCode number;
  nDummy       number;
begin
  select BeneficiaryBankCode, BENEFICIARYCODETYPE, PayBankCode, PAYCODETYPE
    into sCurBank, sCurBankCode, sOurBank, sOurBankCode
    from  CustomerIso
    where Doc =  nClassified;
  begin
    -- поиск БИКа получателя среди наших биков
    select 1 into nDummy from preference
     where sysfilial is not null
      and  get_bankcode( ourbank, sCurBankCode) = sCurBank;
    -- поиск БИКа плательщика среди наших биков
    select 1 into nDummy from preference
     where sysfilial is not null
      and  get_bankcode( ourbank, sOurBankCode) = sOurBank;
    return True;
  exception
    when NO_DATA_FOUND then return false;
  end;
  return True;
end;

FUNCTION bp_IsResAndIs(nAccount in account.classified%type)
RETURN NUMBER IS
nClass proplist.CLASSIFIED%type;
nClient client.CLASSIFIED%type;
nIsResident number(1);
BEGIN
  begin
    select client into nClient from Account a where CLASSIFIED = nAccount;
	exception
	  when no_data_found then
		return 0;
	end;
  select classified into nClass from proplist where constprop  = 6;
  select decode(GetObjProp(nClient, nClass), 0,1,1,0,0) into nIsResident from dual;
	return nIsResident;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
END bp_IsResAndIs;

end;
/