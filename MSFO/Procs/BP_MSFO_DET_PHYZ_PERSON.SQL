CREATE OR REPLACE procedure bp_msfo_det_phyz_person as
/*
   Назначение  : Заполнение DET_PHYZ_PERSON
   Наименование: BP_MSFO_DET_PHYZ_PERSON 
   Автор       : Митушин А.С.
   Версия      : 1.0.0.0 

История проекта
Дата       Автор  	    Изменение
------------------------------------------------------------------------
21.07.2004 Митушин А.С. Создана процедура      
*/
type TRecord is record (
	   InSider		det_phyz_person.is_insider%type,
	   FIO	 		det_phyz_person.person_name%type,
	   DateOpen		det_phyz_person.dt%type,
	   Classified	det_phyz_person.code_subject_subject%type,
	   SysFil		det_phyz_person.code_department_department%type,
	   SubSys		det_phyz_person.system_code_system%type,
	   RecStat		det_juridic_person.rec_status%type
	 );

OldRec 	  TRecord;
NewRec 	  TRecord;

begin
	 update det_phyz_person set rec_process=0;

	 for dt in (
	   select * from doctree where doctype in (
	     select classified from doctype where label in ('Физ. лица','Клиенты')
	   ) and docstate in (
	     select classified from docstate where conststate in (1,3)
	   )
	 ) loop
	 
	   NewRec.InSider:='0';	 
	   NewRec.FIO:=to_char(dt.classified);	 
	   NewRec.DateOpen:=to_char(dt.InitDate,'YYYYMMDD');
	   NewRec.Classified:=to_char(dt.classified);
	   NewRec.SysFil:=to_char(NVL(dt.sysfilial,1));
	   NewRec.SubSys:='ATHENA';
	   
	   begin
	     select is_insider,person_name, dt, code_subject_subject, 
		 code_department_department, system_code_system,rec_status 
		 into OldRec from det_phyz_person  
		 where code_subject_subject=NewRec.Classified and 
		 code_department_department=NewRec.SysFil and 
		 system_code_system=NewRec.SubSys;
		 
		 if NewRec.InSider	   <> OldRec.InSider      or
		    NewRec.FIO	   	   <> OldRec.FIO	  	  or
			NewRec.DateOpen    <> OldRec.DateOpen     then
			
			update det_phyz_person 
			set is_insider		   		   = NewRec.InSider,
				person_name        		   = NewRec.FIO,
				dt                         = NewRec.DateOpen,
				rec_status				   = '0',
				rec_process				   = 1, 
				rec_unload				   = 0
		 	where code_subject_subject=NewRec.Classified and 
		 	code_department_department=NewRec.SysFil and 
		 	system_code_system=NewRec.SubSys;		 
		  else
		    if OldRec.RecStat='1' then
			  update det_phyz_person set rec_status='0',
			  rec_process=1, rec_unload=0		  
		 	  where code_subject_subject=NewRec.Classified and 
		 	  code_department_department=NewRec.SysFil and 
		 	  system_code_system=NewRec.SubSys;		 
			elsif OldRec.RecStat='0' then
			  update det_phyz_person set rec_process=1		  
		 	  where code_subject_subject=NewRec.Classified and 
		 	  code_department_department=NewRec.SysFil and 
		 	  system_code_system=NewRec.SubSys;		 
			end if;		
		  end if;	 
	   exception
	     when no_data_found then
		   insert into det_phyz_person (
		     is_insider, person_name, dt, code_subject_subject, 
			 code_department_department, system_code_system, 
			 rec_status, rec_process, rec_unload
		   ) values (
		     NewRec.InSider, NewRec.FIO, NewRec.DateOpen, NewRec.Classified, 
			 NewRec.SysFil, NewRec.SubSys, 
			 '0',1,0
		   );
	   end;	 
	 end loop;
	 
	 update det_phyz_person set rec_status='1', rec_unload=0 
	 where rec_status='0' and rec_process=0;
end;
/
