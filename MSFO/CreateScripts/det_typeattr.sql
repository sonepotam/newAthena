create table det_typeattr 
(
 CODE VARCHAR2 (100),
 NAME VARCHAR2 ( 250),
 DT VARCHAR2 ( 10),
 REC_STATUS CHAR( 1),
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_typeattr.CODE is 'Код типа атрибута'
/
comment on column det_typeattr.NAME is 'Название типа'
/
comment on column det_typeattr.DT is 'Дата открытия'
/
comment on column det_typeattr.REC_STATUS is 'REC_STATUS'
/
comment on table det_typeattr is 'Тип идентификатора субъекта'
/

ALTER TABLE det_typeattr
ADD CONSTRAINT pk_det_typeattr PRIMARY KEY(code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_det_typeattr_unl
    on det_typeattr( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_typeattr
ADD CONSTRAINT fk_det_typeattr_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

alter table det_typeattr modify
(
NAME NOT NULL,
DT NOT NULL,
REC_STATUS NOT NULL
)
;
