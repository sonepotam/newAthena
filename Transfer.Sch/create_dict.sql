---
--- Создание словарного типа для отчета по отложенным платежам
---
begin
  insert into Dictionary 
  (Code, TableName, Label, PrimKeyColumn, LabelColumn, WhereClause) 
  values 
  ('BBR_BP_PM_REPORT_ACC_TRAN', 'DOCSTATE', 'Тип для отчета Отлож.платежи',
    'CLASSIFIED', 'LABEL', 'classified in ( select ELH.DocState from EntityLifeHistory ELH,InterfaceForState IFS,InterfaceWindow IV where ELH.Classified  = IFS.ELHEvent and IFS.InterfaceWindow = IV.Classified and IV.WindowName = ''BBR_BP_PM_REPORT_ACC_TRANSFER'')');
exception
  when OTHERS then
   update Dictionary
     set TableName = 'DOCSTATE',
         Label     = 'Тип для отчета Отлож.платежи',
	 PrimKeyColumn = 'CLASSIFIED',
	 LabelColumn   = 'LABEL',
	 WhereClause   = 'classified in ( select ELH.DocState from EntityLifeHistory ELH,InterfaceForState IFS,InterfaceWindow IV where ELH.Classified  = IFS.ELHEvent and IFS.InterfaceWindow = IV.Classified and IV.WindowName = ''BBR_BP_PM_REPORT_ACC_TRANSFER'')'
    where Code = 'BBR_BP_PM_REPORT_ACC_TRAN';		 
end;
/
commit;

