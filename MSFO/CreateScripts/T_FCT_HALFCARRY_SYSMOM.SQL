CREATE OR REPLACE TRIGGER "MSFO".T_FCT_HALFCARRY_SYSMOM
 BEFORE INSERT OR UPDATE OF ROLEACCOUNT_DEAL_CODE, ACCOUNT_CODE, REC_STATUS, CODE, VALUE, VALUE_NAT, DOCNUM, HALFCARRY_GROUND, DT
 ON FCT_HALFCARRY
 FOR EACH ROW
BEGIN
  :NEW.sysmoment:=SYSDATE;
  if updating then
    update fct_reval r
       set r.sysmoment=:new.sysmoment,
        r.rec_unload=0
     where r.halfcarry_code=:old.code;
  end if;
END;
/
