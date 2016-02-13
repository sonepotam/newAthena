create table det_plan_bal ( PLAN_BAL_CODE VARCHAR2 (100),
PLAN_BAL_NAME VARCHAR2 ( 250),
DT VARCHAR2 ( 10),
REC_STATUS CHAR( 1),
REC_UNLOAD NUMBER(1),
REC_PROCESS NUMBER(1),
ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_plan_bal.PLAN_BAL_CODE is 'Код плана счетов'
/
comment on column det_plan_bal.PLAN_BAL_NAME is 'Название плана счетов'
/
comment on column det_plan_bal.DT is 'Дата открытия'
/
comment on column det_plan_bal.REC_STATUS is 'REC_STATUS'
/
 COMMENT ON TABLE det_plan_bal is 'План счетов'
/
ALTER TABLE det_plan_bal
ADD CONSTRAINT pk_det_plan_bal PRIMARY KEY(plan_bal_code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_DET_PLAN_BAL_unl
    on DET_PLAN_BAL( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_plan_bal
ADD CONSTRAINT fk_det_plan_bal_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

alter table det_plan_bal modify
(
PLAN_BAL_NAME NOT NULL,
DT NOT NULL,
REC_STATUS NOT NULL
)
;
