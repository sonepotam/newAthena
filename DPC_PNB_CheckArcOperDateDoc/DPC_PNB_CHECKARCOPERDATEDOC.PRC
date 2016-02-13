CREATE OR REPLACE procedure DPC_PNB_CheckArcOperDateDoc
/**********************************************************************************
Описание: проверка наличия незавершенных документов типа "Открытие архивного дня"
Автор   : Телегин А.
VSS     : $/Новая Афина/DPC - процедуры/проверка наличия незавершенных документов типа Открытие архивного дня
Версия  : 1.0.0.1
                                        
Изменения:
*********************************************************************************
19.01.2005 Цейтлин П.М. Сделана разбивка по sysfilial
17.06.2005 Цейтлин П.М. Добавлен hint в запрос
**********************************************************************************/
as
   nDocType          dt.reference;
   nDoc              dt.reference;
   nFilial    		 dt.Reference;
   sRowID     rowid := Context.DocRowID;

   dtOperDate        date;
   dtPrevOperDate    date;
begin
   select DocType into nDocType
     from DocTree
    where Classified = Context.CurrentDoc;
   select SysFilial into nFilial from DocTree where rowid = sRowID;

   -- проверка наличия незавершенных документов
   for rec in (
      select /*+ INDEX (dt ix_doctree_4) */ DT.Label, DT.OperDate, D.Label TPLabel
        from DocTree DT, DocType D
       where DT.DocType = D.Classified
         and DT.DocType = nDocType
         and D.Category = 53
		 and DT.sysfilial = nFilial
         and DT.Classified != Context.CurrentDoc
         and DT.DocState not in ( Constants.State_Close, Constants.State_Cancel, Constants.State_RollBack)
      )
   loop
      raise_application_error(-20000,'Есть незавершенный документ типа "'||rec.TPLabel||'" №'||rec.Label||' за '|| to_char(rec.OperDate, 'dd/mm/yyyy hh24:mi:ss'));
   end loop;
end DPC_PNB_CheckArcOperDateDoc;
/
