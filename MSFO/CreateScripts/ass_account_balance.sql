create table ass_account_balance 
( 
DT VARCHAR2 ( 10),
ACCOUNT_CODE VARCHAR2(100),
BALANCE_CODE VARCHAR2 ( 25),
BALANCE_CHAPTER_CODE CHAR(1),
BALANCE_PLAN_BAL_CODE VARCHAR2(100),
REC_STATUS CHAR(1),
REC_UNLOAD NUMBER(1),
REC_PROCESS NUMBER(1),
ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/

comment on column ass_account_balance.DT is 'Дата открытия'
/
comment on column ass_account_balance.account_code is 'Код лицевого счета'
/
comment on column ass_account_balance.balance_code is 'Код балансового счета'
/
comment on column ass_account_balance.BALANCE_CHAPTER_CODE is 'Код главы'
/
comment on column ass_account_balance.BALANCE_PLAN_BAL_CODE is 'Код плана счетов'
/
COMMENT ON TABLE ass_account_balance is 'Ассоциатор лицевого и балансового счетов'
/

ALTER TABLE ass_account_balance
ADD CONSTRAINT pk_ass_account_balance PRIMARY KEY(ACCOUNT_CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_ass_account_balance_unl
    on ass_account_balance( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE ass_account_balance
ADD CONSTRAINT fk_ass_account_balance_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE ass_account_balance
ADD CONSTRAINT fk_ass_account_bal_acc_code
 FOREIGN KEY(account_code)
REFERENCES det_account(code)
/

ALTER TABLE ass_account_balance
ADD CONSTRAINT fk_ass_account_bal_bal_code
 FOREIGN KEY(balance_code)
REFERENCES det_balance(balance_code)
/

ALTER TABLE ass_account_balance
ADD CONSTRAINT fk_ass_account_bal_chapt_code
 FOREIGN KEY(balance_chapter_code)
REFERENCES det_chapter(chapter_code)
/

ALTER TABLE ass_account_balance
ADD CONSTRAINT fk_ass_account_bal_pl_bal_code
 FOREIGN KEY(balance_plan_bal_code)
REFERENCES det_plan_bal(plan_bal_code)
/

ALTER TABLE ass_account_balance MODIFY
(
 DT NOT NULL,
 BALANCE_CODE NOT NULL,
 BALANCE_CHAPTER_CODE NOT NULL,
 BALANCE_PLAN_BAL_CODE NOT NULL,
 REC_STATUS NOT NULL
)
;
