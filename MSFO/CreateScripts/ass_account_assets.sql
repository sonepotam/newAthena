create table ass_account_assets 
( 
 DT VARCHAR2 ( 10) NOT NULL,
 ACCOUNT_CODE VARCHAR2(100),
 ASSETS_CODE VARCHAR2(100),
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/

comment on column ass_account_assets.DT is 'Дата открытия'
/
comment on column ass_account_assets.account_code is 'Код лицевого счета'
/
comment on column ass_account_assets.assets_code is 'Код основного средства'
/
COMMENT ON TABLE ass_account_assets is 'Ассоциатор лицевого счета и основного средства'
/

ALTER TABLE ass_account_assets
ADD CONSTRAINT pk_ass_account_assets PRIMARY KEY(ACCOUNT_CODE, ASSETS_CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_ass_account_assets_unl
    on ass_account_assets( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE ass_account_assets
ADD CONSTRAINT fk_ass_account_assets_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE ass_account_assets
ADD CONSTRAINT fk_ass_account_assets_acc_code
 FOREIGN KEY(account_code)
REFERENCES det_account(code)
/

ALTER TABLE ass_account_assets
ADD CONSTRAINT fk_ass_account_assets_asscode
 FOREIGN KEY(assets_code)
REFERENCES fct_assets(code)
/

