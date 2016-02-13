create table fct_carry 
(
 CODE VARCHAR2 (100),
 VALUE NUMBER(24,3),
 VALUE_NAT NUMBER(24,3),
 DOCNUM VARCHAR2 ( 50),
 CARRY_GROUND VARCHAR2 ( 250),
 DT VARCHAR2 ( 10) NOT NULL,
 ROLECREDIT_CODE VARCHAR2 (100) NOT NULL,
 ROLEDEBET_CODE VARCHAR2 (100) NOT NULL,
 ACCOUNT_CREDIT_CODE VARCHAR2(100) NOT NULL,
 ACCOUNT_DEBET_CODE VARCHAR2(100) NOT NULL,
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/
comment on column fct_carry.CODE is 'Код проводки'
/
comment on column fct_carry.VALUE is 'Сумма в валюте проводки'
/
comment on column fct_carry.VALUE_NAT is 'Сумма в национальной валюте'
/
comment on column fct_carry.DOCNUM is 'Номер документа'
/
comment on column fct_carry.CARRY_GROUND is 'Назначение проводки'
/
comment on column fct_carry.DT is 'Дата открытия'
/
comment on column fct_carry.ROLECREDIT_CODE is 'Код  роли лицевого счета кредита для сделки'
/
comment on column fct_carry.ROLEDEBET_CODE is 'Код  роли лицевого счета дебета для сделки'
/
comment on column fct_carry.ACCOUNT_CREDIT_CODE is 'Номер лицевого счета кредита'
/
comment on column fct_carry.ACCOUNT_DEBET_CODE is 'Номер лицевого счета дебета'
/
comment on table fct_carry is 'Проводка'
/

ALTER TABLE fct_carry
ADD CONSTRAINT pk_fct_carry PRIMARY KEY(CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_fct_carry_unl
    on fct_carry( rec_unload)
    TABLESPACE MSFO_INDEX;

create index idx_fct_carry_dt
    on fct_carry( dt)
    TABLESPACE MSFO_INDEX;

ALTER TABLE fct_carry
ADD CONSTRAINT fk_fct_carry_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE fct_carry
ADD CONSTRAINT fk_fct_carry_rolecredit
 FOREIGN KEY(rolecredit_code)
REFERENCES det_roleaccount_deal(code)
/

ALTER TABLE fct_carry
ADD CONSTRAINT fk_fct_carry_roledebet
 FOREIGN KEY(roledebet_code)
REFERENCES det_roleaccount_deal(code)
/

ALTER TABLE fct_carry
ADD CONSTRAINT fk_fct_carry_acccredit
 FOREIGN KEY(account_credit_code)
REFERENCES det_account(code)
/

ALTER TABLE fct_carry
ADD CONSTRAINT fk_fct_carry_accdebet
 FOREIGN KEY(account_debet_code)
REFERENCES det_account(code)
/
