
set arraysize 2
set serveroutput on
set echo off
execute dbms_output.put_line('************************* ToTransAcc_OnPos ************************')
---------------------------------------------------------------------------------------------------
-- Заголовок:
-- UT_ToTransAcc_OnPos     -  утилитная процедура по постановке документов на счета отложенных
--          платежей для документов, находящихся в состоянии <На позицию>
--          (привязка к состоянию через фиктивный экран) и имеющих ДПП > текущей даты.
--          После обработки каждого документа происходит сохранение состояния базы (commit)
-- фиктивный экран - 'UT_STATE_ONPOSITION'
---------------------------------------------------------------------------------------------------
-- Версия от : 04.09.02 ( Топчий А.)
-- Пользователь: OD
-- Раздел:  SHAR
---------------------------------------------------------------------------------------------------
create or replace procedure UT_ToTransAcc_OnPos
---------------------------------------------------------------------------------------------------
-- Описание: утилитная процедура по постановке документов на счета отложенных
--          платежей для документов, находящихся в состоянии <На позицию>
--           (привязка к состоянию через фиктивный экран) и имеющих ДПП > текущей даты.
-- Версия от : 05.09.02 ( Топчий А.) (04.09.02)
---------------------------------------------------------------------------------------------------
as
   /* ошибки*/
   sErr        DT.Description;            -- текст ошибки
   dtGlobDate  date default   s.ysdate;   -- дата операции
   idCurDoc    DT.Reference;              -- обрабатываемый документ
   nCount      DT.Counter  := 0;          -- счетчик документов

   DocList     DT.ClassType;

   -----------------------------------------------------------------------------
   cursor curTypeState(sWindowName    DT.SQLName) is
      select ELH.DocType       Type_,
             ELH.DocState      State
        from EntityLifeHistory   ELH,
             InterfaceForState   IFS,
             InterfaceWindow     IV
       where ELH.Classified  = IFS.ELHEvent        and
             IFS.InterfaceWindow = IV.Classified   and
             IV.WindowName = sWindowName;
   -----------------------------------------------------------------------------
   cursor curDoc(
      nState      DT.Reference,  /* требуемое состояние                                */
      idType      DT.Reference,  /* требуемый тип                                      */
      dtDate      date           /* ДПП                                                */
      )
      is
      select /*+ INDEX(DocTree   ix_DocTree_4)*/
             Classified    Doc
        from DocTree
       where DocType = idType
         and ValidFromDate > dtDate
         and DocState = nState;
-----------------------------------------------------------------------------
   procedure GetError  is
   begin
      commit;
      sErr  := 'при  постановке документа <'||teller_proc.DocIdent(idCurDoc)||'>'||CHR(13)||CHR(10)
            ||'на счет отложенных платежей.';
   end GetError;
---------------------------------------------------------------------------------------------------
   procedure ShowStat(nDocCount  DT.ConstValue) is
      bDocExists     boolean  default  nDocCount != 0;
   begin
      commit;
      raise_application_error(-20000,
         i.f(bDocExists,'О','Не о')||'бработано'||i.f(bDocExists,' <'||nDocCount||'> ',' ни одного')||
         ' документа(ов) , соответствующих запросу.');
   end ShowStat;
---------------------------------------------------------------------------------------------------
begin
   for recTypeState in curTypeState('UT_STATE_ONPOSITION') loop
      for rec in curDoc(recTypeState.State,recTypeState.Type_,dtGlobDate) loop
         -- запомним документ
         idCurDoc := rec.Doc;
         -- проверки
         for recNotSet in (select * from Dual where not exists
               (select * from PrepareMoney where Doc = rec.Doc )) loop
            -- документ еще не поставлен на счет отложеных платежей
            nCount := nCount + 1;
    
            DocList( nCount) := rec.Doc;

            PNB_to_DefPayment_Out(rec.Doc);
         end loop;
      end loop;
   end loop;

   BBR_BP_UT_DEFER_PAYMENTS( s.ysdate, '', DocList);

   ShowStat(nCount);
exception
   when NO_DATA_FOUND then
      GetError;
      raise_application_error(-20000,'Не найдено значение: '||sErr);
   when TOO_MANY_ROWS then
      GetError;
      raise_application_error(-20000, 'Найдено более одного значения: '||sErr);
   when VALUE_ERROR or INVALID_NUMBER then
      GetError;
      raise_application_error(-20000,'Невозможно преобразовать значение: '||sErr);
   when OTHERS then
      if SQLCODE = -20000 then
         raise;
      end if;
      GetError;
      raise_application_error(-20000,substr('Нераспознаная ошибка ('||substr(sqlerrm,12)||') '||CHR(13)||CHR(10)||
                                    sErr,1,250));
end UT_ToTransAcc_OnPos;
/
show errors
declare
   nCount     DT.Quantity;
begin
   DescribeObject('UT_ToTransAcc_OnPos','SHAR','TAL',null,'Proc_Engine');
   dbms_output.put_line('Proc_Engine UT_ToTransAcc_OnPos');
end;
/
begin
   Create_InterfaceWindow('Фикт.экран для утил.проц. UT_ToTransAcc_OnPos','UT_STATE_ONPOSITION',null,4,null,0);
   declare
  nDOTCode     DesignObjType.Code%type;
begin
select min(Code) into nDOTCode from DesignObjType where ConstType = NULL;
  update AllFunction set Label = substr('Постановка док-тов в состоянии <НаПозицию> на счета отлож.платежей',1,50), Description = 'Постановка док-тов в состоянии <НаПозицию> на счета отлож.платежей', SubSystem = null
   where FuncIntention = 7 and upper(FunctionName) = upper('UT_ToTransAcc_OnPos')
     and DocCategory is null
     and (ReturnObjType = nDOTCode or (ReturnObjType is null and nDOTCode is null));
  if SQL%ROWCOUNT=0 then
    insert into ALLFUNCTION(LABEL,DESCRIPTION,SUBSYSTEM,
                           FUNCTIONNAME,FUNCINTENTION,DOCCATEGORY,
                           RETURNOBJTYPE)
     values(substr('Постановка док-тов в состоянии <НаПозицию> на счета отлож.платежей',1,50),'Постановка док-тов в состоянии <НаПозицию> на счета отлож.платежей',null,'UT_ToTransAcc_OnPos',7,NULL,nDOTCode);
  end if;
end;
   declare
  idFunc    AllFunction.Classified%type;
begin
   select Classified into idFunc
     from AllFunction
    where FuncIntention = 7 and upper(FunctionName) = upper('UT_ToTransAcc_OnPos');
   CreateToolsExtension( idFunc );
end;
end;
/
execute SetSchemeVersion('PET', 0,0, 'Процедура по постановке документов в состоянии <НаПозицию> на счета отложенных платежей');