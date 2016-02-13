create table fct_assets
(
 CODE VARCHAR2(100),
 NAME VARCHAR2(250),
 IS_COMPLETE NUMBER(1) NOT NULL,
 PAYDATE DATE,
 OPERDATE DATE NOT NULL,
 ENDDATE DATE,
 PAYSUM NUMBER(24,3),
 BALSUM NUMBER(24,3),
 IS_REVALUE NUMBER(1) NOT NULL, 
 AMORDATE_YEAR NUMBER(3), 
 AMORLEVEL_PROC NUMBER(6,4),
 DT VARCHAR2(10) NOT NULL,
 TYPEASSETS_CODE VARCHAR2(100),
 PAYCURRENCY_CURR_CODE_TXT CHAR(3),
 CFA_CODE VARCHAR2(100),
 REC_STATUS CHAR(1) NOT NULL,
 ACCOUNT VARCHAR2(20),
 REST VARCHAR2 ( 16),
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(16)
)
tablespace MSFO_DATA
/

comment on column fct_assets.CODE IS 'Код основного средства';
comment on column fct_assets.NAME IS 'Название основного средства';
comment on column fct_assets.IS_COMPLETE IS 'Состояние (для зданий и сооружений: 1- завершено; 0 - не завершено';
comment on column fct_assets.PAYDATE IS 'Дата оплаты';
comment on column fct_assets.OPERDATE IS 'дата ввода в эксплукатацию';
comment on column fct_assets.ENDDATE IS 'Дата выбытия из эксплуатации';
comment on column fct_assets.PAYSUM IS 'Сумма покупки';
comment on column fct_assets.BALSUM IS 'Балансовая стоимость';
comment on column fct_assets.IS_REVALUE IS 'Признак переоценки';
comment on column fct_assets.AMORDATE_YEAR IS 'Срок амортизации в годах';
comment on column fct_assets.AMORLEVEL_PROC IS 'Уровень амортизации в процентах';
comment on column fct_assets.DT IS 'Дата открытия';
comment on column fct_assets.TYPEASSETS_CODE IS 'Код типа основного средства';
comment on column fct_assets.PAYCURRENCY_CURR_CODE_TXT IS 'Код валюты ISO';
comment on column fct_assets.CFA_CODE IS 'Код ЦФУ';
comment on table fct_assets is 'Основные средства';

ALTER TABLE fct_assets
ADD CONSTRAINT pk_fct_assets 
PRIMARY KEY(code)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_fct_assets_unl
    on fct_assets( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE fct_assets
ADD CONSTRAINT fk_fct_assets_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE fct_assets
ADD CONSTRAINT fk_fct_assets_typeassets
FOREIGN KEY(typeassets_code)
REFERENCES det_typeassets(code)
/

ALTER TABLE fct_assets
ADD CONSTRAINT fk_fct_assets_paycurrency
FOREIGN KEY(PAYCURRENCY_CURR_CODE_TXT)
REFERENCES det_currency(curr_code_txt)
/

ALTER TABLE fct_assets
ADD CONSTRAINT fk_fct_assets_cfa
FOREIGN KEY(cfa_code)
REFERENCES det_cfa(code)
/
