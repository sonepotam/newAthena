CREATE OR REPLACE procedure DPC_BP_SetWPAsAccRespUser
/*
��������� : DPC_BP_SetWPAsAccRespUser
����������: ������ ���������(������� �����) ��� ��������� ����� � ������������� �����������
������    : 1.0.0.1
VSS       : ����� �����/DPC-���������/������ ���������(������� �����) ��� ��������� ����� � ������������� �����������
�����     : ������ �.

������� ���������:
����       �����          ���������
---------------------------------------------------------------------------------------------------
11.10.2002 ������ �.      ������� ���������
30.11.2005 ������� �.�.   ��� �������� ����� ��������� ��� ������������ � ���.�������� �� 16/248

*/
as
   idCurDoc       DT.Reference := Context.CurrentDoc; -- ������� ��������
   recOA          ObjAssoc%rowtype;                   -- ������ ObjAssoc
begin
   -- �������������� ���� ������
   recOA.DocObj   := idCurDoc;
   recOA.Category := 36;
   -- ������ ������� ����� , ��������� ��������
   select min(DT.AuthorWP),min(A.Classified)
     into recOA.Assoc,recOA.Obj
     from DocTree  DT,
          Account  A
    where DT.Classified = idCurDoc
      and A.Doc = DT.Classified;
   -- �������� ��������.
   if recOA.Assoc is null or recOA.Obj is null then
      raise_application_error(-20000,'�� ������� �������� : '||
         i.f(recOA.Assoc is null,'<��������� ���������>',null)||
         i.f(recOA.Obj is null,' <���� >',null)||CHR(13)||CHR(10)||
         ' ��� �������� �����.����������� '||
         i.f(recOA.Obj is not null,CHR(13)||CHR(10)||' �� ����� <'||AccountCode(recOA.Obj)||'>',null));
   end if;
   -- �������� ������������� ��������
   begin
      select * into recOA
        from ObjAssoc
       where Category = recOA.Category
         and Obj = recOA.Obj
         and Assoc = recOA.Assoc
         and (ValidToDate >= s.ysdate or ValidFromDate > s.ysdate)
         and rownum < 2;
      -- ���� ���� , ��  � �������
      if recOA.ValidFromDate > s.ysdate then
         -- �������� �������� �� ������� �����
         recOA.ValidFromDate := s.ysdate;
      else
         -- ValidToDate >= s.ysdate
         -- ���� ����, � ����������� ���� - ������ �� ������
         return;
      end if;
   exception
      when NO_DATA_FOUND then
         -- �������� ������ ����
         recOA.ValidFromDate := s.ysdate;
         recOA.ValidToDate := TO_DATE('4444-01-01 12:00:00','YYYY-MM-DD HH24:MI:SS');
   end;
   select substr(pseudoname, instr(pseudoname, ': ')+ 2)
     into recOA.description  
   from users where userID = user;  
   if recOA.AssocOrder is null then
       recOA.AssocOrder := 1;
   end if;	   
   -- ��������(�������) ��������
   CngObjAssoc(recOA.Classified,recOA.Category,recOA.Obj,recOA.DocObj,recOA.Assoc,recOA.DocAssoc,
         recOA.AssocOrder,recOA.Description,recOA.ValidFromDate,recOA.ValidToDate);
end;
/
