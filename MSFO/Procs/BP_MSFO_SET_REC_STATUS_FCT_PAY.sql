CREATE OR REPLACE procedure bp_msfo_Set_Rec_Status_Fct_Pay( dtStart DATE) is
/*
   ����������  : ��������� ���� rec_process � 1
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
     set rec_status = 1, rec_unload = 0
    where system_code_subject = 'ATHENA' 	
      and rec_process = 0
      and rec_status = '0'
	  and dt = to_char( dtStart, 'yyyymmdd');
end;
/
