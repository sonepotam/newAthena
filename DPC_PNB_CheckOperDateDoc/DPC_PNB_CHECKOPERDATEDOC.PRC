CREATE OR REPLACE procedure DPC_PNB_CheckOperDateDoc
/**********************************************************************************
��������: �������� ������� ������������� ���������� ���� "������������ ����"
�����   : ������� �.
������  : 1.0.0.1
VSS     : $/����� �����/DPC - ���������/�������� ������� ������������� ���������� ���� ������������ ����

���������:
*********************************************************************************
19.01.2005 ������� �.�. ������� �������� �� sysfilial
17.06.2005 ������� �.�. �������� hint � ������
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
   -- �������� ������� ������������� ����������
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
      raise_application_error(-20000,'���� ������������� �������� ���� "'||rec.TPLabel||'" �'||rec.Label||' �� '|| to_char(rec.OperDate, 'dd/mm/yyyy hh24:mi:ss'));
   end loop;
   -- ���� �������.
   select min(OperDateBeg) into dtOperDate
     from ChangeOperDate where Doc = Context.CurrentDoc;

   select DocType into nDocType
     from DocTree
    where Classified = Context.CurrentDoc;

   -- ���� ����������� �������.
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
         raise_application_error(-20000,'���� ������ ������������� ��� '||to_char(dtOperDate, 'dd/mm/yyyy hh24:mi:ss')||' �.�. ������ ��� ����� ���� ��������� ����������� ������� '|| to_char(dtPrevOperDate, 'dd/mm/yyyy hh24:mi:ss')||
          '������������� '|| to_char(dtDate, 'dd/mm/yyyy hh24:mi:ss')||' ����������  �'||sLabel);
      end if;
   end if;
end DPC_PNB_CheckOperDateDoc;
/
