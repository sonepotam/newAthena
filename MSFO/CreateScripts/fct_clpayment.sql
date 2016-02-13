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

comment on column fct_clpayment.PAYACCOUNT is '���� �����������';
comment on column fct_clpayment.PAYNAME is '������������ �����������';
comment on column fct_clpayment.PAYINN is '��� �����������';
comment on column fct_clpayment.PAYKPP is '��� �����������';
comment on column fct_clpayment.PAYSWIFT is 'SWIFT �����������';
comment on column fct_clpayment.PAYCOUNTRY is '��� ������ �����������';
comment on column fct_clpayment.PAYADDRESS is '����� �����������';
comment on column fct_clpayment.PAYBANKACCOUNT is '���� ����� �����������';
comment on column fct_clpayment.PAYBANKNAME is '������������ ����� �����������';
comment on column fct_clpayment.PAYBANKBIC is '��� ����� �����������';
comment on column fct_clpayment.PAYBANKSWIFT is 'SWIFT ����� �����������';
comment on column fct_clpayment.PAYBANKCOUNTRY is '��� ������� ����� �����������';
comment on column fct_clpayment.RECACCOUNT is '���� ����������';
comment on column fct_clpayment.RECNAME is '������������ ����������';
comment on column fct_clpayment.RECBANKACCOUNT is '���� ����� ����������';
comment on column fct_clpayment.RECBANKNAME is '������������ ����� ����������';
comment on column fct_clpayment.RECBANKBIC is '��� ����� ����������';
comment on column fct_clpayment.RECBANKSWIFT is 'SWIFT ����� ����������';
comment on column fct_clpayment.RECBANKCOUNTRY is '��� ������ ����� ����������';
comment on column fct_clpayment.PAYMENT_CODE is '��� ��������';
comment on table fct_clpayment is '����������� �������'
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

