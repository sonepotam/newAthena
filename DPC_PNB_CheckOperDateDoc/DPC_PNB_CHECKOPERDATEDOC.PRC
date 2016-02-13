CREATE OR REPLACE procedure DPC_PNB_CheckOperDateDoc
/**********************************************************************************
Описание: проверка наличия незавершенных документов типа "Операционный день"
Автор   : Телегин А.
Версия  : 1.0.0.1
VSS     : $/Новая Афина/DPC - процедуры/Проверка наличия незавершенных документов типа Операционный день

Изменения:
*********************************************************************************
19.01.2005 Цейтлин П.М. Сделана разбивка по sysfilial
17.06.2005 Цейтлин П.М. Добавлен hint в запрос
**********************************************************************************/
as
   nDocType          dt.reference;
   nDoc              dt.reference;
   dtOperDate        date;
   dtPrevOperDate    date;
   dtDate            date;
   sLabel            dt.Label;

   nFilial    dt.Reference;
   sRowID     rowid := Context.DocRowID;

begin
   select SysFilial into nFilial from DocTree where rowid = sRowID;
   -- проверка наличия незавершенных документов
   for rec in (
      select  /*+ INDEX (dt ix_doctree_4) */ DT.Label, DT.OperDate, D.Label TPLabel
        from DocTree DT, DocType D
       where DT.DocType = D.Classified
         and D.Category = 53
		 and DT.sysfilial = nFilial
         and DT.Classified != Context.CurrentDoc
         and DT.DocState not in ( Constants.State_Close, Constants.State_Cancel, Constants.State_RollBack)
      )
   loop
      raise_application_error(-20000,'Есть незавершенный документ типа "'||rec.TPLabel||'" №'||rec.Label||' за '|| to_char(rec.OperDate, 'dd/mm/yyyy hh24:mi:ss'));
   end loop;
   -- дата опердня.
   select min(OperDateBeg) into dtOperDate
     from ChangeOperDate where Doc = Context.CurrentDoc;

   select DocType into nDocType
     from DocTree
    where Classified = Context.CurrentDoc;

   -- дата предыдущего опердня.
   select max(Classified) into nDoc
     from DocTree
    where DocType = nDocType
      and Classified != Context.CurrentDoc
	  and sysfilial = nFilial
      and DocState = Constants.State_Close;
   if nDoc is not null then
      select max(OperDateEnd) into dtPrevOperDate
        from ChangeOperDate where Doc = nDoc;
      if dtPrevOperDate > dtOperDate then
         select OperDate, Label into dtDate, sLabel from DocTree where Classified = nDoc;
         raise_application_error(-20000,'Дата начала операционного дня '||to_char(dtOperDate, 'dd/mm/yyyy hh24:mi:ss')||' д.б. больше или равна дате окончания предыдущего опердня '|| to_char(dtPrevOperDate, 'dd/mm/yyyy hh24:mi:ss')||
          'установленной '|| to_char(dtDate, 'dd/mm/yyyy hh24:mi:ss')||' документом  №'||sLabel);
      end if;
   end if;
end DPC_PNB_CheckOperDateDoc;
/
