CREATE OR REPLACE Function BP_UT_REPORT_ACC_TRANSFER( nClassified in Number, sError in out varChar2) RETURN  Boolean IS
  bResult boolean := True;
  bOK     boolean := False;

  sRGN     varChar2( 200);

  sPrior   varChar2( 2);
  sPayType varChar2( 200);

  sPayTypeEL  varChar2( 200) := '����������';
  sPayTypeP   varChar2( 200) := '�����';
  sOurBIC     varChar2( 35)  := Get_BankCode( pref.OurBank, 7);

  dtRow       DocTree%rowtype; -- ������ DocTree �� �������� ���������
  boRow       BankOper%rowtype;-- ������ BankOper �� �������� ���������
  ctRow       CustomerTransfer%rowtype;-- ������ CustomerTransfer �� �������� ���������
  ciRow       CustomerIso%rowtype;-- ������ CustomerIso �� �������� ���������

  function sWrongBIC( sPrior in varChar2, sError in out varChar2) return Boolean is
  begin
    sError  := '��������� ' || sPrior ||': �������� ��� ����������';
    return False;
  end;

  function sWrongRO( sPrior in varChar2, sError in out varChar2) return Boolean is
  begin
    sError  := '��������� ' || sPrior ||': �������� ��� ��������';
    return False;
  end;

  function sWrongPlat( sPrior in varChar2, sError in out varChar2) return Boolean is
  begin
    sError  := '��������� ' || sPrior ||': �������� ��� �������';
    return False;
  end;


