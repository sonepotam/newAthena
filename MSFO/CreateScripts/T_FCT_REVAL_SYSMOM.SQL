CREATE OR REPLACE TRIGGER T_FCT_REVAL_SYSMOM before INSERT ON FCT_REVAL 
FOR EACH ROW 
BEGIN 
  select hc.sysmoment into :NEW.sysmoment from fct_halfcarry hc
  where hc.code=:new.halfcarry_code;
END;
/
