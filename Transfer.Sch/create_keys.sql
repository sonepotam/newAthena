---
--- создание ключей
---
declare nStrType  DesignObjType.code%type;
begin
 --- добавляем ключи
 Registry.AddSection( 'BANKSKEYS',     'BP',     'ОАО Петровский НБ');
 Registry.AddSection( 'BANKSKEYS\BP',  'Report', 'Отчеты');
 Registry.AddSection( 'BANKSKEYS\BP\Report', 'BBR_BP_PM_REPORT_ACC_TRANSFER', 'Отчет по счету передачи');
 --- определим тип Строка 
 select code into nStrType from DesignObjType where constType = 2;
 --- заносим ключи
 Registry.AddKey( 'BANKSKEYS\BP\REPORT\BBR_BP_PM_REPORT_ACC_TRANSFER', 
   'SBTransferSchet', 'Счет СЗСБ', 'Счет Северо-Западного Сбербанка', 0,
   null, nStrType, '30110810609020000020');
 Registry.AddKey( 'BANKSKEYS\BP\REPORT\BBR_BP_PM_REPORT_ACC_TRANSFER', 
   'SZSBBic', 'БИК СЗСБ', 'БИК Северо-Западного Сбербанка', 0,
   null, nStrType, '044030653');
end;
/
commit;
