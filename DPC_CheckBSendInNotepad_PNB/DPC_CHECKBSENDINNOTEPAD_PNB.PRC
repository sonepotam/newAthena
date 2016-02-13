CREATE OR REPLACE procedure DPC_CheckBSendInNotepad_PNB
as
/*
Процедура: DPC_CheckBSendInNotepad_PNB
Автор    : Цейтлин П.М.
Версия   : 1.0.0.0
VSS      : "$/Новая Афина/DPC - процедуры/Проверка перед сменой типа"

*/
nObj     number(10);
nWorkingSumm    number(24,3);
nDummy number;
begin
 select Obj into nObj from DocTree where Classified=Context.CurrentDoc;
 nWorkingSumm := DeltaAccAndNotep;
 if nWorkingSumm <0 and nObj is not null then
  begin
   select 1 into nDummy from DocTree where Classified = nObj and Category <> 46; 
   raise_application_error(-20000,'Недостаточно денег на счете для оплаты платежа. Документ списания с картотеки нельзя ставить на картотеку.');
  exception
   when NO_DATA_FOUND then null;
  end;
 end if;
end DPC_CheckBSendInNotepad_PNB;
/
