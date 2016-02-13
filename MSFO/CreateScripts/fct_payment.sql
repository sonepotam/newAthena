create table fct_payment 
(
 CODE VARCHAR2 (100),
 TYPEPAYMENT NUMBER(1) NOT NULL,
 PAYNUM VARCHAR2 (50),
 PAYSUM NUMBER(24,3) NOT NULL,
 PAYGROUND VARCHAR2 (250),
 DT VARCHAR2(10) NOT NULL,
 SUBJECT_CODE VARCHAR2 ( 100) NOT NULL,
 RECACCOUNT_CODE VARCHAR2 (100) NOT NULL,
 PAYACCOUNT_CODE VARCHAR2(100) NOT NULL,
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10),
 RECFINSTR_FINSTR_CODE VARCHAR2(100) NOT NULL,
 PAYFINSTR_FINSTR_CODE VARCHAR2(100) NOT NULL,
 DOCDATE DATE NOT NULL,
 RECDATE DATE NOT NULL,
 RECSUM NUMBER(24,3) NOT NULL,
 PAYDATE DATE NOT NULL
)
tablespace MSFO_DATA
/
comment on column fct_payment.CODE is 'Код перевода'
/
comment on column fct_payment.TYPEPAYMENT is 'Тип перевода'
/
comment on column fct_payment.PAYNUM is 'Номер документа'
/
comment on column fct_payment.PAYSUM is 'Сумма перевода'
/
comment on column fct_payment.PAYGROUND is 'Назначение платежа'
/
comment on column fct_payment.DT is 'Дата открытия'
/
comment on column fct_payment.SUBJECT_CODE is 'Уникальный код субъекта в учетной системе'
/
comment on column fct_payment.RECACCOUNT_CODE is 'Код лицевого счета получателя'
/
comment on column fct_payment.PAYACCOUNT_CODE is 'Код лицевого счета плательщика'
/
comment on column fct_payment.RECFINSTR_FINSTR_CODE is 'Код фининструмента'
/
comment on column fct_payment.PAYFINSTR_FINSTR_CODE is 'Код фининструмента'
/
comment on column fct_payment.DOCDATE is 'Дата документа'
/
comment on column fct_payment.RECDATE is 'Дата зачисления'
/
comment on column fct_payment.RECSUM is 'Сумма зачисления'
/
comment on column fct_payment.PAYDATE is 'Дата списания'
/
comment on table fct_payment is 'Перевод'
/

ALTER TABLE fct_payment
ADD CONSTRAINT pk_fct_payment PRIMARY KEY(CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_fct_payment_unl
    on fct_payment( rec_unload)
    TABLESPACE MSFO_INDEX;

create index idx_fct_payment_dt
    on fct_payment( dt)
    TABLESPACE MSFO_INDEX;

ALTER TABLE fct_payment
ADD CONSTRAINT fk_fct_payment_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE fct_payment
ADD CONSTRAINT fk_fct_payment_subject
 FOREIGN KEY(subject_code)
REFERENCES det_subject(code_subject)
/

ALTER TABLE fct_payment
ADD CONSTRAINT fk_fct_payment_recaccount
 FOREIGN KEY(recaccount_code)
REFERENCES det_account(code)
/

ALTER TABLE fct_payment
ADD CONSTRAINT fk_fct_payment_payaccount
 FOREIGN KEY(payaccount_code)
REFERENCES det_account(code)
/

ALTER TABLE fct_payment
ADD CONSTRAINT fk_fct_payment_payfinstr
 FOREIGN KEY(payfinstr_finstr_code)
REFERENCES det_finstr(finstr_code)
/

ALTER TABLE fct_payment
ADD CONSTRAINT fk_fct_payment_recfinstr
 FOREIGN KEY(recfinstr_finstr_code)
REFERENCES det_finstr(finstr_code)
/
