create table ass_det_balance ( DT VARCHAR2 ( 10),
BALANCE_CODE_PARENT VARCHAR2 ( 25),
CHAPTER_CODE_CHAPTER VARCHAR2 ( 1),
PLAN_BAL_CODE_PLAN_BAL VARCHAR2 ( 30),
BALANCE_CODE_CHILD VARCHAR2 ( 25),
CHAPTER_CODE_CHAPTER_CHILD VARCHAR2 ( 1),
PLAN_BAL_CODE_PLAN_BAL_CHILD VARCHAR2 ( 30),
REC_STATUS VARCHAR2 ( 1),
ID_FILE NUMBER ( 16))
tablespace MSFO_NSI
/
comment on column ass_det_balance.DT is 'Дата открытия'
/
comment on column ass_det_balance.BALANCE_CODE_PARENT is 'Код балансового счета'
/
comment on column ass_det_balance.CHAPTER_CODE_CHAPTER is 'Код главы'
/
comment on column ass_det_balance.PLAN_BAL_CODE_PLAN_BAL is 'Код плана счетов'
/
comment on column ass_det_balance.BALANCE_CODE_CHILD is 'Код балансового счета'
/
comment on column ass_det_balance.CHAPTER_CODE_CHAPTER_CHILD is 'Код главы'
/
comment on column ass_det_balance.PLAN_BAL_CODE_PLAN_BAL_CHILD is 'Код плана счетов'
/
comment on column ass_det_balance.REC_STATUS is 'REC_STATUS'
/
comment on column ass_det_balance.ID_FILE is 'ID_FILE'
/
 COMMENT ON TABLE ass_det_balance is 'Ассоциатор балансовыч счетов'
/


EXIT