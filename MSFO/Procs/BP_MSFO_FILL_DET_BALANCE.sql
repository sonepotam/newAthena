CREATE OR REPLACE procedure bp_msfo_fill_det_balance is
/*
   ����������  : ���������� DET_BALANCE
   ������������: bp_msfo_fill_DET_COUNRY 
   �����       : ����������� �.�.
   ������      : 1.0.0.2 

������� �������
����       �����  	    ���������
------------------------------------------------------------------------
21.07.2004 ����������� �.�. ������� ���������
22.07.2004 ����������� �.�. ��������� �������� � Ass_Det_Balance 
22.07.2004 ����������� �.�. ��������� ����� �������
23.07.2004 ����������� �.�. ������ �������� � Ass_Det_Balance       
*/
DBRow Det_Balance%rowtype;
-- ABRow Ass_Det_Balance%rowtype;
begin
 update Det_Balance     set Rec_Process=0;
-- update Ass_Det_Balance set Rec_Process=0; 
 for rec in 
 ( select Classified,Label,Code,IsActive,Parent from GeneralAccTree
   where (length(Code)=5 or length(Code)=3) and bp_msfo_decodechapter(Classified) is not Null ) 
 loop
 begin
-- ������  � Det_Balance ���  
   insert into Det_Balance
   ( Balance_Code,Balance_Name,Balance_Vid,Balance_Razd,DT,Chapter_Code_Chapter,
    Plan_Bal_Code_Plan_Bal,Rec_Status,Rec_Process,Rec_Unload)
   values( rec.Code,rec.LABEL,rec.IsActive,bp_msfo_decodechapter(rec.Classified),
           '20010101',bp_msfo_decodechapter(rec.Classified),'BANK_RUR','0',1,0);	      
   exception
-- ������ ��� ����������    
   when DUP_VAL_ON_INDEX then
      select db.* into DBRow from msfo.Det_Balance db where db.Balance_Code = rec.Code;
      if DBRow.Balance_Name           = rec.Label and
	     DBRow.Balance_Vid            = rec.IsActive and
		 DBRow.Balance_Razd           = bp_msfo_decodechapter(rec.Classified) and
		 DBRow.DT                     = '20010101' and 
		 DBRow.Chapter_Code_Chapter   = bp_msfo_decodechapter(rec.Classified) and
         DBRow.Plan_Bal_Code_Plan_Bal = 'BANK_RUR'
	  then 
      -- ������ �� �������� 
	    begin 
	      if DBRow.rec_status='1' then
            update Det_Balance db set db.rec_status ='0',db.rec_process=1,db.rec_unload=0
	        where db.Balance_Code = rec.Code;
		  else
		    update Det_Balance db set db.rec_process=1
	        where db.Balance_Code = rec.Code;
		  end if;
	    end; 
      else
      -- ������ �������� ������ 0 � UPDATE	  
         update Det_Balance db set db.rec_status = '0',
                                   db.rec_process = 1,
							       db.rec_unload = 0,	 			  
		                           db.Balance_Name = rec.Label,
	                               db.Balance_Vid  = rec.IsActive,
		                           db.Balance_Razd = bp_msfo_decodechapter(rec.Classified),
		                           db.DT          = '20010101', 
		                           db.Chapter_Code_Chapter = bp_msfo_decodechapter(rec.Classified),
                                   db.Plan_Bal_Code_Plan_Bal = 'BANK_RUR'
 	     where db.Balance_Code = rec.Code;
	  end if;															 	 
  end;
--  if length(rec.Code)=5 then
--    begin
---- ������  � Ass_Det_Balance ���  
--     insert into Ass_Det_Balance
--     ( DT,Balance_Code_Parent,Chapter_Code_Chapter,Plan_Bal_Code_Plan_Bal,
--	   Balance_Code_Child,Chapter_Code_Chapter_Child,Plan_Bal_Code_Plan_Bal_Child,
--	   Rec_Status,Rec_Process,Rec_Unload)
--	 values('20010101',
--	         Substr(rec.Code,1,3),bp_msfo_decodechapter(rec.Parent),'BANK_RUR',
--	         rec.Code,bp_msfo_decodechapter(rec.Classified),'BANK_RUR','0',1,0);	      
--     exception
---- ������ � Ass_Det_Balance ��� ����������    
--     when DUP_VAL_ON_INDEX then
--        select ab.* into ABRow from msfo.Ass_Det_Balance ab where ab.Balance_Code_Child=rec.Code;
--        if ABRow.DT                           = '20010101' and
--		   ABRow.Balance_Code_Parent          = Substr(rec.Code,1,3) and
--		   ABRow.Chapter_Code_Chapter         = bp_msfo_decodechapter(rec.Parent) and
--		   ABRow.Plan_Bal_Code_Plan_Bal       = 'BANK_RUR' and
--		   ABRow.Chapter_Code_Chapter_Child   = bp_msfo_decodechapter(rec.Classified) and
--		   ABRow.Plan_Bal_Code_Plan_Bal_Child = 'BANK_RUR'
--		then 
--      -- ������ �� ��������
--	      begin
--		    if ABRow.rec_status='1' then
--               update Ass_Det_Balance ab set ab.rec_status ='0',ab.rec_process=1,ab.rec_unload=0
--	           where ab.Balance_Code_Child = rec.Code;
--		    else
--		   	   update Ass_Det_Balance ab set ab.rec_process=1
--	           where ab.Balance_Code_Child = rec.Code;
--		    end if;	  
--		  end; 
--      else
--      -- ������ �������� 	  
--         update Ass_Det_Balance ab set ab.rec_status                   ='0',
--	                                   ab.rec_process                  = 1,
--									   ab.rec_unload                   = 0,	 			  
--		                               ab.DT                           = '20010101', 
--		                               ab.Balance_Code_Parent          = Substr(rec.Code,1,3),
--									   ab.Chapter_Code_Chapter         = bp_msfo_decodechapter(rec.Parent),
--									   ab.Plan_Bal_Code_Plan_Bal       = 'BANK_RUR',
--									   ab.Chapter_Code_Chapter_Child   = bp_msfo_decodechapter(rec.Classified),
--									   ab.Plan_Bal_Code_Plan_Bal_Child = 'BANK_RUR'
--	     where ab.Balance_Code_Child = rec.Code;
--	  end if;															 	 
--  end;
--  end if;
 end loop;
 for rec in ( select * from Det_Balance where rec_process=0) loop
   if rec.rec_status='0' then 
      update Det_Balance set rec_status='1',rec_unload=0 
	  where Balance_Code = rec.Balance_Code; 
   end if;
 end loop;
-- for rec in ( select * from Ass_Det_Balance where rec_process=0) loop
--   if rec.rec_status='0' then 
--      update Ass_Det_Balance set rec_status='1',rec_unload=0 
--	  where Balance_Code_Child = rec.Balance_Code_Child; 
--   end if;
-- end loop;   
end;
/
