create or replace procedure bp_msfo_Clear_Fct_Payment( dtStart DATE) is
/*
   Назначение  : Установка всех rec_process в 0
   Наименование: bp_msfo_Clear_Fct_Payment
   Автор       : Цейтлин П.М.
   Версия      : 1.0.0.0
   .0 

История проекта
Дата       Автор  	    Изменение
------------------------------------------------------------------------
22.07.2004 Цейтлин П.М. Создана процедура
*/  
begin
  update fct_payment 
     set rec_process = 0
    where system_code_subject = 'ATHENA' 	
	  and dt = to_char( dtStart, 'yyyymmdd');
end;