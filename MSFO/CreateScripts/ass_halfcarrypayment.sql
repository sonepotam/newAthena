create table ass_halfcarrypayment
(
 DT VARCHAR2 ( 10) NOT NULL,
 PAYMENT_CODE VARCHAR2(100) NOT NULL,
 HALFCARRY_CODE VARCHAR2(100),
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/
comment on column ass_halfcarrypayment.DT is 'Дата открытия';
comment on column ass_halfcarrypayment.payment_code is 'Код перевода';
comment on column ass_halfcarrypayment.halfcarry_code is 'Код полупроводки';
COMMENT ON TABLE ass_halfcarrypayment is 'Ассоциатор полупроводки с переводом';

ALTER TABLE ass_halfcarrypayment
ADD CONSTRAINT pk_ass_halfcarrypayment PRIMARY KEY(HALFCARRY_CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_ass_hfcarrypaym_unl
    on ass_halfcarrypayment( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE ass_halfcarrypayment
ADD CONSTRAINT fk_ass_hfcarrypaym_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE ass_halfcarrypayment
ADD CONSTRAINT fk_ass_hfcarrypaym_paymcode
 FOREIGN KEY(payment_code)
REFERENCES fct_payment(code)
/

ALTER TABLE ass_halfcarrypayment
ADD CONSTRAINT fk_ass_hfcarrypaym_carrycode
 FOREIGN KEY(halfcarry_code)
REFERENCES fct_halfcarry(code)
/
