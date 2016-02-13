-- �������� ������
declare
   id    DT.Reference;
   sLab  DT.Label;
   daemon_wrkplace varChar2( 20) := '����������';
   procedure CreateDaemon
   (
   vClassified     in out  Daemon.Classified%type,
   vDaemonName       Daemon.DaemonName%type,    -- ����
   vDescription      Daemon.Description%type,
   vWithSchedule     Daemon.WithSchedule%type,
   vSendTimeOut      Daemon.SendTimeOut%type,
   vUserFunction     Daemon.UserFunction%type,
   vDispatcher       Daemon.Dispatcher%type,
   vUnLoadTimeOut    Daemon.UnLoadTimeOut%type
   ) is
      vStatus     All_Objects.Status%type;   -- ������ ������� (��������� ������)
      vUpper      Daemon.UserFunction%type := upper(vUserFunction);  -- ��� ������� � ����.��������
   begin
      -- �������� ���������
      select min(Status) into vStatus from All_Objects
       where Object_type = 'PROCEDURE' and Object_Name = vUpper;
      if vStatus != 'VALID' then
         dbms_output.put(' ������ (DAEMON) <'||vDaemonName||
            '> �� ������ - ������ ������� <'||vUserFunction||'> - <'||nvl(vStatus,'NOT FOUND')||'>');
      end if;
      -- �������� ������
      dbms_output.put(' ������ (DAEMON) <'||vDaemonName);
      select Classified into vClassified from Daemon where DaemonName = vDaemonName;
      update Daemon
         set Description   =  vDescription,
             WithSchedule  =  vWithSchedule,
             SendTimeOut   =  vSendTimeOut,
             UserFunction  =  vUserFunction,
             Dispatcher    =  vDispatcher,
             UnLoadTimeOut =  vUnLoadTimeOut
       where Classified    =  vClassified;
      dbms_output.put_line('>  ��������');
   exception
      when NO_DATA_FOUND then
         insert into
         Daemon( DaemonName,Description,WithSchedule,SendTimeOut,UserFunction,Dispatcher,UnLoadTimeOut)
         values(vDaemonName,vDescription,vWithSchedule,vSendTimeOut,vUserFunction,vDispatcher,vUnLoadTimeOut);
         dbms_output.put_line('>  ������');
   end CreateDaemon;
begin
   -- �������� ������
   sLab  := 'UNLOAD2OD';
   CreateDaemon(id,sLab,sLab,1, 5,'DAE_BP_PM_Unload2OD',null,9999);
   -- �������� ��� ����������
   delete from DaemonSchedule where Daemon = sLab;
   -- ������� ������ � ����������
   insert into DaemonSchedule( 
      Daemon, SleepInterval,  ValidFromDate, ValidToDate, 
      WakeUpMonth, WakeUpDay, WakeUpHour, WakeUpMinute, WorkPlace, 
      IntervalValue, IsRevertMode, SystemMode, WaitTimeOut )
   select sLab, 1, s.ysdate , null, 
     null, null, 2, 0, min(Classified),
     1, 0, null, 5
     from WorkPlace where Upper(Label) = daemon_wrkplace;
   dbms_output.put_line(' ��������� ������ � ���������� ������');
   commit;
end;
/