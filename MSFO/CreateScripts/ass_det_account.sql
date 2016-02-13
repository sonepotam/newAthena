create table ass_det_account 
( 
 DT VARCHAR2 ( 10) NOT NULL,
 ACC_ASS_KIND_CODE VARCHAR2 (100),
 ACCOUNT_PAR_code VARCHAR2 (100),
 account_chi_code VARCHAR2(100),
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(16)
)
tablespace MSFO_DATA
/

comment on column ass_det_account.DT is 'Дата открытия'
/
comment on column ass_det_account.ACC_ASS_KIND_CODE is 'Код отношения между лицевыми счетами'
/
comment on column ass_det_account.ACCOUNT_par_code is 'Код лицевого счета'
/
comment on column ass_det_account.ACCOUNT_chi_code is 'Код лицевого счета'
/
COMMENT ON TABLE ass_det_account is 'Ассоциатор между лицевыми счетами'
/

ALTER TABLE ass_det_account
ADD CONSTRAINT pk_ass_det_account 
PRIMARY KEY(acc_ass_kind_code, account_par_code, account_chi_code)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_ASS_DET_ACCOUNT_unl
    on ASS_DET_ACCOUNT( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE ass_det_account
ADD CONSTRAINT fk_ass_det_account_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/


ALTER TABLE ass_det_account
ADD CONSTRAINT fk_ass_det_account_kind
FOREIGN KEY(acc_ass_kind_code)
REFERENCES det_acc_ass_kind(acc_ass_kind_code)
/

ALTER TABLE ass_det_account
ADD CONSTRAINT fk_ass_det_account_accpar
FOREIGN KEY (account_par_code)
REFERENCES det_account(code)
/

ALTER TABLE ass_det_account
ADD CONSTRAINT fk_ass_det_account_accchi
FOREIGN KEY (account_chi_code)
REFERENCES det_account(code)
/

