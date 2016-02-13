create table det_typeassets 
(
 CODE VARCHAR2 (100),
 NAME VARCHAR2 ( 250) NOT NULL,
 DT VARCHAR2 ( 10) NOT NULL,
 REC_STATUS CHAR( 1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_typeassets.CODE is 'Код типа основного средства'
/
comment on column det_typeassets.NAME is 'Название типа основного средства'
/
comment on column det_typeassets.DT is 'Дата открытия'
/
comment on column det_typeassets.REC_STATUS is 'REC_STATUS'
/
comment on table det_typeassets is 'Тип идентификатора субъекта'
/

ALTER TABLE det_typeassets
ADD CONSTRAINT pk_det_typeassets PRIMARY KEY(code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_det_typeassets_unl
    on det_typeassets( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_typeassets
ADD CONSTRAINT fk_det_typeassets_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