BEGIN

  sError := '';
  select * into dtRow from DocTree   where Classified = nClassified;
  select * into boRow from BankOper         where Doc = nClassified;
  select * into ctRow from CustomerTransfer where Doc = nClassified;
  select * into ciRow from CustomerIso      where Doc = nClassified;

  --- ���� ��������� �� ��������, �� ������ �� �������
  if dtRow.Priority is null then
     sError := '�� �������� ���������';
     return False;
  end if;

  if dtRow.Priority < 10 then
    sPrior := LPad( to_Char( dtRow.Priority), 2, '0');
  else
    sPrior := subStr( to_Char( dtRow.Priority), -2);
  end if;

  ---  ������� ��� �������
  begin
    select UPPER( Label) into sPayType
      from TypeTree
      where Classified = ObjAttr.GetOneType( nClassified, ObjAttr.TypeClass( -300));
  exception
    when NO_DATA_FOUND then begin
      bResult := False;
      sError := '�� �������� ��� �������';
      return bResult;
    end;

  end;


  if sPrior = '01' then
    bOK := True;
    if ciRow.BeneficiaryBankCode <> sOurBIC then
       if boRow.Ro <> GetRO('01') then
         bResult := sWrongRO( sPrior, sError);
       end if;
       if sPayType <> sPayTypeEl then
         bResult := sWrongPlat( sPrior, sError);
       end if;
       if ciRow.BeneficiaryBankCode not in
          ( '044030653', '044030791', '044030755', '044030852', '044109722', '044106770',
            '044030712', '044705768', '046551854', '046311808', '044030790', '044030829',
            '044030891', '044030875', '044030763', '044030760') then
         bResult := sWrongBIC( sPrior, sError);
       end if;
    end if;
  end if;

   if sPrior in ('02','34','70','71','96') then
     bOK := True;
     if ciRow.BeneficiaryBankCode <> sOurBIC then
       if boRow.Ro <> GetRO('01') then
         bResult := sWrongRo( sPrior, sError);
       end if;
       if sPayType <> sPayTypeEl then
         bResult := sWrongPlat( sPrior, sError);
       end if;
     end if;
   end if;

  if sPrior = '05' then
    bOK := True;
    if ciRow.BeneficiaryBankCode <> sOurBIC then
       --- ��������� ������
       begin
         select code into sRGN
          from bankcode
          where client = ctRow.BeneficiaryBank and
               codesystem = ( select classified from codesystem where const = 18);

          if sRGN <> '40' then
            bResult := False;
            sError := '��������� 5: �������� ��� �������';
          end if;

       exception
         when NO_DATA_FOUND then begin
           bResult := False;
           sError := '�� �������� ������';
         end;
       end;
    end if;
  end if;

  if sPrior = '07' then
    bOK := True;
    if ciRow.BeneficiaryBankCode <> sOurBIC then
      if boRow.Ro <> GetRO('01') then
        bResult := sWrongRo( sPrior, sError);
      end if;
      if sPayType <> sPayTypeEl then
        bResult := sWrongPlat( sPrior, sError);
      end if;
      if ObjAttr.GetOneProp( nClassified, ObjAttr.PropClass( -12)) != 1 then
        sError  := '��������� 7: ��� �������� VIP-������';
        bResult := False;
      end if;
    end if;
  end if;

  if sPrior = '09' then
    bOK := True;
	if ciRow.BeneficiaryBankCode <> sOurBIC then
      sError  := '��������� 9: ������� ������';
      bResult := False;
    end if;
  end if;

  if sPrior in ('17','18','98') then
    bOK := True;
	if ciRow.BeneficiaryBankCode <> sOurBIC then
      if sPayType <> sPayTypeP then
        bResult := sWrongPlat( sPrior, sError);
      end if;
    end if;
  end if;

  if sPrior = '37' Then
    bOK := True;
    if ciRow.BeneficiaryBankCode = sOurBIC then
      sError  := '��������� 9: ���������� ������';
      bResult := False;
    end if;
  end if;

  if sPrior = '53' Then
    bOK := True;
    if ciRow.BeneficiaryBankCode <> '044030852' then
      bResult := sWrongBIC( sPrior, sError);
    end if;
    if boRow.Ro <> GetRO('01') then
      bResult := sWrongRo( sPrior, sError);
    end if;
    if sPayType <> sPayTypeEL then
      bResult := sWrongPlat( sPrior, sError);
    end if;
  end if;

  if sPrior = '75' Then
    bOK := True;
    if ciRow.BeneficiaryBankCode <> '044030755' then
      bResult := sWrongBIC( sPrior, sError);
    end if;
    if boRow.Ro <> GetRO('01') then
      bResult := sWrongRo( sPrior, sError);
    end if;
    if sPayType <> sPayTypeEL then
      bResult := sWrongPlat( sPrior, sError);
    end if;
  end if;

  if sPrior = '76' then
    bOK := True;
    if ciRow.BeneficiaryBankCode <> '044109722' then
      bResult := sWrongBIC( sPrior, sError);
    end if;
    if boRow.Ro <> GetRO('01') then
      bResult := sWrongRo( sPrior, sError);
    end if;
    if sPayType <> sPayTypeEL then
      bResult := sWrongPlat( sPrior, sError);
    end if;
  end if;

  if sPrior = '96' Then
    bOK := True;
    if ciRow.BeneficiaryBankCode = sOurBIC then
      if boRow.Ro <> GetRO('01') then
        bResult := sWrongRo( sPrior, sError);
      end if;
      if sPayType <> sPayTypeEL then
        bResult := sWrongPlat( sPrior, sError);
      end if;
    end if;
  end if;

  if sPrior in ('17','18','98') Then
    bOK := True;
	if ciRow.BeneficiaryBankCode <> sOurBIC then
      if sPayType <> sPayTypeP then
        bResult := sWrongPlat( sPrior, sError);
      end if;
    end if;
  end if;

  if sPrior = '37' Then
    bOK := True;
	if ciRow.BeneficiaryBankCode = sOurBIC then
      sError := '��������� 37: ���������� ������';
      bResult := False;
    end if;
  end if;

  if sPrior = '53' Then
    bOK := True;
	if ciRow.BeneficiaryBankCode <> '044030852' then
      bResult := sWrongBIC( sPrior, sError);
    end if;
    if boRow.Ro <> GetRO('01') then
      bResult := sWrongRo( sPrior, sError);
    end if;
    if sPayType <> sPayTypeEL then
      bResult := sWrongPlat( sPrior, sError);
    end if;
  end if;

  if sPrior = '75' Then
    bOK := True;
	if ciRow.BeneficiaryBankCode <> '044030755' then
      bResult := sWrongBIC( sPrior, sError);
    end if;
    if boRow.Ro <> GetRO('01') then
      bResult := sWrongRo( sPrior, sError);
    end if;
    if sPayType <> sPayTypeEL then
      bResult := sWrongPlat( sPrior, sError);
    end if;
  end if;

  if sPrior = '76' Then
    bOK := True;
	if ciRow.BeneficiaryBankCode <> '044109722' then
      bResult := sWrongBIC( sPrior, sError);
    end if;
    if boRow.Ro <> GetRO('01') then
      bResult := sWrongRo( sPrior, sError);
    end if;
    if sPayType <> sPayTypeEL then
      bResult := sWrongPlat( sPrior, sError);
    end if;
  end if;

  if sPrior = '96' Then
    bOK := True;
	if ciRow.BeneficiaryBankCode <> sOurBIC then
      bResult := sWrongBIC( sPrior, sError);
    end if;
    if boRow.Ro <> GetRO('01') then
      bResult := sWrongRo( sPrior, sError);
    end if;
    if sPayType <> sPayTypeEL then
      bResult := sWrongPlat( sPrior, sError);
    end if;
  end if;

  if sPrior not in ('00','97', '10', '32') AND not bOK Then
    sError  := '��������� ' || sPrior || ': �������� ��� ����������';
    bResult := False;
  end if;

  return bResult;
END;
/
