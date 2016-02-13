create or replace procedure dpc_bp_pm_Raise30Symbol is
/*
��������� : dpc_bp_pm_Raise30Symbol
����������: �������� 30 ������� �������� ����������
������    : 1.0.0.0
VSS       : ��/DPC-���������/�������� 30 ������� �������� ����������
�����     : ������� �.�.

������� ��������
����       �����        ���������
-------------------------------------------------------------------------------
26.12.2005 ������� �.�. ������ ������
*/
  nDummy number;
begin
  select 1 into nDummy 
  from bankopersymbol bos, cashSymbol cs 
  where bos.doc = Context.CurrentDoc
    and bos.CASHSYMBOL = cs.classified
    and cs.symbol = '30';
  RaiseError( '������ 30 ��������');
exception 
  when NO_DATA_FOUND then null;
  when TOO_MANY_ROWS then RaiseError( '������ 30 ��������');
end;