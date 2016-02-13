CREATE OR REPLACE TRIGGER T_FEI_READYREPORT_LOG
 BEFORE INSERT ON BBR.READYREPORT FOR EACH ROW
declare
-- ������� ��������� ������� fei_RepUsage ��� ����� ���������� �� ���������
-- ������� �� ����
-- fei, 2002 
  nWP Dt.Reference;
begin
  -- ��������� ������� ������� �����
  begin
    nWP:=C_Access.GetWorkPlace;
  exception
    when others then
      nWP:=null;
  end;
  -- ������ ����������
  insert into fei_RepUsage (ReportProc, UserId, UserDate, WorkPlace)
    values (:new.ReportProc, :new.UserId, :new.UserDate, nWP);
end;
/
