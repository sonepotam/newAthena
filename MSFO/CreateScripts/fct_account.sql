create table fct_account 
(
 DT VARCHAR2 ( 10) NOT NULL,
 REST_NAT NUMBER(24,3),
 DEBET NUMBER(24,3),
 DEBET_NAT NUMBER(24,3),
 CREDIT NUMBER(24,3),
 CREDIT_NAT NUMBER(24,3),
 ACCOUNT_CODE VARCHAR2 (100),
 REC_STATUS CHAR(1) NOT NULL,
 REST NUMBER(24,3),
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(16)
)
tablespace MSFO_DATA
/
comment on column fct_account.DT is 'ƒата'
/
comment on column fct_account.REST is 'ќстаток в валюте счета на конец операционного дн€'
/
comment on column fct_account.REST_NAT is 'ќстаток в национальной валюте на конец операционного дн€'
/
comment on column fct_account.DEBET is 'ќборот по дебету в валюте счета на конец операционного дн€'
/
comment on column fct_account.DEBET_NAT is 'ќборот по дебету в национальной валюте на конец операционного дн€'
/
comment on column fct_account.CREDIT is 'ќборот по кредиту в валюте счета на конец операционного дн€'
/
comment on column fct_account.CREDIT_NAT is 'ќборот по кредиту в национальной валюте на конец операционного дн€'
/
comment on column fct_account.ACCOUNT_CODE is ' од лицевого счета'
/
comment on column fct_account.REC_STATUS is 'REC_STATUS'
/
comment on table fct_account is 'ќстатки и обороты по лицевым счетам'
/

ALTER TABLE fct_account
ADD CONSTRAINT pk_fct_account 
PRIMARY KEY(dt, account_code)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_fct_account_unl
    on fct_account( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE fct_account
ADD CONSTRAINT fk_fct_account_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE fct_account
ADD CONSTRAINT fk_fct_account_accode
FOREIGN KEY(account_code)
REFERENCES det_account(code)
/
