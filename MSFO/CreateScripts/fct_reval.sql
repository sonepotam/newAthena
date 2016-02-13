create table fct_reval
(
 CODE VARCHAR2 (100),
 DT VARCHAR2 ( 10) NOT NULL,
 REVAL_SUM NUMBER(24,3) NOT NULL,
 HALFCARRY_CODE VARCHAR2(100) NOT NULL,
 ACCOUNT_CODE VARCHAR2(100) NOT NULL,
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/
comment on column fct_reval.CODE is 'Код переоценки'
/
comment on column fct_reval.DT is 'Дата открытия'
/
comment on column fct_reval.REVAL_SUM is 'Сумма переоценки'
/
comment on column fct_reval.HALFCARRY_CODE is 'Код полупроводки'
/
comment on column fct_reval.ACCOUNT_CODE is 'Код лицевого счета'
/
comment on table fct_reval is 'Переоценка'
/

ALTER TABLE fct_reval
ADD CONSTRAINT pk_fct_reval PRIMARY KEY(DT,HALFCARRY_CODE,ACCOUNT_CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_fct_reval_unl
    on fct_reval( rec_unload)
    TABLESPACE MSFO_INDEX;

create unique index idx_fct_reval_code
    on fct_reval( code)
    TABLESPACE MSFO_INDEX;

create index idx_fct_reval_dt
    on fct_reval( dt)
    TABLESPACE MSFO_INDEX;

ALTER TABLE fct_reval
ADD CONSTRAINT fk_fct_reval_halfcarry
 FOREIGN KEY(halfcarry_code)
REFERENCES fct_halfcarry(code)
/

ALTER TABLE fct_reval
ADD CONSTRAINT fk_fct_reval_account_code
 FOREIGN KEY(account_code)
REFERENCES det_account(code)
/

ALTER TABLE fct_reval
ADD CONSTRAINT fk_fct_reval_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(id_file)
/

create index idx_fct_reval_halfcarry_code
    on fct_reval(halfcarry_code)
    TABLESPACE MSFO_INDEX
/


