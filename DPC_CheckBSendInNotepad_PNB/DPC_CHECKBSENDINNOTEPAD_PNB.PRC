CREATE OR REPLACE procedure DPC_CheckBSendInNotepad_PNB
as
/*
���������: DPC_CheckBSendInNotepad_PNB
�����    : ������� �.�.
������   : 1.0.0.0
VSS      : "$/����� �����/DPC - ���������/�������� ����� ������ ����"

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
   raise_application_error(-20000,'������������ ����� �� ����� ��� ������ �������. �������� �������� � ��������� ������ ������� �� ���������.');
  exception
   when NO_DATA_FOUND then null;
  end;
 end if;
end DPC_CheckBSendInNotepad_PNB;
/
