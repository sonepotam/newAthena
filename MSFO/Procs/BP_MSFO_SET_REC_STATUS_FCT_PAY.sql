CREATE OR REPLACE procedure bp_msfo_Set_Rec_Status_Fct_Pay( dtStart DATE) is
/*
   Назначение  : Установка всех rec_process в 1
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
     set rec_status = 1, rec_unload = 0
    where system_code_subject = 'ATHENA' 	
      and rec_process = 0
      and rec_status = '0'
	  and dt = to_char( dtStart, 'yyyymmdd');
end;
/
