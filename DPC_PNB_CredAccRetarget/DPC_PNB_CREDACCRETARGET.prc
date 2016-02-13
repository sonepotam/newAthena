CREATE OR REPLACE procedure DPC_PNB_CredAccRetarget
---------------------------------------------------------------------------------------------------
-- ��������: - ��������� �������������� ���_ ����������� � �������� ����� �������
-- ����� ��������������� - ���.�������� � ���������� -40
-- 29.11.2005 ������� �.�. ����������� ��������� ����� �������. ���� ���� �� � ���, �� �� ���������
---------------------------------------------------------------------------------------------------
as
   idCurDoc          DT.Reference default    Context.CurrentDoc; -- ������� ��������
   sCredAcc          Account.Code%type;   -- ���� �������
   idBenefAccDoc     DT.Reference;        -- ���� ����������_
   idAcc             DT.Reference;        -- ����� ��� ���������� ������
   sDescText         DT.Label;            -- ����� ���.��������_
   sBenefAccCode     Account.Code%type;   -- ��� ����� ����������_
   sNewAccCode       Account.Code%type;   -- ��� ������ ����� ����������_
   -- ������ �� ���.��������
   idDescRetarget    DT.Reference default ObjAttr.DescClass(-40);
   idPropSolutionReq DT.Reference default ObjAttr.PropClass(54);
   nCategory		 number(2);  --��������� ���.���������
begin
   select Category into nCategory
      from DocTree
	  where Classified = idCurDoc;
   if nCategory=15 then --������� �� ������� �����
      select Account into idAcc from BankOper where Doc = idCurDoc;
   elsif  nCategory=4 then  --������� � ������ ����
      select Nostro into idAcc from CustomerTransfer where Doc = idCurDoc;
   else  --������ ��������� - �������
      return;
   end if;
   --select Code into sCredAcc from Account
   --      where Classified = idAcc Closed > s.ysdate;
   -- ���� � ��������������� ��������� �� �������� ��� ������ ���� �������
   begin
     if idAcc is not null then 
       select acc.classified into idAcc 
	     from account acc, doctree dt
	     where acc.doc = dt.classified
	       and acc.classified = idAcc
		   and dt.docState = Constants.State_Start;
	 end if;	    
   exception
     when NO_DATA_FOUND then -- ���� �� ������ ��� �� � ���
  	   update bankOper set Account = null where Doc = idCurDoc and nCategory = 15;
  	   update CustomerTransfer set Nostro = null 
	     where Doc = idCurDoc and nCategory = 4;		  
   end; 
   
   if idAcc is null  then
      -- ���� ������� �� ��������
      -- �� �������� ���� ����������,  ���� ���������� ������� � ��
      -- � ��������� � ��������� <��������>.
      begin
         select A.Doc,
                CT.BeneficiaryAccount
           into idBenefAccDoc,
                sBenefAccCode
           from Account          A,
                CustomerTransfer CT,
                DocTree          DT
          where CT.Doc  = idCurDoc              and
                A.Code = CT.BeneficiaryAccount  and
                A.Doc = DT.Classified           and
                DT.DocState in (Constants.State_Close, Constants.State_RollBack, Constants.State_Cancel);
         -- ���� <���� ���������������> ��� ����� ����� (�� ���.��������)
         idAcc  := to_number(ObjAttr.GetOneDesc(idBenefAccDoc,idDescRetarget));
         -- ���� ��� ��������������� ����� �������� �� ������
         if idAcc is null then
            -- ���� ���� ��� �������� �������� ���� ������ � �������� <����� ���������������>.
            sDescText := to_char(idBenefAccDoc);
            -- ������ Classified ��������� <����>
            select Obj
              into idAcc
              from ObjDesc
             where DescText = sDescText            and
                   Description = idDescRetarget    and
                   s.ysdate between ValidFromDate  and ValidToDate;
         end if;
         -- ���� idAcc �� ��� ��� �� ������ - �������� �� ������-�� select'e
         begin
            -- �������� , ������ - �� ���� (� ������ ������ Account.Classified)
            select A.Classified,
                   A.Code
              into idAcc,
                   sNewAccCode
              from Account          A,
                   DocTree          DT
             where DT.Classified = idAcc
               and DT.DocState = Constants.State_Start
               and A.Doc = DT.Classified;
            -- ���� �������� ������� � ��������� ���� ������, ��
            -- ����������� ������ ���� � �������� ����� ������� ���������,
			if nCategory=15 then
              update BankOper set Account = idAcc where Doc = idCurDoc;
			elsif nCategory=4 then
              update CustomerTransfer set Nostro = idAcc where Doc = idCurDoc;
			end if;
            -- ����������� �������������� ������� <������� �������� �������> (��������� 54)
            -- EVG  211202 ObjAttr.SaveOneProp(idCurDoc,idCurDoc,idPropSolutionReq,1);
            -- � ���������� � DocText ��������� <�������� ������������� �� �����
            -- <���� ����������> �� ���� <����� ����>>.
            tal_AddToDocText(idCurDoc,3,
               '�������� ������������� �� ����� <'||sBenefAccCode||'> '||
               '�� ���� <'||sNewAccCode||'>');
         exception
            when NO_DATA_FOUND then
               null;
         end;
      exception
         when NO_DATA_FOUND then
            null;
      end;
   end if;
   -- ���� ����������� (� ���������������) ����� ������� (���) ��� <�������� �� ������� �����>
   DPC_PNB_BranchAccRetarget;
end DPC_PNB_CredAccRetarget;
/
