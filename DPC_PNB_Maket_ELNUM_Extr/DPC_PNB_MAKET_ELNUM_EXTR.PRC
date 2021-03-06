CREATE OR REPLACE procedure DPC_PNB_Maket_ELNUM_Extr
---------------------------------------------------------------------------------------------------
-- ��������� ���������� ����� ��������� (ELNUM) �  Extract ����� ����� �� �
-- DocTree.Extract  ������������  ������ ��������� � �� ������ ������������ ��������
-- VSS : $/����� �����/DPC - ���������/��������� ���������� ����� ��������� (ELNUM) �  Extract ��� ��������� ����������
-- 07.06.2005 ������� �.�. ������� ������� ���������� ���� Extract ������
-- ������� ����������� ������ Extract : Elnum. ������ ���� ��������.
---------------------------------------------------------------------------------------------------
as
   nMaketDoc   DT.Reference      default Context.CurrentDoc;               /* �����                   */
   nRefDesc    DT.Reference      default DescClass(84);       /* ������� ����� ��������� */
   sErr        DT.Description;                                             /* ��������� �� ������     */
   sElNum      DT.Label;                                                   /* ELNUM                   */
   sOurBIC     BankCode.Code%type;                                         /* ��� ���                 */
   dtOperDate  date := Context.OperDate;                 /* ���� ���.����.��� --EVG 301202 */
   idBICRU     DT.Reference;                                               /* Classified ���-�        */
   sExtract    DocTree.Extract%type;                                       /* �������                 */
---------------------------------------------------------------------------------------------------
   -- ��������� � ������ � ������� ������������ ������� �� �����
   cursor curDocsInMaket is
      select Dim.SendDoc
        from DocsInMaket Dim , CustomerTransfer Ct
       where Dim.Doc = nMaketDoc
         and Ct.Doc = Dim.SendDoc
         and Ct.ClearingHouse is not null;
---------------------------------------------------------------------------------------------------
   -- ������������ Extract
   cursor curExtrct(idDoc DT.Reference) is
     select to_number(nvl(substr(DT.Label,-3),DT.Label))                /* ����� ���������*/ -- 141202
        ||' '||sOurBIC                                                  /* ��� ��� */
        ||' '||CT.PayAccount                                            /* ���� �����������_  */
        ||' -'||ltrim(to_char(BO.SumAccount,'9999999999999999999990.99')) /* ����� ������� */
        ||' '||ClientCode(CT.BeneficiaryBank,idBICRU)                   /* ��� ����� ����������_ */
        ||' '||CT.BeneficiaryAccount                                    /* ���� ����������_ */
        ||' '||to_char(DT.ValidFromDate,'YYYYMMDD')                     /* ���� ��������� */
                                                     str
      from BankOper           BO,
           CustomerTransfer   CT,
           DocTree            DT
     where BO.Doc = idDoc
       and CT.Doc = idDoc
       and DT.Classified = idDoc;
---------------------------------------------------------------------------------------------------
begin
   -- ������� ������� ���
   sErr := '������� ������� ���';
   select Classified into idBICRU from CodeSystem where Const = 7;
   -- ��� ���
   sOurBIC := ClientCode(pref.OurBank, idBICRU);
   -- select OurBank into nOBank from Preference where SysFilial = c_access.getfilial;
   sErr := '��� ������������ ������ 7 �������� ��. ������ ���������';
   sElNum := lpad(to_36(substr(sOurBIC,3,7)||'000'), 7, '0');
   sErr := '��� ��������� ���� ��������� <'||teller_proc.DocIdent(nMaketDoc)||'>';
    sElNum := 'A2'     ||
          sElNum   ||
          to_36(to_number(to_char(dtOperDate,'YYYY')) - 1990) ||
          to_36(to_number(to_char(dtOperDate, 'MM')))         ||
          to_36(to_number(to_char(dtOperDate, 'DD')));
    --***

   -- ������� Extract ����������
   sErr := '��� ������������ ��. ������ ��������� ���������� � ������ <'||teller_proc.DocIdent(nMaketDoc)||'>';
   for rDoc in curDocsInMaket loop
      -- �������� Extract �� ���������
      for rec in curExtrct(rDoc.SendDoc) loop
         sExtract := rec.str;
         exit;
      end loop;
      -- ������� Extract � DocTree
      update DocTree
         set Extract =
            substr(sExtract || ':'|| sElNum ||lpad(to_36(to_number(GetObjDesc(rDoc.SendDoc, nRefDesc))), 4, '0')
                     ,1,254)
      where Classified = rDoc.SendDoc;
   end loop;
exception
   when NO_DATA_FOUND then
      raise_application_error(-20000,'�� ������� �������� : '||sErr);
   when TOO_MANY_ROWS then
      raise_application_error(-20000, '������� ����� ������ �������� : '||sErr);
   when VALUE_ERROR or INVALID_NUMBER then
      raise_application_error(-20000,'���������� ������������� �������� : '||sErr);
   when OTHERS then
   if sqlCode = -20000 then
      raise;
   end if; /* sqlCode = -20000 */
      raise_application_error(-20000,'������������� ������ ('||sErr||') - <'||sqlerrm||'>');
end DPC_PNB_Maket_ELNUM_Extr;
/
