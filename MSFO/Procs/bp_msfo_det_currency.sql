CREATE OR REPLACE procedure bp_msfo_det_currency   is
/*
   Назначение  : Заполнение det_currency
   Наименование: bp_msfo_det_currency
   Автор       : Ефимов И.В.
   Версия      : 1.0.0.0 

История проекта
Дата       Автор  	    Изменение
------------------------------------------------------------------------
22.07.2004 Ефимов И.В. Создана процедура      
*/

ValRow det_currency%rowtype;

begin
update Det_currency     set Rec_Process=0;
for rec in (
select c.codeisonumb iso, c.codecb cb
from currency c
where  c.codeisonumb is not null) loop
begin

insert into 
det_currency (CURR_CODE_TXT,CURR_CODE_NUM,CURR_CODE_ACCOUNT,CURR_CONVERT,dt,FINSTR_CODE_FINSTR,REC_STATUS,rec_unload,rec_process)
values (rec.iso, rec.cb,rec.cb,0,'20010101',rec.iso,'0','0','1');

exception
     when DUP_VAL_ON_INDEX then
	select * into valrow from det_currency where CURR_CODE_TXT =rec.iso;
	if rec.iso=valrow.curr_code_txt and
	   rec.cb=valrow.curr_code_num and
           rec.cb=valrow.curr_code_account and
           rec.iso=valrow.finstr_code_finstr then
           	if valrow.rec_status='1' then
           	update det_currency set rec_status = '0',rec_process='1',
		rec_unload='0' 
           	where valrow.curr_code_txt = rec.iso;
           	elsif valrow.rec_status='0' then
		update det_currency set rec_process='1'
                where curr_code_txt = rec.iso;
		end if;
           else 
           update  det_currency valrow
          set valrow.curr_code_num =rec.cb,
               valrow.curr_code_account=rec.cb,
               valrow.FINSTR_CODE_FINSTR=rec.iso,
               valrow.rec_status='0',rec_process='1',rec_unload='0'
             where valrow.curr_code_txt=rec.iso;

	 end if;
	end;
    end loop;
for rec in (select * from det_currency where rec_process=0) loop
	if rec.rec_status='0'
	then
	update det_currency set rec_status='1', rec_unload=0
	where curr_code_txt=rec.curr_code_txt;
	end if;
	end loop;
end;
/

