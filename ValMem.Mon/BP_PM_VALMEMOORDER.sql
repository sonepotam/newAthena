CREATE OR REPLACE package    bp_pm_valMemoOrder is
  type
    TMemOrderInfo is record(
      sLabel          varchar2( 50),
	  dtDate          DATE,
	  sDesc           varChar2( 4000),
	  nCategory       number,
	  nDocType        number,
	  sState          varChar2( 4000),
      dtValidFromDate DATE,
	  dtValidToDate   DATE,
	  nPrior          number,
	  sDebSchet       varChar2( 4000),
	  sDebCurrency    varChar2( 4000),
      nDebCurrency    number,
	  nSumDebet       number,
	  nSumRubDebet    number,
	  sCredSchet      varChar2( 4000),
	  sCredCurrency   varChar2( 4000),
	  nCredCurrency   number,
	  nSumCredit      number,
	  nSumRubCredit   number,
	  sUserName       varChar2( 4000)
	);

  procedure memOrderInfo( nDocClass in number, memInfo in out TMemOrderInfo);

end;
/
CREATE OR REPLACE package body bp_pm_valMemoOrder is
  /*
    *-------------------------------------------------------------------------------------
    *  ���������  : �������� �������� � ����� ��� ������������ ��������
    *  ���������� : ������ ���������� � ���������
    *  �����      : ������� �.�.
    *-------------------------------------------------------------------------------------
    ������ ���������:
    ����   	�����	        ���������
    22.04.2003  �������� �.�.   ������� �����������: operdate is not null
    02/04/2003	������� �.�.    �������� ���� � ���������� �������
  */

   ---
   --- ��������� ���������� � �������� ����������
   ---
   procedure memOrderInfo( nDocClass in number, memInfo in out TMemOrderInfo) is
    nCategory DocTree.Category%type;
	nDebClass Account.Classified%type;

	  ---
	  --- �������� ���������� �������
	  ---
	  procedure CreateDescription( memInfo in out TMemOrderInfo) is
        nDummy    number( 1);
	  begin
         ---
	     --- ��� ���������� ���������� � �������� ��������� ���������� ���������� �������
     	 --- ��� ��������� ������������ :)
	     ---
    	 begin
           select 1 into nDummy from registrykey
            where defaultvalue is not null
              and to_number( defaultvalue) = memInfo.nDocType
           connect by prior classified = parent
           start with fullname =  '\BANKSKEYS\BP\REPORT\BP_PM_VALMEMOORDER';
    	 exception
	        when NO_DATA_FOUND then
	           memInfo.sDesc := '������� �������� ������� �������� ��������� ������� � ' ||
		          memInfo.sLabel || ' �� ' || memInfo.dtDate;
    	 end;
		 if memInfo.sDesc is null then
            memInfo.sDesc := '������� �������� ������� �������� ��������� ������� � ' ||
		          memInfo.sLabel || ' �� ' || memInfo.dtDate;
		 end if;
	  end;

   begin
     begin
	   select Category into nCategory  from DocTree
	     where Classified = nDocClass;
	   if nCategory not in (4, 5, 11, 12) then
         raise_application_error(-20000, '�������� ������ �������� �� ��������� : ' || nCategory);
	   end if;
	 exception
       when No_Data_Found then raise_application_error(-20000,'�������� �� ������.');
	 end;

     begin
       select
   	     DT.Label, DT.OperDate, DT.Description, DT.Category, DT.DocType,
         DECODE( DocState, Constants.State_Rollback, '������',
                            Constants.State_Cancel,   '����������', '' ),
         DT.ValidFromDate, DT.ValidToDate,
         DT.Priority, AccDeb.Code debSchet,
         currDeb.CodeIsoAlph,
    	 BO.SUMACCOUNT sumDebetVal, U.PseudoName,
		 AccDeb.Classified
       into memInfo.sLabel, memInfo.dtDate, memInfo.sDesc, memInfo.nCategory,
	        memInfo.nDocType,
            memInfo.sState,
            memInfo.dtValidFromDate, memInfo.dtValidToDate,
            memInfo.nPrior, memInfo.sDebSchet,
            memInfo.sDebCurrency,
            memInfo.nSumDebet, memInfo.sUserName,
			nDebClass
       from DocTree DT, BankOper BO, Account AccDeb, Currency CurrDeb, users U
       where DT.Classified  = nDocClass
         and DT.Classified  = BO.DOC
    	 and BO.Account     = AccDeb.CLASSIFIED
	     and BO.CURRACCOUNT = CurrDeb.CLASSIFIED
     	 and DT.AuthorID    = U.UserID;
     exception
       when No_Data_Found then raise_application_error(-20000,'�������� �� ������.');
     end;


	 -- CreateDescription( memInfo);

	 ---
	 --- ���������� ���� ������������ �� ������� � ����������� �� ��������� ���������
	 ---
     begin
      if memInfo.nCategory in( 4) then
	    /*
        select ACC.Code into memInfo.sCredSchet
          from CustomerTransfer CT, Account ACC
          where CT.Doc = nDocClass
            and CT.Nostro = ACC.Classified;
		*/
        select Acc.Code, MO.OperDate
		  into memInfo.sCredSchet, memInfo.dtDate
          from memoorder MO, Account Acc
          where MO.AccountCred = Acc.Classified
		    and MO.AccountDeb  = nDebClass
		    and MO.doc in (
               select classified from doctree
                where category = 7 and lev = 1
                connect by prior classified = parent
                start with Classified = nDocClass
            )
     	        and mo.operdate is not null -- �������� �.�. 22.04.2003
			;

      end if;
      if memInfo.nCategory in( 5, 11, 12) then
         select AccCred.Code into memInfo.sCredSchet
           from Account AccCred, PrepareMoney PM
           where PM.Doc     = nDocClass
		     and PM.Account = AccCred.Classified;
      end if;
     exception
       when NO_DATA_FOUND then
	     raise_application_error(-20000,'�� ������ ���� �� ������� ��� ��������� ' ||
	     memInfo.nCategory);
     end;

	---
	--- ����� � ������ �� ������ � �� �������
	---
    select BO.sumAccount, BO.CurrAccount, BO.sumConv, BO.CurrConv
      into memInfo.nSumDebet, memInfo.nDebCurrency,
	       memInfo.nSumCredit, memInfo.nCredCurrency
      from BankOper BO
      where BO.doc = nDocClass;

      ---
	  --- ���������� �������� ����������� � ������������ �����
	  ---

      -- �����
      select CodeIsoAlph, NationBankRate( memInfo.nDebCurrency, memInfo.dtDate, 0) * memInfo.nSumDebet
        into memInfo.sDebCurrency, memInfo.nSumRubDebet
        from Currency
        where Classified = memInfo.nDebCurrency;

      -- ������
      select  CodeIsoAlph, NationBankRate( memInfo.nCredCurrency, memInfo.dtDate, 0) * memInfo.nSumCredit
        into  memInfo.sCredCurrency, memInfo.nSumRubCredit
        from  Currency
        where Classified = memInfo.nCredCurrency;

	 CreateDescription( memInfo);

end;


end;
/

