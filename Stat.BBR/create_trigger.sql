CREATE OR REPLACE TRIGGER T_FEI_READYREPORT_LOG
 BEFORE INSERT ON BBR.READYREPORT FOR EACH ROW
declare
-- Триггер заполняет таблицу fei_RepUsage для сбора статистики по получению
-- отчетов на базе
-- fei, 2002 
  nWP Dt.Reference;
begin
  -- определим текущее рабочее место
  begin
    nWP:=C_Access.GetWorkPlace;
  exception
    when others then
      nWP:=null;
  end;
  -- запись статистики
  insert into fei_RepUsage (ReportProc, UserId, UserDate, WorkPlace)
    values (:new.ReportProc, :new.UserId, :new.UserDate, nWP);
end;
/
