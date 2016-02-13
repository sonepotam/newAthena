
set arraysize 2
set serveroutput on
set echo off
execute dbms_output.put_line('************************* ToTransAcc_OnPos ************************')
---------------------------------------------------------------------------------------------------
-- ���������:
-- UT_ToTransAcc_OnPos     -  ��������� ��������� �� ���������� ���������� �� ����� ����������
--          �������� ��� ����������, ����������� � ��������� <�� �������>
--          (�������� � ��������� ����� ��������� �����) � ������� ��� > ������� ����.
--          ����� ��������� ������� ��������� ���������� ���������� ��������� ���� (commit)
-- ��������� ����� - 'UT_STATE_ONPOSITION'
---------------------------------------------------------------------------------------------------
-- ������ �� : 04.09.02 ( ������ �.)
-- ������������: OD
-- ������:  SHAR
---------------------------------------------------------------------------------------------------
create or replace procedure UT_ToTransAcc_OnPos
---------------------------------------------------------------------------------------------------
-- ��������: ��������� ��������� �� ���������� ���������� �� ����� ����������
--          �������� ��� ����������, ����������� � ��������� <�� �������>
--           (�������� � ��������� ����� ��������� �����) � ������� ��� > ������� ����.
-- ������ �� : 05.09.02 ( ������ �.) (04.09.02)
---------------------------------------------------------------------------------------------------
as
   /* ������*/
   sErr        DT.Description;            -- ����� ������
   dtGlobDate  date default   s.ysdate;   -- ���� ��������
   idCurDoc    DT.Reference;              -- �������������� ��������
   nCount      DT.Counter  := 0;          -- ������� ����������

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
      nState      DT.Reference,  /* ��������� ���������                                */
      idType      DT.Reference,  /* ��������� ���                                      */
      dtDate      date           /* ���                                                */
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
      sErr  := '���  ���������� ��������� <'||teller_proc.DocIdent(idCurDoc)||'>'||CHR(13)||CHR(10)
            ||'�� ���� ���������� ��������.';
   end GetError;
---------------------------------------------------------------------------------------------------
   procedure ShowStat(nDocCount  DT.ConstValue) is
      bDocExists     boolean  default  nDocCount != 0;
   begin
      commit;
      raise_application_error(-20000,
         i.f(bDocExists,'�','�� �')||'���������'||i.f(bDocExists,' <'||nDocCount||'> ',' �� ������')||
         ' ���������(��) , ��������������� �������.');
   end ShowStat;
---------------------------------------------------------------------------------------------------
begin
   for recTypeState in curTypeState('UT_STATE_ONPOSITION') loop
      for rec in curDoc(recTypeState.State,recTypeState.Type_,dtGlobDate) loop
         -- �������� ��������
         idCurDoc := rec.Doc;
         -- ��������
         for recNotSet in (select * from Dual where not exists
               (select * from PrepareMoney where Doc = rec.Doc )) loop
            -- �������� ��� �� ��������� �� ���� ��������� ��������
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
      raise_application_error(-20000,'�� ������� ��������: '||sErr);
   when TOO_MANY_ROWS then
      GetError;
      raise_application_error(-20000, '������� ����� ������ ��������: '||sErr);
   when VALUE_ERROR or INVALID_NUMBER then
      GetError;
      raise_application_error(-20000,'���������� ������������� ��������: '||sErr);
   when OTHERS then
      if SQLCODE = -20000 then
         raise;
      end if;
      GetError;
      raise_application_error(-20000,substr('������������� ������ ('||substr(sqlerrm,12)||') '||CHR(13)||CHR(10)||
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
   Create_InterfaceWindow('����.����� ��� ����.����. UT_ToTransAcc_OnPos','UT_STATE_ONPOSITION',null,4,null,0);
   declare
  nDOTCode     DesignObjType.Code%type;
begin
select min(Code) into nDOTCode from DesignObjType where ConstType = NULL;
  update AllFunction set Label = substr('���������� ���-��� � ��������� <���������> �� ����� �����.��������',1,50), Description = '���������� ���-��� � ��������� <���������> �� ����� �����.��������', SubSystem = null
   where FuncIntention = 7 and upper(FunctionName) = upper('UT_ToTransAcc_OnPos')
     and DocCategory is null
     and (ReturnObjType = nDOTCode or (ReturnObjType is null and nDOTCode is null));
  if SQL%ROWCOUNT=0 then
    insert into ALLFUNCTION(LABEL,DESCRIPTION,SUBSYSTEM,
                           FUNCTIONNAME,FUNCINTENTION,DOCCATEGORY,
                           RETURNOBJTYPE)
     values(substr('���������� ���-��� � ��������� <���������> �� ����� �����.��������',1,50),'���������� ���-��� � ��������� <���������> �� ����� �����.��������',null,'UT_ToTransAcc_OnPos',7,NULL,nDOTCode);
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
execute SetSchemeVersion('PET', 0,0, '��������� �� ���������� ���������� � ��������� <���������> �� ����� ���������� ��������');