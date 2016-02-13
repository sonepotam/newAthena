CREATE OR REPLACE procedure bp_msfo_fill_det_country is
/*
   ����������  : ���������� DET_COUNRY
   ������������: bp_msfo_fill_DET_COUNRY 
   �����       : ����������� �.�.
   ������      : 1.0.0.2 

������� �������
����       �����  	    ���������
------------------------------------------------------------------------
21.07.2004 ����������� �.�. ������� ���������
22.07.2004 ����������� �.�. ��������� ����� �������     
*/
DCRow Det_Country%rowtype;
begin
 update Det_Country set Rec_Process=0;
 for rec in ( select Label,CodeISONumb from Country c) loop
 begin
-- ������ ���  
   insert into Det_Country
   (       Country_Name, Country_Code_Num,     DT,            Rec_Status,Rec_Process,Rec_Unload)
   values( rec.LABEL,    rec.CODEISONUMB,      '20010101',    '0',1,0);	      
   exception
     when DUP_VAL_ON_INDEX then
       select dc.* into DCRow from msfo.Det_Country dc
	   where dc.Country_Code_Num = rec.CodeISONumb;
       if rec.Label    = DCRow.Country_Name  then
      -- ������ ��� ����
	     begin
		   if DCRow.rec_status='1' then
              update Det_Country dc set dc.rec_status ='0',dc.rec_process=1,dc.rec_unload=0
	          where dc.Country_Code_Num = rec.CodeISONumb;
		   else
		   	  update Det_Country dc set dc.rec_process=1
	          where dc.Country_Code_Num = rec.CodeISONumb;
		   end if;	  
		 end;
       else
      -- ������ ����, �� ����������
		 update Det_Country dc set dc.rec_status = '0',dc.Country_Name = rec.Label,
		                           dc.rec_process=1,dc.rec_unload=0 
		 where dc.Country_Code_Num = rec.CodeISONumb;
	   end if;															 	 
   end;     
 end loop;
 for rec in ( select * from Det_Country where rec_process=0) loop
   if rec.rec_status='0' then 
      update Det_Country set rec_status='1',rec_unload=0 where Country_Code_Num = rec.Country_Code_Num; 
   end if;
 end loop;  
end;
/
