create table ass_asset
( 
 ASS_ROL NUMBER(2) NOT NULL,
 DT VARCHAR2 ( 10) NOT NULL,
 PARENT_CODE VARCHAR2(100) NOT NULL,
 CHILD_CODE VARCHAR2(100) NOT NULL,
 REC_STATUS CHAR(1) NOT NULL,
 SYSMOMENT DATE,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/
comment on column ass_asset.ASS_ROL is '1-входит в состав'
/

comment on column ass_asset.DT is 'Дата открытия'
/
comment on column ass_asset.PARENT_CODE is 'Код основного средства'
/
comment on column ass_asset.CHILD_CODE is 'Код основного средства'
/
COMMENT ON TABLE ass_asset is 'Ассоциатор основных средств'
/

ALTER TABLE ass_asset
ADD CONSTRAINT pk_ass_asset PRIMARY KEY(parent_code,child_code)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_ass_asset_unl
    on ass_asset( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE ass_asset
ADD CONSTRAINT fk_ass_asset_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE ass_asset
ADD CONSTRAINT fk_ass_asset_parent_code
 FOREIGN KEY(parent_code)
REFERENCES fct_asset(code)
/

ALTER TABLE ass_asset
ADD CONSTRAINT fk_ass_asset_child_code
 FOREIGN KEY(child_code)
REFERENCES fct_asset(code)
/

