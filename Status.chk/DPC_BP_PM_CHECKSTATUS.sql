CREATE OR REPLACE PROCEDURE DPC_BP_PM_CHECKSTATUS is
/*
  ����������: �������������� ������������� ���� ������ ��� ������������ �������� �
              ������. ��� ������ ���� ��������� ��� ����������� ������� = 3 ��� 4 �
			  ����� ���������� 40314, 40101, 40201, 40204
  VSS: ��\DPC-���������\�������� ���� ������ ��� ��������� �����������
  Ver: 1.12

  ����		  �����			   ���������
  28.05.2003  ������� �.�.	   ������� ���������
  30.05.2003  ������� �.�.	   �������� ����� DPC �� ������� ���
  02.07.2003  ������� �.�.     ������ ������ raise
  19.05.2005  ������ �.�.      ��������� ������ raise ��� ��503
  15.06.2005  ������� �.�.     �������� ������ �� ������� ���� ��������
*/
 nQueue      BankOper.PayQueue%type;
 nRo         bankOper.RO%type;
 sRO         RO.Code%type;
 sStatus     PayTax.PayStatus%type;
 nCategory   DocTree.Category%type;
 sBenAccount Account.Code%type;
 dtReceipt   CustomerTransfer.ReceiptDate%type;
 sLabel      TypeTree.Label%type;
 dtStart     DATE := to_Date( '02.06.2003', 'dd.mm.yyyy');

 --idDoc       dt.Reference := Context.CurrentDoc;
 idProp      dt.Reference := PropClass(-23);
 --nProp       dt.Reference := ObjAttr.GetOneProp( idDoc, idProp);
 idDoc       dt.Reference := Message.IdObject;
 nProp       dt.Reference := Content.UnPackNumber( 'DPC_BP_PM_CHECKSTATUS', Message.Sparam );

begin

  --- ������ �������� 01.06.2003
  select ReceiptDate into dtReceipt from CustomerTransfer where Doc = Context.CurrentDoc;
  if dtReceipt < dtStart then return; end if;

  select Category  into nCategory       from DocTree  where Classified = Context.CurrentDoc;
  select PayQueue, RO  into nQueue, nRO from bankOper where Doc = Context.CurrentDoc;

  if nRo is null then
    raise_application_error( -20000, '��������� ��� ��������');
  end if;

  if nQueue is null then
    raise_application_error( -20000, '��������� ����������� �������');
  end if;


  select Code into sRo from RO where Classified = nRo;

  begin
    select payStatus into sStatus    from PayTax   where Doc = Context.CurrentDoc;
  exception
    when NO_DATA_FOUND then sStatus := null;
  end;

  -- ���� ����������
  if nCategory in (4,15) then
    select BeneficiaryAccount into sBenAccount from CustomerTransfer where Doc = Context.CurrentDoc;
  elsif nCategory = 5 then
    select AccountCode(Account) into sBenAccount from PrepareMoney where Doc = Context.CurrentDoc;
  end if;

  -- ��� �������
  begin
    select upper( label) into sLabel from TypeTree
	where Classified = ObjAttr.GetOneType( Context.CurrentDoc, ObjAttr.TypeClass( -300));
  exception
    when NO_DATA_FOUND then sLabel := null;
  end;

  if subStr( sBenAccount, 1, 5) in(  '40314', '40101', '40201', '40204') and
     nQueue in ( 3) and sRo = '01' and sLabel = '����������' then
	 if sStatus is null then
	   if nProp is not null then
	     if nProp = 1 then
		   return;
		 end if;
	   end if;
	   --if nvl( nProp, 0) = 1 then return; end if;
       Message.CancelWithQuestion( Stext => '��� ���������� ������� � ������ ������ ���� ��������� ���� ������. dpc_bp_pm_CheckStatus',
                                   Idobject => idDoc,
                                   sNo => null,
                                   sReplyName => 'DPC_BP_PM_CHECKSTATUS' );
 end if;
  else
    if substr( sBenAccount, 1, 5) in ( '40314', '40101', '40201', '40204') and
       nQueue in ( 4) and sRo = '01' and sLabel = '����������' then
	   if sStatus is null then
          raise_application_error( -20000, '��� ���������� ������� � ������ ������ ���� ��������� ���� ������. dpc_bp_pm_CheckStatus');
       end if;
       DPC_CheckNotNullTaxField;
    end if;
  end if;
end;
/
