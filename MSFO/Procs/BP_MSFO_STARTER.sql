create or replace procedure bp_msfo_Starter( dtStart DATE) is
/*
   ����������  : ������ �������
   ������������: bp_msfo_Starter
   �����       : ������� �.�.
   ������      : 1.0.0.0
   .0 

������� �������
����       �����  	    ���������
------------------------------------------------------------------------
23.07.2004 ������� �.�. ������� ���������
*/
begin
  bp_msfo_det_currency; -- ���������� ������
  bp_msfo_det_finstr; -- ���.�����������
  bp_msfo_fill_det_country; -- ������
  bp_msfo_det_juridic_person; -- ��.����
  bp_msfo_det_phyz_person; -- ���.����
  bp_msfo_det_subject; -- �������  
  bp_msfo_det_account; -- �����
  bp_msfo_fill_ASS_ACC_BALANCE; -- ���������� ������ � ��������
  bp_msfo_fill_det_balance; -- 
  bp_msfo_fill_fct_account( dtStart); -- ������� �� ������
  -- ���������� �������� � ���������
  bp_msfo_Clear_Fct_Payment( dtStart);
    bp_msfo_fill_fct_Carry( dtStart);
    bp_msfo_fill_fct_HalfCarry( dtStart);
  bp_msfo_Set_Rec_Status_Fct_Pay( dtStart);
  
end;
/