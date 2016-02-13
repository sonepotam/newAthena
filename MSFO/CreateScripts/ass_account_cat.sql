create table ass_account_cat 
( DT VARCHAR2 ( 10) NOT NULL,
  ACCOUNT_CODE VARCHAR2(100),
  ACCOUNT_CAT_VAL_CODE VARCHAR2(100) NOT NULL,
  ACCOUNT_CAT_VAL_ACCOUNT_CAT_CO VARCHAR2(30) NOT NULL,
  REC_STATUS CHAR(1) NOT NULL,
  REC_UNLOAD NUMBER(1),
  REC_PROCESS NUMBER(1),
  ID_FILE NUMBER(16)
)
tablespace MSFO_DATA

/
comment on column ass_account_cat.DT is 'Дата открытия'
/
comment on column ass_account_cat.ACCOUNT_CODE is 'Код лицевого счета'
/
comment on column ass_account_cat.ACCOUNT_CAT_VAL_CODE is 'Код значения категории лицевого счета'
/
comment on column ass_account_cat.ACCOUNT_CAT_VAL_ACCOUNT_CAT_CO is 'Код категории лицевого счета'
/
 COMMENT ON TABLE ass_account_cat is 'Ассоциатор лицевого счета с категорией'
/

ALTER TABLE ass_account_cat
ADD CONSTRAINT pk_ass_account_cat 
PRIMARY KEY(ACCOUNT_CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_ASS_ACCOUNT_CAT_unl
    on ASS_ACCOUNT_CAT( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE ass_account_cat
ADD CONSTRAINT fk_ass_account_cat_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/


ALTER TABLE ass_account_cat
ADD CONSTRAINT fk_ass_account_cat_acc_code
FOREIGN KEY(account_code)
REFERENCES det_account(code)
/

ALTER TABLE ass_account_cat
ADD CONSTRAINT fk_ass_account_cat_catval
FOREIGN KEY(ACCOUNT_CAT_VAL_ACCOUNT_CAT_CO, account_cat_val_code)
REFERENCES det_account_cat_val(account_cat_code, account_cat_val_code)
/
