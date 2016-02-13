---
--- �������� ������
---
declare 
  nClass number;
  i      number := 1;
begin
 --- ������� ������ �����
 delete from registrykey 
 where fullname  =  '\BANKSKEYS\BP\REPORT\BP_PM_VALMEMOORDER';	 
 --- ��������� �����
 Registry.AddSection( 'BANKSKEYS',     'BP',     '��� ���������� ��');
 Registry.AddSection( 'BANKSKEYS\BP',  'Report', '������');
 Registry.AddSection( 'BANKSKEYS\BP\Report', 'BP_PM_VALMEMOORDER', '�������� ���.�����');
 --- ������� �����
 for rec in ( select * from docType where label in (
               '���������� �����. �������(���)',
               '����������� �����.�������(���)',
               '�������� �� ��������')) loop
   Registry.AddKey( 'BANKSKEYS\BP\REPORT\BP_PM_VALMEMOORDER', 
     'Document' || i, 'Document'|| i, '', 0, null, 9, rec.Classified);
   i := i + 1;
 end loop;
end;
/
commit;
