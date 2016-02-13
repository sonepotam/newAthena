create or replace procedure bp_msfo_det_account
/*
 Модуль    : bp_msfo_det_account
 Название  : Лицевой счет
 Автор     : Понятовский О.В.
 Версия    : 1.0.1.1
*/
is
   iCommit number := 0;
   idAccount od.account.classified%type := 0;
   dnull date := to_date('01.01.4444 12:00:00', 'DD.MM.YYYY HH24:MI:SS');
   r_1 Det_Account%ROWTYPE;
   r_0 Det_Account%ROWTYPE;
   cursor v_c1 is 
   select a.*, bp_msfo_decodechapter( a.maingeneralacc) glavaCode,
          CurrencyISO(a.currency) currISO, CurrencyCB(a.currency) currCB
   from account a
   where exists (select dt.classified from doctree dt 
                 where dt.classified = a.doc
                   and dt.docstate in (select classified from docstate where conststate in (1,3)))
   order by a.classified; 
    ----------------------------------------------------------------------------------------------
   function getDate(ld in date) return varchar2
   is
     s varchar2(10) := '';
   begin
   if ld is not null and ld != dnull then
      s := to_char(ld,'YYYYMMDD');
   end if;
   return s;
   end getDate;
   ----------------------------------------------------------------------------------------------
begin
   update Det_Account set rec_process = '0'
          where system_code_system = 'ATHENA';

   for f in v_c1 loop
       idAccount                         := f.classified;
       r_0.code_subject_subject          := '' || nvl(f.client,'');
       r_0.account_number                := f.code;
       r_0.account_name                  := f.label;
       r_0.is_inconsolidate              := '0';
       r_0.dt_open_acc                   := getDate(f.opened);
       r_0.dt_close_acc                  := getDate(f.closed);
       r_0.dt                            := getDate(f.opened);
       r_0.curr_code_txt_currency        := f.currISO;
       r_0.code_department_department    := to_char(f.sysfilial);
       r_0.system_code_system            := 'ATHENA';
       r_0.code_department_departme_subj := to_char(f.sysfilial);
       r_0.system_code_system_subj       := 'ATHENA';
       r_0.finstr_code_finstr            := f.currCB;
       r_0.rec_status                    := '0';
       r_0.rec_unload                    := '0';
       r_0.rec_process                   := '1';   
       r_0.chapter_code_chapter          := f.glavaCode;
       begin
          select * into r_1 from Det_Account 
          where account_number = r_0.account_number
            and code_department_department = r_0.code_department_department
            and system_code_system = r_0.system_code_system;

          if r_0.account_number                   != r_1.account_number               
             or r_0.account_name                  != r_1.account_name                 
             or r_0.is_inconsolidate              != r_1.is_inconsolidate             
             or r_0.dt_open_acc                   != r_1.dt_open_acc                  
             or r_0.dt_close_acc                  != r_1.dt_close_acc                 
             or r_0.dt                            != r_1.dt                           
             or r_0.chapter_code_chapter          != r_1.chapter_code_chapter         
             or r_0.curr_code_txt_currency        != r_1.curr_code_txt_currency       
             or r_0.code_department_department    != r_1.code_department_department   
             or r_0.system_code_system            != r_1.system_code_system           
             or r_0.code_subject_subject          != r_1.code_subject_subject         
             or r_0.code_department_departme_subj != r_1.code_department_departme_subj
             or r_0.system_code_system_subj       != r_1.system_code_system_subj      
             or r_0.finstr_code_finstr            != r_1.finstr_code_finstr  
          then
             update Det_Account
               set account_name                  = r_0.account_name,
                   is_inconsolidate              = r_0.is_inconsolidate,
                   dt_open_acc                   = r_0.dt_open_acc,                   
                   dt_close_acc                  = r_0.dt_close_acc,                  
                   dt                            = r_0.dt,                            
                   chapter_code_chapter          = r_0.chapter_code_chapter,          
                   curr_code_txt_currency        = r_0.curr_code_txt_currency,        
                   code_department_department    = r_0.code_department_department,    
                   system_code_system            = r_0.system_code_system,            
                   code_department_departme_subj = r_0.code_department_departme_subj, 
                   system_code_system_subj       = r_0.system_code_system_subj,       
                   finstr_code_finstr            = r_0.finstr_code_finstr,      
                   rec_status                    = '0',
                   rec_process                   = '1',
                   rec_unload                    = '0'
             where account_number = r_0.account_number
               and code_department_department = r_0.code_department_department
               and system_code_system = r_0.system_code_system;
          else
             if r_1.rec_status = 1 then
                update Det_Account 
                   set rec_status  = '0',
                       rec_process = '1',
                       rec_unload  = '0'
                where account_number = r_0.account_number
                  and code_department_department = r_0.code_department_department
                  and system_code_system = r_0.system_code_system;
             elsif r_1.rec_status = 0 then
                update Det_Account 
                   set rec_process = '1'
                where account_number = r_0.account_number
                  and code_department_department = r_0.code_department_department
                  and system_code_system = r_0.system_code_system;
             end if;
          end if;
       exception
          when no_data_found then
          insert into Det_Account (
             account_number,               
             account_name,                 
             is_inconsolidate,             
             dt_open_acc,                  
             dt_close_acc,                 
             dt,                           
             chapter_code_chapter,         
             curr_code_txt_currency,       
             code_department_department,   
             system_code_system,           
             code_subject_subject,         
             code_department_departme_subj,
             system_code_system_subj,      
             finstr_code_finstr,           
             rec_status,
             rec_process,
             rec_unload)
         values (
             r_0.account_number,               
             r_0.account_name,                 
             r_0.is_inconsolidate,             
             r_0.dt_open_acc,                  
             r_0.dt_close_acc,                 
             r_0.dt,                           
             r_0.chapter_code_chapter,         
             r_0.curr_code_txt_currency,       
             r_0.code_department_department,   
             r_0.system_code_system,           
             r_0.code_subject_subject,         
             r_0.code_department_departme_subj,
             r_0.system_code_system_subj,      
             r_0.finstr_code_finstr,           
             r_0.rec_status,
             r_0.rec_process,
             r_0.rec_unload);                   
       end;
   end loop;

   update Det_Account 
      set rec_status = '1',
          rec_unload = '0'
   where system_code_system = 'ATHENA'
     and rec_process = '0'
     and rec_status = '0';

   commit;
exception when others then
   dbms_output.enable(20000);
   dbms_output.put_line('Error! Account''s classified = ' || idAccount);
   dbms_output.put_line(substr(sqlerrm,1,255));
   rollback;
--   commit;
end bp_msfo_det_account;
/
show error

grant execute on od.bp_msfo_det_account to public;

exit
