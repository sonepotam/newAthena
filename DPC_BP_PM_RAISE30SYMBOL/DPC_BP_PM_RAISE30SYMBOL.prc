create or replace procedure dpc_bp_pm_Raise30Symbol is
/*
Процедура : dpc_bp_pm_Raise30Symbol
Назначение: Контроль 30 символа кассовой отчетности
Версия    : 1.0.0.0
VSS       : НА/DPC-процедуры/Контроль 30 символа кассовой отчетности
Автор     : Цейтлин П.М.

История создания
Дата       Автор        Изменение
-------------------------------------------------------------------------------
26.12.2005 Цейтлин П.М. Создан проект
*/
  nDummy number;
begin
  select 1 into nDummy 
  from bankopersymbol bos, cashSymbol cs 
  where bos.doc = Context.CurrentDoc
    and bos.CASHSYMBOL = cs.classified
    and cs.symbol = '30';
  RaiseError( 'Символ 30 запрещен');
exception 
  when NO_DATA_FOUND then null;
  when TOO_MANY_ROWS then RaiseError( 'Символ 30 запрещен');
end;