create table fct_halfcarry 
(
 CODE VARCHAR2 (100), 
 VALUE NUMBER(24,3),
 VALUE_NAT NUMBER(24,3),
 DOCNUM VARCHAR2 ( 50),
 HALFCARRY_GROUND VARCHAR2 ( 250),
 DT VARCHAR2 ( 10) NOT NULL,
 ROLEACCOUNT_DEAL_CODE VARCHAR2(100) NOT NULL,
 ACCOUNT_CODE VARCHAR2(100) NOT NULL,
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/
comment on column fct_halfcarry.CODE is 'Код полупроводки'
/
comment on column fct_halfcarry.VALUE is 'Сумма в валюте полупроводки'
/
comment on column fct_halfcarry.VALUE_NAT is 'Сумма в национальной валюте'
/
comment on column fct_halfcarry.DOCNUM is 'Номер документа'
/
comment on column fct_halfcarry.HALFCARRY_GROUND is 'Назначение полупроводки'
/
comment on column fct_halfcarry.DT is 'Дата открытия'
/
comment on column fct_halfcarry.ROLEACCOUNT_DEAL_CODE is 'Код роли лицевого счета для сделки'
/
comment on column fct_halfcarry.ACCOUNT_CODE is 'Код лицевого счета'
/
comment on column fct_halfcarry.REC_STATUS is 'REC_STATUS'
/
comment on table  fct_halfcarry is 'Полупроводка'
/

ALTER TABLE fct_halfcarry
ADD CONSTRAINT pk_fct_halfcarry PRIMARY KEY(CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_fct_halfcarry_unl
    on fct_halfcarry( rec_unload)
    TABLESPACE MSFO_INDEX;

create index idx_fct_halfcarry_dt
    on fct_halfcarry( dt)
    TABLESPACE MSFO_INDEX;

ALTER TABLE fct_halfcarry
ADD CONSTRAINT fk_fct_halfcarry_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE fct_halfcarry
ADD CONSTRAINT fk_fct_halfcarry_roleaccount
 FOREIGN KEY(roleaccount_deal_code)
REFERENCES det_roleaccount_deal(code)
/

ALTER TABLE fct_halfcarry
ADD CONSTRAINT fk_fct_halfcarry_acccode
 FOREIGN KEY(account_code)
REFERENCES det_account(code)
/
