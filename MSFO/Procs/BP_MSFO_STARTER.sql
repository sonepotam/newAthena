create or replace procedure bp_msfo_Starter( dtStart DATE) is
/*
   Назначение  : Запуск расчета
   Наименование: bp_msfo_Starter
   Автор       : Цейтлин П.М.
   Версия      : 1.0.0.0
   .0 

История проекта
Дата       Автор  	    Изменение
------------------------------------------------------------------------
23.07.2004 Цейтлин П.М. Создана процедура
*/
begin
  bp_msfo_det_currency; -- заполнение валюты
  bp_msfo_det_finstr; -- фин.инструменты
  bp_msfo_fill_det_country; -- страны
  bp_msfo_det_juridic_person; -- юр.лица
  bp_msfo_det_phyz_person; -- физ.лица
  bp_msfo_det_subject; -- клиенты  
  bp_msfo_det_account; -- счета
  bp_msfo_fill_ASS_ACC_BALANCE; -- ассоциатор счетов с балансом
  bp_msfo_fill_det_balance; -- 
  bp_msfo_fill_fct_account( dtStart); -- остатки по счетам
  -- заполнение проводок и переводов
  bp_msfo_Clear_Fct_Payment( dtStart);
    bp_msfo_fill_fct_Carry( dtStart);
    bp_msfo_fill_fct_HalfCarry( dtStart);
  bp_msfo_Set_Rec_Status_Fct_Pay( dtStart);
  
end;
/