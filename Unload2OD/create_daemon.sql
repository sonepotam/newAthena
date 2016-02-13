-- создадим демона
declare
   id    DT.Reference;
   sLab  DT.Label;
   daemon_wrkplace varChar2( 20) := 'НАСТРОЙЩИК';
   procedure CreateDaemon
   (
   vClassified     in out  Daemon.Classified%type,
   vDaemonName       Daemon.DaemonName%type,    -- ключ
   vDescription      Daemon.Description%type,
   vWithSchedule     Daemon.WithSchedule%type,
   vSendTimeOut      Daemon.SendTimeOut%type,
   vUserFunction     Daemon.UserFunction%type,
   vDispatcher       Daemon.Dispatcher%type,
   vUnLoadTimeOut    Daemon.UnLoadTimeOut%type
   ) is
      vStatus     All_Objects.Status%type;   -- статус обьекта (процедуры демона)
      vUpper      Daemon.UserFunction%type := upper(vUserFunction);  -- имя функции в верх.регистре
   begin
      -- проверим процедуру
      select min(Status) into vStatus from All_Objects
       where Object_type = 'PROCEDURE' and Object_Name = vUpper;
      if vStatus != 'VALID' then
         dbms_output.put(' Сервис (DAEMON) <'||vDaemonName||
            '> не создан - статус функции <'||vUserFunction||'> - <'||nvl(vStatus,'NOT FOUND')||'>');
      end if;
      -- создание демона
      dbms_output.put(' Сервис (DAEMON) <'||vDaemonName);
      select Classified into vClassified from Daemon where DaemonName = vDaemonName;
      update Daemon
         set Description   =  vDescription,
             WithSchedule  =  vWithSchedule,
             SendTimeOut   =  vSendTimeOut,
             UserFunction  =  vUserFunction,
             Dispatcher    =  vDispatcher,
             UnLoadTimeOut =  vUnLoadTimeOut
       where Classified    =  vClassified;
      dbms_output.put_line('>  обновлен');
   exception
      when NO_DATA_FOUND then
         insert into
         Daemon( DaemonName,Description,WithSchedule,SendTimeOut,UserFunction,Dispatcher,UnLoadTimeOut)
         values(vDaemonName,vDescription,vWithSchedule,vSendTimeOut,vUserFunction,vDispatcher,vUnLoadTimeOut);
         dbms_output.put_line('>  создан');
   end CreateDaemon;
begin
   -- создадим демона
   sLab  := 'UNLOAD2OD';
   CreateDaemon(id,sLab,sLab,1, 5,'DAE_BP_PM_Unload2OD',null,9999);
   -- почистим его расписание
   delete from DaemonSchedule where Daemon = sLab;
   -- добавим запись в расписание
   insert into DaemonSchedule( 
      Daemon, SleepInterval,  ValidFromDate, ValidToDate, 
      WakeUpMonth, WakeUpDay, WakeUpHour, WakeUpMinute, WorkPlace, 
      IntervalValue, IsRevertMode, SystemMode, WaitTimeOut )
   select sLab, 1, s.ysdate , null, 
     null, null, 2, 0, min(Classified),
     1, 0, null, 5
     from WorkPlace where Upper(Label) = daemon_wrkplace;
   dbms_output.put_line(' добавлена запись в расписании демона');
   commit;
end;
/