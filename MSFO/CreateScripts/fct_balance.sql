create table fct_balance ( REST_IN VARCHAR2 ( 16),
REST_NAT_IN VARCHAR2 ( 16),
REST_OUT VARCHAR2 ( 16),
REST_NAT_OUT VARCHAR2 ( 16),
DEBET VARCHAR2 ( 16),
DEBET_NAT VARCHAR2 ( 16),
CREDIT VARCHAR2 ( 16),
CREDIT_NAT VARCHAR2 ( 16),
DT VARCHAR2 ( 10),
BALANCE_CODE_BALANCE VARCHAR2 ( 25),
CHAPTER_CODE_CHAPTER VARCHAR2 ( 1),
PLAN_BAL_CODE_PLAN_BAL VARCHAR2 ( 30),
CODE_DEPARTMENT_DEPARTMENT VARCHAR2 ( 30),
CURR_CODE_TXT_CURRENCY VARCHAR2 ( 3),
REC_STATUS VARCHAR2 ( 1),
ID_FILE NUMBER ( 16))
tablespace MSFO_DATA
/
comment on column fct_balance.REST_IN is 'Входящий остаток в валюте счета'
/
comment on column fct_balance.REST_NAT_IN is 'Входящий остаток в национальной валюте (определяется подразделением)'
/
comment on column fct_balance.REST_OUT is 'Исходящий остаток в валюте счета'
/
comment on column fct_balance.REST_NAT_OUT is 'Исходящий остаток в национальной валюте (определяется подразделением)'
/
comment on column fct_balance.DEBET is 'Оборот по дебету в валюте счета'
/
comment on column fct_balance.DEBET_NAT is 'Оборот по дебету в национальной валюте'
/
comment on column fct_balance.CREDIT is 'Оборот по кредиту в валюте счета'
/
comment on column fct_balance.CREDIT_NAT is 'Оборот по кредиту в национальной валюте'
/
comment on column fct_balance.DT is 'Дата'
/
comment on column fct_balance.BALANCE_CODE_BALANCE is 'Код балансового счета'
/
comment on column fct_balance.CHAPTER_CODE_CHAPTER is 'Код главы'
/
comment on column fct_balance.PLAN_BAL_CODE_PLAN_BAL is 'Код плана счетов'
/
comment on column fct_balance.CODE_DEPARTMENT_DEPARTMENT is 'Код подразделения'
/
comment on column fct_balance.CURR_CODE_TXT_CURRENCY is 'Код валюты ISO'
/
comment on column fct_balance.REC_STATUS is 'REC_STATUS'
/
comment on column fct_balance.ID_FILE is 'ID_FILE'
/
 COMMENT ON TABLE fct_balance is 'Остатки и обороты по балансовым счетам'
/


EXIT