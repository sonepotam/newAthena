CREATE OR REPLACE procedure DPC_PNB_CheckArcOperDateDoc
/**********************************************************************************
��������: �������� ������� ������������� ���������� ���� "�������� ��������� ���"
�����   : ������� �.
VSS     : $/����� �����/DPC - ���������/�������� ������� ������������� ���������� ���� �������� ��������� ���
������  : 1.0.0.1
                                        
���������:
*********************************************************************************
19.01.2005 ������� �.�. ������� �������� �� sysfilial
17.06.2005 ������� �.�. �������� hint � ������
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

   -- �������� ������� ������������� ����������
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
      raise_application_error(-20000,'���� ������������� �������� ���� "'||rec.TPLabel||'" �'||rec.Label||' �� '|| to_char(rec.OperDate, 'dd/mm/yyyy hh24:mi:ss'));
   end loop;
end DPC_PNB_CheckArcOperDateDoc;
/
