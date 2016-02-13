create table ass_account_asset
( 
 TYPEACC NUMBER(1) NOT NULL,
 DT VARCHAR2 ( 10) NOT NULL,
 ACCOUNT_CODE VARCHAR2(50) NOT NULL,
 ASSET_CODE VARCHAR2(100) NOT NULL,
 REC_STATUS CHAR(1) NOT NULL,
 SYSMOMENT DATE,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/
comment on column ass_account_asset.TYPEACC is 'Роль счета ОС'
/

comment on column ass_account_asset.DT is 'Дата открытия'
/
comment on column ass_account_asset.account_code is 'Код лицевого счета'
/
comment on column ass_account_asset.asset_code is 'Код основного средства'
/
COMMENT ON TABLE ass_account_asset is 'Ассоциатор лицевого счета и основного средства'
/

ALTER TABLE ass_account_asset
ADD CONSTRAINT pk_ass_account_asset PRIMARY KEY(ACCOUNT_CODE, ASSET_CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_ass_account_asset_unl
    on ass_account_asset( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE ass_account_asset
ADD CONSTRAINT fk_ass_account_asset_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE ass_account_asset
ADD CONSTRAINT fk_ass_account_asset_acc_code
 FOREIGN KEY(account_code)
REFERENCES det_account(code)
/

ALTER TABLE ass_account_asset
ADD CONSTRAINT fk_ass_account_asset_asscode
 FOREIGN KEY(asset_code)
REFERENCES fct_asset(code)
/

