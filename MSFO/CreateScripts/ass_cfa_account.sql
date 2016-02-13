create table ass_cfa_account
(
 DT VARCHAR2 ( 10) NOT NULL,
 CFA_CODE VARCHAR2 (100) NOT NULL,
 ACCOUNT_CODE VARCHAR2 (100),
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(16)
)
tablespace MSFO_DATA
/
comment on column ass_cfa_account.DT is 'Дата открытия'
/
comment on column ass_cfa_account.CFA_CODE is 'Код ЦФУ'
/
comment on column ass_cfa_account.ACCOUNT_CODE is 'Код счета'
/
COMMENT ON TABLE ass_cfa_account is 'Ассоциатор лицевых счетов с ЦФУ'
/

ALTER TABLE ass_cfa_account
ADD CONSTRAINT pk_ass_cfa_account PRIMARY KEY(ACCOUNT_CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_ass_cfa_account_unl
    on ass_cfa_account( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE ass_cfa_account
ADD CONSTRAINT fk_ass_cfa_account_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE ass_cfa_account
ADD CONSTRAINT fk_ass_cfa_account_acccode
 FOREIGN KEY(account_code)
REFERENCES det_account(code)
/

ALTER TABLE ass_cfa_account
ADD CONSTRAINT fk_ass_cfa_account_cfa
 FOREIGN KEY(cfa_code)
REFERENCES det_cfa(code)
/
