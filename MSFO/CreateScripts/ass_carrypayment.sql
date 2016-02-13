create table ass_carrypayment
(
 DT VARCHAR2 ( 10) NOT NULL,
 PAYMENT_CODE VARCHAR2(100) NOT NULL,
 CARRY_CODE VARCHAR2(100),
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/
comment on column ass_carrypayment.DT is 'Дата открытия';
comment on column ass_carrypayment.payment_code is 'Код перевода';
comment on column ass_carrypayment.carry_code is 'Код проводки';
COMMENT ON TABLE ass_carrypayment is 'Ассоциатор проводки с переводом';

ALTER TABLE ass_carrypayment
ADD CONSTRAINT pk_ass_carrypayment PRIMARY KEY(CARRY_CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_ass_carrypayment_unl
    on ass_carrypayment( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE ass_carrypayment
ADD CONSTRAINT fk_ass_carrypayment_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE ass_carrypayment
ADD CONSTRAINT fk_ass_carrypayment_paymcode
 FOREIGN KEY(payment_code)
REFERENCES fct_payment(code)
/

ALTER TABLE ass_carrypayment
ADD CONSTRAINT fk_ass_carrypayment_carrycode
 FOREIGN KEY(carry_code)
REFERENCES fct_carry(code)
/

create index idx_ass_carrypayment_paymcode
    on ass_carrypayment(payment_code)
    TABLESPACE MSFO_INDEX
/
