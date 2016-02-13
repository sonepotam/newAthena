CREATE OR REPLACE procedure bp_msfo_det_finstr   is
/*
   Назначение  : Заполнение det_finstr
   Наименование: bp_msfo_det_finstr
   Автор       : Ефимов И.В.
   Версия      : 1.0.0.0 

История проекта
Дата       Автор  	    Изменение
------------------------------------------------------------------------
22.07.2004 Ефимов И.В. Создана процедура      

*/

finRow det_finstr%rowtype;

begin
update Det_finstr     set Rec_Process=0;
for rec in (
select c.codeisonumb iso, c.label l
from currency c
where  c.codeisonumb is not null) loop
begin

insert into 
det_finstr  (FINSTR_CODE,FINSTR_NAME,FINSTR_NAME_S,dt,rec_status,rec_unload,rec_process)
values (rec.iso, rec.l,rec.l,'20010101','0','0','1');

exception
     when DUP_VAL_ON_INDEX then
	select * into finrow from det_finstr where finstr_CODE =rec.iso;
	if rec.iso=finrow.finstr_code and
	   rec.l=finrow.finstr_name and
           rec.l=finrow.finstr_name_s  then
		if finrow.rec_status='1' then
	           update det_finstr set rec_status = '0',rec_process='1',rec_unload='0' 
        	   where finstr_code = rec.iso;
		elsif   finrow.rec_status='0' then
		update det_finstr  set rec_process='1'
		where finstr_code = rec.iso;
		end if;
           else 
           update  det_finstr finrow
          set finrow.finstr_code =rec.iso,
               finrow.finstr_name=rec.l,
               finrow.FINSTR_Name_S=rec.l,
               finrow.rec_status='0',rec_process='1',rec_unload='0'
             where finrow.finstr_code=rec.iso;

	 end if;
	end;
    end loop;
for rec in (select * from det_finstr where rec_process=0) loop
	if rec.rec_status='0'
	then
	update det_finstr set rec_status='1', rec_unload=0
	where finstr_code=rec.finstr_code;
	end if;
	end loop;


end;
/

