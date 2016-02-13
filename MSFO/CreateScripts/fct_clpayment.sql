create table fct_clpayment 
(
 PAYACCOUNT VARCHAR2(30),
 PAYNAME VARCHAR2(250), 
 PAYINN VARCHAR2(30),
 PAYKPP VARCHAR2(30),
 PAYSWIFT VARCHAR2(30),
 PAYCOUNTRY VARCHAR2(3),
 PAYADDRESS VARCHAR2(250),
 PAYBANKACCOUNT VARCHAR2(30),
 PAYBANKNAME VARCHAR2(250),
 PAYBANKBIC VARCHAR2(30), 
 PAYBANKSWIFT VARCHAR2(30),
 PAYBANKCOUNTRY VARCHAR2(3),
 RECACCOUNT VARCHAR2(30),
 RECNAME VARCHAR2(250),
 RECBANKACCOUNT VARCHAR2(30),
 RECBANKNAME VARCHAR2(250),
 RECBANKBIC VARCHAR2(30),
 RECBANKSWIFT VARCHAR2(30),
 RECBANKCOUNTRY VARCHAR2(3),
 PAYMENT_CODE VARCHAR2(100),
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/

comment on column fct_clpayment.PAYACCOUNT is 'Счет плательщика';
comment on column fct_clpayment.PAYNAME is 'Наименование плательщика';
comment on column fct_clpayment.PAYINN is 'ИНН плательщика';
comment on column fct_clpayment.PAYKPP is 'КПП плательщика';
comment on column fct_clpayment.PAYSWIFT is 'SWIFT плательщика';
comment on column fct_clpayment.PAYCOUNTRY is 'Код страны плательщика';
comment on column fct_clpayment.PAYADDRESS is 'Адрес плательщика';
comment on column fct_clpayment.PAYBANKACCOUNT is 'Счет банка плательщика';
comment on column fct_clpayment.PAYBANKNAME is 'Наименование банка плательщика';
comment on column fct_clpayment.PAYBANKBIC is 'БИК банка плательщика';
comment on column fct_clpayment.PAYBANKSWIFT is 'SWIFT банка плательщика';
comment on column fct_clpayment.PAYBANKCOUNTRY is 'Код странчы банка плательщика';
comment on column fct_clpayment.RECACCOUNT is 'Счет получателя';
comment on column fct_clpayment.RECNAME is 'Наименование получателя';
comment on column fct_clpayment.RECBANKACCOUNT is 'Счет банка получателя';
comment on column fct_clpayment.RECBANKNAME is 'Наименование банка получателя';
comment on column fct_clpayment.RECBANKBIC is 'БИК банка получателя';
comment on column fct_clpayment.RECBANKSWIFT is 'SWIFT банка получателя';
comment on column fct_clpayment.RECBANKCOUNTRY is 'Код страны банка получателя';
comment on column fct_clpayment.PAYMENT_CODE is 'Код перевода';
comment on table fct_clpayment is 'Безналичный перевод'
/

ALTER TABLE fct_clpayment
ADD CONSTRAINT pk_fct_clpayment PRIMARY KEY(PAYMENT_CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_fct_clpayment_unl
    on fct_clpayment( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE fct_clpayment
ADD CONSTRAINT fk_fct_clpayment_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE fct_clpayment
ADD CONSTRAINT fk_fct_clpayment_paycode
 FOREIGN KEY(payment_code)
REFERENCES fct_payment(code)
/

