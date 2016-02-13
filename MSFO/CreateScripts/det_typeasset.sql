create table det_typeasset
(
 CODE VARCHAR2 (100),
 NAME VARCHAR2 ( 250) NOT NULL,
 DT VARCHAR2 ( 10) NOT NULL,
 REC_STATUS CHAR( 1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/
comment on column DET_TYPEASSET.CODE is 'Код типа основного средства'
/
comment on column DET_TYPEASSET.NAME is 'Название типа основного средства'
/
comment on column DET_TYPEASSET.DT is 'Дата открытия'
/
comment on column DET_TYPEASSET.REC_STATUS is 'REC_STATUS'
/
comment on table DET_TYPEASSET  is 'Тип идентификатора субъекта'
/

ALTER TABLE DET_TYPEASSET 
ADD CONSTRAINT pk_DET_TYPEASSET PRIMARY KEY(code)
USING INDEX TABLESPACE MSFO_DATA;

create bitmap index idx_DET_TYPEASSET_unl
    on DET_TYPEASSET ( rec_unload)
    TABLESPACE MSFO_DATA;

ALTER TABLE DET_TYPEASSET 
ADD CONSTRAINT fk_DET_TYPEASSET_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

