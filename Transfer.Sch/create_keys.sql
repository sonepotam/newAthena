---
--- �������� ������
---
declare nStrType  DesignObjType.code%type;
begin
 --- ��������� �����
 Registry.AddSection( 'BANKSKEYS',     'BP',     '��� ���������� ��');
 Registry.AddSection( 'BANKSKEYS\BP',  'Report', '������');
 Registry.AddSection( 'BANKSKEYS\BP\Report', 'BBR_BP_PM_REPORT_ACC_TRANSFER', '����� �� ����� ��������');
 --- ��������� ��� ������ 
 select code into nStrType from DesignObjType where constType = 2;
 --- ������� �����
 Registry.AddKey( 'BANKSKEYS\BP\REPORT\BBR_BP_PM_REPORT_ACC_TRANSFER', 
   'SBTransferSchet', '���� ����', '���� ������-��������� ���������', 0,
   null, nStrType, '30110810609020000020');
 Registry.AddKey( 'BANKSKEYS\BP\REPORT\BBR_BP_PM_REPORT_ACC_TRANSFER', 
   'SZSBBic', '��� ����', '��� ������-��������� ���������', 0,
   null, nStrType, '044030653');
end;
/
commit;
