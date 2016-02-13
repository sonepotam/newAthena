---
--- создание ключей
---
declare 
  nClass number;
  i      number := 1;
begin
 --- удаляем старые ключи
 delete from registrykey 
 where fullname  =  '\BANKSKEYS\BP\REPORT\BP_PM_VALMEMOORDER';	 
 --- добавляем ключи
 Registry.AddSection( 'BANKSKEYS',     'BP',     'ОАО Петровский НБ');
 Registry.AddSection( 'BANKSKEYS\BP',  'Report', 'Отчеты');
 Registry.AddSection( 'BANKSKEYS\BP\Report', 'BP_PM_VALMEMOORDER', 'Валютный мем.ордер');
 --- заносим ключи
 for rec in ( select * from docType where label in (
               'Клиентский Внутр. перевод(ВАЛ)',
               'Собственный Внутр.перевод(ВАЛ)',
               'Комиссия за операцию')) loop
   Registry.AddKey( 'BANKSKEYS\BP\REPORT\BP_PM_VALMEMOORDER', 
     'Document' || i, 'Document'|| i, '', 0, null, 9, rec.Classified);
   i := i + 1;
 end loop;
end;
/
commit;
