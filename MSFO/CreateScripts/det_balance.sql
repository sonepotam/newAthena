create table det_balance 
( 
PLAN_BAL_CODE VARCHAR2 (100),
REC_STATUS CHAR( 1),
BALANCE_CODE VARCHAR2 ( 25),
BALANCE_NAME VARCHAR2 ( 250),
BALANCE_VID VARCHAR2 ( 2),
BALANCE_RAZD NUMBER(2),
DT VARCHAR2 ( 10),
CHAPTER_CODE CHAR( 1),
REC_UNLOAD NUMBER(1),
REC_PROCESS NUMBER(1),
ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/

comment on column det_balance.PLAN_BAL_CODE is 'Код плана счетов'
/
comment on column det_balance.REC_STATUS is 'REC_STATUS'
/
comment on column det_balance.BALANCE_CODE is 'Код балансового счета'
/
comment on column det_balance.BALANCE_NAME is 'Название балансового счета'
/
comment on column det_balance.BALANCE_VID is 'Вид счета. А-активный, П - пассивный, АП- активно-пассивный'
/
comment on column det_balance.BALANCE_RAZD is 'Раздел плана, к которому относится балансовый счет.'
/
comment on column det_balance.DT is 'Дата открытия'
/
comment on column det_balance.CHAPTER_CODE is 'Код главы'
/
COMMENT ON TABLE det_balance is 'Балансовый счет'
/


ALTER TABLE DET_BALANCE
ADD CONSTRAINT pk_det_balance PRIMARY KEY(BALANCE_CODE)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_DET_BALANCE_unl
    on DET_BALANCE( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_balance
ADD CONSTRAINT fk_det_balance_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE det_balance
ADD CONSTRAINT fk_det_balance_plan_bal_code
 FOREIGN KEY(plan_bal_code)
REFERENCES det_plan_bal(plan_bal_code)
/

ALTER TABLE det_balance
ADD CONSTRAINT fk_det_balance_chapter_code
 FOREIGN KEY(chapter_code)
REFERENCES det_chapter(chapter_code)
/

alter table det_balance modify
( 
PLAN_BAL_CODE NOT NULL,
REC_STATUS NOT NULL,
DT NOT NULL,
CHAPTER_CODE NOT NULL
)
;
