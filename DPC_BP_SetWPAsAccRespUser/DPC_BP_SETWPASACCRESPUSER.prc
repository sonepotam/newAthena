CREATE OR REPLACE procedure DPC_BP_SetWPAsAccRespUser
/*
Процелура : DPC_BP_SetWPAsAccRespUser
Назначение: Запись создателя(Рабочее место) при заведении счета в ответственные исполнители
Версия    : 1.0.0.1
VSS       : Новая Афина/DPC-процедуры/Запись создателя(Рабочее место) при заведении счета в ответственные исполнители
Автор     : топчий А.

История изменений:
Дата       Автор          Изменение
---------------------------------------------------------------------------------------------------
11.10.2002 Топчий А.      Создана процедура
30.11.2005 Цейтлин П.М.   При открытии счета указывать ФИО пользователя в доп.описании СЗ 16/248

*/
as
   idCurDoc       DT.Reference := Context.CurrentDoc; -- текущий документ
   recOA          ObjAssoc%rowtype;                   -- запись ObjAssoc
begin
   -- инициализируем поля записи
   recOA.DocObj   := idCurDoc;
   recOA.Category := 36;
   -- найдем рабочее место , создавшее документ
   select min(DT.AuthorWP),min(A.Classified)
     into recOA.Assoc,recOA.Obj
     from DocTree  DT,
          Account  A
    where DT.Classified = idCurDoc
      and A.Doc = DT.Classified;
   -- проверим значения.
   if recOA.Assoc is null or recOA.Obj is null then
      raise_application_error(-20000,'Не найдено значение : '||
         i.f(recOA.Assoc is null,'<создатель документа>',null)||
         i.f(recOA.Obj is null,' <счет >',null)||CHR(13)||CHR(10)||
         ' для привязки Ответ.Исполнителя '||
         i.f(recOA.Obj is not null,CHR(13)||CHR(10)||' по счету <'||AccountCode(recOA.Obj)||'>',null));
   end if;
   -- проверим существование привязки
   begin
      select * into recOA
        from ObjAssoc
       where Category = recOA.Category
         and Obj = recOA.Obj
         and Assoc = recOA.Assoc
         and (ValidToDate >= s.ysdate or ValidFromDate > s.ysdate)
         and rownum < 2;
      -- если есть , но  в будущем
      if recOA.ValidFromDate > s.ysdate then
         -- растянем привязку до нужного срока
         recOA.ValidFromDate := s.ysdate;
      else
         -- ValidToDate >= s.ysdate
         -- если есть, и перекрывает нашу - ничего не делаем
         return;
      end if;
   exception
      when NO_DATA_FOUND then
         -- заполним нужные даты
         recOA.ValidFromDate := s.ysdate;
         recOA.ValidToDate := TO_DATE('4444-01-01 12:00:00','YYYY-MM-DD HH24:MI:SS');
   end;
   select substr(pseudoname, instr(pseudoname, ': ')+ 2)
     into recOA.description  
   from users where userID = user;  
   if recOA.AssocOrder is null then
       recOA.AssocOrder := 1;
   end if;	   
   -- создадим(изменим) привязку
   CngObjAssoc(recOA.Classified,recOA.Category,recOA.Obj,recOA.DocObj,recOA.Assoc,recOA.DocAssoc,
         recOA.AssocOrder,recOA.Description,recOA.ValidFromDate,recOA.ValidToDate);
end;
/
