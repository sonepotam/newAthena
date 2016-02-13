CREATE OR REPLACE procedure DAE_BP_PM_Unload2OD(
  niCommandNo   DT.Reference,   niServiceNo DT.ConstValue,
  siRetPipeName DT.Description, niSendTimeOut  DT.Quantity)is
  sErr          varChar2( 4000);
  idWorkPlace   DT.Reference;   -- связаное с ДЕМОНОМ рабочее место
  sFrmtLogDate  varchar2( 50);  -- формат даты журнала
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
  sFrmtLogDate := 'DD.MM.YYYY HH24:MI:SS';  -- формат даты журнала
  begin
   SaveDaemonLog('Выгрузка в формате рублевого ОД');
   sErr := 'рабочее место, связанное с сервисом.';
   -- выбираем рабочее место , которое привязано к демону
   select min(WorkPlace) into idWorkPlace from DaemonSchedule
   where Daemon = ThisDaemon.PipeName
     and ValidFromDate <= s.ysdate
     and (ValidToDate > s.ysdate or ValidToDate is null);
   -- устанавливаем рабочее место
   sErr  := 'установка рабочего места, связаного с сервисом.';
   C_Access.SetWorkPlace(idWorkPlace);
   sErr  := 'при выполнении процедуры bp_al_PashkaCalculate2';
   -- блок выполнения тела демона
   SaveDaemonLog(
     'Интервал запуска с ' || to_Char( dtStart, 'dd.mm.yyyy') ||
	 ' по ' || to_Char( dtStop, 'dd.mm.yyyy'));
   begin
     SavePoint StartProcedure;
	 BP_UNLOAD_TO_OD.RUN_ALL( dtStart, dtStop);
     SaveDaemonLog( 'Запуск успешно завершен');
   exception
     when OTHERS then
       RollBack to StartProcedure;
       SaveDaemonLog( 'Ошибка в процедуре : '|| sqlerrm);
   end;
   -- делаем запись в журнал сообщений ДЕМОНА об удачной выгрузке
  exception
   when NO_DATA_FOUND then
      SaveDaemonLog('Не найдено значение : '||sErr);
   when TOO_MANY_ROWS then
      SaveDaemonLog('Найдено более одного значения : '||sErr);
   when VALUE_ERROR or INVALID_NUMBER then
      SaveDaemonLog('Невозможно преобразовать значение : '||sErr);
   when OTHERS then
      SaveDaemonLog('Ошибка ('||sErr||') <'||sqlerrm||'>');
  end;
  commit;
end;
/
