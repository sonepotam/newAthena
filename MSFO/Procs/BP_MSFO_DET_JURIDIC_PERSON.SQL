CREATE OR REPLACE procedure bp_msfo_det_juridic_person as
/*
   Назначение  : Заполнение DET_JURIDIC_PERSON
   Наименование: BP_MSFO_DET_JURIDIC_PERSON 
   Автор       : Митушин А.С.
   Версия      : 1.0.0.0 

История проекта
Дата       Автор  	    Изменение
------------------------------------------------------------------------
21.07.2004 Митушин А.С. Создана процедура      
*/
type TRecord is record (
	   Label  		det_juridic_person.juridic_person_name_s%type,
	   Description	det_juridic_person.juridic_person_name%type,
	   DateOpen		det_juridic_person.dt%type,
	   Classified	det_juridic_person.code_subject_subject%type,
	   SysFil		det_juridic_person.code_department_department%type,
	   SubSys		det_juridic_person.system_code_system%type,
	   RecStat		det_juridic_person.rec_status%type
	 );

OldRec 	  TRecord;
NewRec 	  TRecord;

begin
	 update det_juridic_person set rec_process=0;

	 for dt in (
	   select * from doctree where doctype in (
	     select classified from doctype where label in ('Юр. лица','Банки')
	   ) and docstate in (
	     select classified from docstate where conststate in (1,3)
	   )
	 ) loop
	 
	   NewRec.Label:=substr(dt.Label,1,30);
	   NewRec.Description:=substr(dt.Description,1,250);
	   NewRec.DateOpen:=to_char(dt.InitDate,'YYYYMMDD');
	   NewRec.Classified:=to_char(dt.classified);
	   NewRec.SysFil:=to_char(NVL(dt.sysfilial,1));
	   NewRec.SubSys:='ATHENA';
	   
	   begin
	     select juridic_person_name_s, juridic_person_name, dt, 
		 code_subject_subject, code_department_department, 
		 system_code_system,rec_status 
		 into OldRec from det_juridic_person  
		 where code_subject_subject=NewRec.Classified and 
		 code_department_department=NewRec.SysFil and 
		 system_code_system=NewRec.SubSys;
		 
		 if NewRec.Label	   <> OldRec.Label	  	  or
		    NewRec.Description <> OldRec.Description  or
			NewRec.DateOpen    <> OldRec.DateOpen     then
			
			update det_juridic_person 
			set juridic_person_name_s      = NewRec.Label,
			    juridic_person_name        = NewRec.Description,
				dt                         = NewRec.DateOpen,
				rec_status				   = '0',
				rec_process				   = 1, 
				rec_unload				   = 0
		 	where code_subject_subject=NewRec.Classified and 
		 	code_department_department=NewRec.SysFil and 
		 	system_code_system=NewRec.SubSys;		 
		  else
		    if OldRec.RecStat='1' then
			  update det_juridic_person set rec_status='0',
			  rec_process=1, rec_unload=0		  
		 	  where code_subject_subject=NewRec.Classified and 
		 	  code_department_department=NewRec.SysFil and 
		 	  system_code_system=NewRec.SubSys;		 
			elsif OldRec.RecStat='0' then
			  update det_juridic_person set rec_process=1		  
		 	  where code_subject_subject=NewRec.Classified and 
		 	  code_department_department=NewRec.SysFil and 
		 	  system_code_system=NewRec.SubSys;		 
			end if;		
		  end if;	 
	   exception
	     when no_data_found then
		   insert into det_juridic_person (
		     juridic_person_name_s, juridic_person_name, dt, 
			 code_subject_subject, code_department_department,
			 system_code_system, 
			 rec_status, rec_process, rec_unload
		   ) values (
		     NewRec.Label, NewRec.Description, NewRec.DateOpen,
			 NewRec.Classified, NewRec.SysFil, NewRec.SubSys,
			 '0',1,0
		   );
	   end;	 
	 end loop;
	 
	 update det_juridic_person set rec_status='1', rec_unload=0 
	 where rec_status='0' and rec_process=0;
end;
/
