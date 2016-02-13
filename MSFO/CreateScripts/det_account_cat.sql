create table det_account_cat 
(
 ACCOUNT_CAT_CODE VARCHAR2 ( 100),
 ACCOUNT_CAT_NAME VARCHAR2 ( 250) NOT NULL,
 DT VARCHAR2 ( 10) NOT NULL,
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(16)
)
tablespace MSFO_NSI
/
comment on column det_account_cat.ACCOUNT_CAT_CODE is 'Код категории лицевого счета'
/
comment on column det_account_cat.ACCOUNT_CAT_NAME is 'Наименование категории лицевого счета'
/
comment on column det_account_cat.DT is 'Дата открытия'
/
comment on column det_account_cat.REC_STATUS is 'REC_STATUS'
/
comment on column det_account_cat.ID_FILE is 'ID_FILE'
/
COMMENT ON TABLE det_account_cat is 'Категория лицевого счета'
/

ALTER TABLE det_account_cat
ADD CONSTRAINT pk_det_account_cat PRIMARY KEY(account_cat_code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_det_account_cat_unl
    on det_account_cat( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_account_cat
ADD CONSTRAINT fk_det_account_cat_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/
