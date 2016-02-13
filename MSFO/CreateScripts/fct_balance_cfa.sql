create table fct_balance_cfa
(
 REST NUMBER(24,3),
 REST_NAT NUMBER(24,3),
 REST_OUT NUMBER(24,3),
 REST_NAT_OUT NUMBER(24,3),
 DEBET NUMBER(24,3),
 DEBET_NAT NUMBER(24,3),
 CREDIT NUMBER(24,3),
 CREDIT_NAT NUMBER(24,3),
 DT VARCHAR2( 10),
 BALANCE_CODE VARCHAR2( 25),
 BALANCE_CHAPTER_CODE CHAR(1) NOT NULL,
 BALANCE_PLAN_BAL_CODE VARCHAR2(100) NOT NULL,
 CFA_CODE VARCHAR2(100) NOT NULL,
 CURRENCY_CURR_CODE_TXT CHAR(3) NOT NULL,
 DEPARTMENT_CODE VARCHAR2(100),
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(16)
)
tablespace MSFO_DATA
/

comment on column fct_balance_cfa.REST is 'Входящий остаток в валюте счета'
/
comment on column fct_balance_cfa.REST_NAT is 'Входящий остаток в национальной валюте (определяется подразделением)'
/
comment on column fct_balance_cfa.REST_OUT is 'Исходящий остаток в валюте счета'
/
comment on column fct_balance_cfa.REST_NAT_OUT is 'Исходящий остаток в национальной валюте (определяется подразделением)'
/
comment on column fct_balance_cfa.DEBET is 'Оборот по дебету в валюте счета'
/
comment on column fct_balance_cfa.DEBET_NAT is 'Оборот по дебету в национальной валюте'
/
comment on column fct_balance_cfa.CREDIT is 'Оборот по кредиту в валюте счета'
/
comment on column fct_balance_cfa.CREDIT_NAT is 'Оборот по кредиту в национальной валюте'
/
comment on column fct_balance_cfa.DT is 'Дата, на которую поступают остатки и обороты'
/
comment on column fct_balance_cfa.BALANCE_CODE is 'Код балансового счета'
/
comment on column fct_balance_cfa.BALANCE_CHAPTER_CODE is 'Код главы'
/
comment on column fct_balance_cfa.BALANCE_PLAN_BAL_CODE is 'Код плана счетов'
/
comment on column fct_balance_cfa.CFA_CODE is 'Код ЦФУ'
/
comment on column fct_balance_cfa.CURRENCY_CURR_CODE_TXT is 'Код валюты ISO'
/
comment on column fct_balance_cfa.DEPARTMENT_CODE is 'Код подразделения'
/
comment on column fct_balance_cfa.REC_STATUS is 'REC_STATUS'
/
comment on column fct_balance_cfa.ID_FILE is 'ID_FILE'
/
COMMENT ON TABLE fct_balance_cfa is 'Остатки и обороты по балансовым счетам в разрезе ЦФУ'
/

ALTER TABLE fct_balance_cfa
ADD CONSTRAINT pk_fct_balance_cfa 
PRIMARY KEY(dt, department_code, balance_code, currency_curr_code_txt)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_fct_balance_cfa_unl
    on fct_balance_cfa( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE fct_balance_cfa
ADD CONSTRAINT fk_fct_balance_cfa_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE fct_balance_cfa
ADD CONSTRAINT fk_fct_balance_cfa_balcode
FOREIGN KEY(balance_code)
REFERENCES det_balance(balance_code)
/

ALTER TABLE fct_balance_cfa
ADD CONSTRAINT fk_fct_balance_cfa_chapcode
FOREIGN KEY(balance_chapter_code)
REFERENCES det_chapter(chapter_code)
/

ALTER TABLE fct_balance_cfa
ADD CONSTRAINT fk_fct_balance_cfa_planbal
FOREIGN KEY(balance_plan_bal_code)
REFERENCES det_plan_bal(plan_bal_code)
/

ALTER TABLE fct_balance_cfa
ADD CONSTRAINT fk_fct_balance_cfa_cfa
FOREIGN KEY(cfa_code)
REFERENCES det_cfa(code)
/

ALTER TABLE fct_balance_cfa
ADD CONSTRAINT fk_fct_balance_cfa_curr
FOREIGN KEY(currency_curr_code_txt)
REFERENCES det_currency(curr_code_txt)
/

ALTER TABLE fct_balance_cfa
ADD CONSTRAINT fk_fct_balance_cfa_depart
FOREIGN KEY(department_code)
REFERENCES det_department(code_department)
/
