CREATE OR REPLACE procedure DPC_PNB_CtrlEditPayPrice
 --02.05.2006    ������� �.�. ���������� ��������� ��� ���������� ������ � �������������� �����������
 --              �� 02-05-2006 DPC_PNB_CtrlEditPayPrice.msg
 is
   idPayDoc    dt.reference;
   nPayPrice   dt.amount;
   nPayRest    dt.amount;
   nAmount     dt.amount;
   idEnClass   dt.reference;
   nCategory   dt.constvalue;
   nProp2225   dt.status;
begin
   -- ����� ��������� �������� � ������ ���������� ���������
   nPayPrice := nvl( Content.UnPackNumber( 'CtrlFinance.PayPrice' ),
                     nvl( Ctrl_proc.GetAmount( Message.idObject, 5 ), 0 ));
   if nPayPrice <= 0 then
      raise_application_error( -20000, '����� ������� ������ ���� �������������.' );
   end if;
   -- ������� ��������/����������
   nProp2225 := nvl( Content.UnPackNumber( 'CtrlFinance.PropWriteOff' ),
                     ObjAttrNoCheckRights.GetOneProp( nvl( Message.idObject, 0 ),
                             ObjAttrNoCheckRights.PropClass( 2225 )));
   -- ��������� ��������
   idPayDoc := Content.UnPackNumber( 'CtrlFinance.PayDoc' );
   if idPayDoc is null then
      begin
         select DocAssoc into idPayDoc
           from ObjAssoc
          where DocObj   = Message.idObject
            and Category = 2206;
      exception
         when NO_DATA_FOUND then
            return;
         when TOO_MANY_ROWS then
            raise_application_error( -20000, '������� ������� ����� ���� ������� '||
                                             '������ ��� ������ ���������� ���������' );
      end;
   end if;
   -- ����� ���������� ���������
   select DocType, Category into idEnClass, nCategory
     from DocTree where Classified = idPayDoc;
   if nCategory in ( 4, 5, 11, 12, 15 ) then
      begin
         select SumAccount into nAmount
           from BankOper where Doc = idPayDoc;
      exception
         when OTHERS then
            return;
      end;
--   elsif nCategory = 4 then
--      begin
--         select SumConv into nAmount
--           from BankOper where Doc = idPayDoc;
--      exception
--         when OTHERS then
--            return;
--      end;
   elsif nCategory in ( 41, 42 ) then
      if ObjAttrNoCheckRights.GetOneProp( idEnClass,
            ObjAttrNoCheckRights.PropClass( 2211 )) = 1 then
         --'�������� ������� ������ - �����������'
         select SumFrom into nAmount
           from BankOperConversion where Doc = idPayDoc;
      else
         --'������� ������'
         select SumTo into nAmount
           from BankOperConversion where Doc = idPayDoc;
      end if;
   end if;
   if nvl( nAmount, 0 ) <= 0 then
      return;
   end if;
   begin
      select nAmount - nvl( sum( Amount ), 0 )
        into nPayRest
        from od.ControlCurrency
       where LinkType = 5
         and Doc in ( select DocObj from ObjAssoc
                       where DocAssoc = idPayDoc
                         and Category = 2206
                         and DocObj  != nvl( Message.idObject, 0 ))
         and exists ( select * from DocTree
                       where Classified = ControlCurrency.Doc
                         and DocState not in ( Constants.State_Cancel,
                                               Constants.State_Rollback ))
         and nProp2225 = ObjAttrNoCheckRights.GetOneProp( Doc, ObjAttrNoCheckRights.PropClass( 2225 ));
   exception
      when OTHERS then
         return;
   end;
   if nPayRest <= 0 then
      raise_application_error( -20000, '�� ��� ��������� ��� �����' );
   elsif nPayRest < nPayPrice then
      raise_application_error( -20000, '�� ������ ��������� ����� �� ����� '||nPayRest );
   end if;
end DPC_PNB_CtrlEditPayPrice;
/
