CREATE OR REPLACE procedure DAE_BP_PM_Unload2OD(
  niCommandNo   DT.Reference,   niServiceNo DT.ConstValue,
  siRetPipeName DT.Description, niSendTimeOut  DT.Quantity)is
  sErr          varChar2( 4000);
  idWorkPlace   DT.Reference;   -- �������� � ������� ������� �����
  sFrmtLogDate  varchar2( 50);  -- ������ ���� �������
  dtStart       DATE := trunc( sysdate) - 14;
  dtStop        DATE := trunc( sysdate);
  
  procedure SaveDaemonLog( sMessage DaemonErrorLog.ErrorMessage%type) is
  begin
    insert into DaemonErrorLog (Classified,Daemon,UserFunction,ErrorMessage)
    values(
      0,ThisDaemon.PipeName,ThisDaemon.UserFunction,
      substr('<'||to_char(s.ysdate,sFrmtLogDate)||'>  ' || sMessage, 1, 254));
	commit;  
 end SaveDaemonLog;
begin
  sFrmtLogDate := 'DD.MM.YYYY HH24:MI:SS';  -- ������ ���� �������
  begin
   SaveDaemonLog('�������� � ������� ��������� ��');
   sErr := '������� �����, ��������� � ��������.';
   -- �������� ������� ����� , ������� ��������� � ������
   select min(WorkPlace) into idWorkPlace from DaemonSchedule
   where Daemon = ThisDaemon.PipeName
     and ValidFromDate <= s.ysdate
     and (ValidToDate > s.ysdate or ValidToDate is null);
   -- ������������� ������� �����
   sErr  := '��������� �������� �����, ��������� � ��������.';
   C_Access.SetWorkPlace(idWorkPlace);
   sErr  := '��� ���������� ��������� bp_al_PashkaCalculate2';
   -- ���� ���������� ���� ������
   SaveDaemonLog(
     '�������� ������� � ' || to_Char( dtStart, 'dd.mm.yyyy') ||
	 ' �� ' || to_Char( dtStop, 'dd.mm.yyyy'));
   begin
     SavePoint StartProcedure;
	 BP_UNLOAD_TO_OD.RUN_ALL( dtStart, dtStop);
     SaveDaemonLog( '������ ������� ��������');
   exception
     when OTHERS then
       RollBack to StartProcedure;
       SaveDaemonLog( '������ � ��������� : '|| sqlerrm);
   end;
   -- ������ ������ � ������ ��������� ������ �� ������� ��������
  exception
   when NO_DATA_FOUND then
      SaveDaemonLog('�� ������� �������� : '||sErr);
   when TOO_MANY_ROWS then
      SaveDaemonLog('������� ����� ������ �������� : '||sErr);
   when VALUE_ERROR or INVALID_NUMBER then
      SaveDaemonLog('���������� ������������� �������� : '||sErr);
   when OTHERS then
      SaveDaemonLog('������ ('||sErr||') <'||sqlerrm||'>');
  end;
  commit;
end;
/
