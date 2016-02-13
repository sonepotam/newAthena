CREATE OR REPLACE TRIGGER MSFO.TT_ASS_ACCOUNT_ASSET_ACC_CODE
BEFORE INSERT or update of dt ON ASS_ACCOUNT_ASSET FOR EACH ROW
 declare 
   sAccountCode det_Account.code%type;
BEGIN
  if Inserting then
    begin
	  select code into sAccountCode  
	    from det_Account
	    where Account_Number = :new.Account_Code;
	  :new.Account_Code := sAccountCode;	
	exception
	  when NO_DATA_FOUND then null;
	end;  	 
  end if;	
END;
/