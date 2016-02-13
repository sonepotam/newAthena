create or replace procedure bp_msfo_Clear_Fct_Payment( dtStart DATE) is
/*
   ����������  : ��������� ���� rec_process � 0
   ������������: bp_msfo_Clear_Fct_Payment
   �����       : ������� �.�.
   ������      : 1.0.0.0
   .0 

������� �������
����       �����  	    ���������
------------------------------------------------------------------------
22.07.2004 ������� �.�. ������� ���������
*/  
begin
  update fct_payment 
     set rec_process = 0
    where system_code_subject = 'ATHENA' 	
	  and dt = to_char( dtStart, 'yyyymmdd');
end;