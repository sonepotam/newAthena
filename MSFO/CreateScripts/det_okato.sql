create table det_okato 
(
 CODE VARCHAR2 (100),
 NAME VARCHAR2 (250),
 DT VARCHAR2 (10),
 REC_STATUS CHAR(1),
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_okato.CODE is 'Код ОКАТО'
/
comment on column det_okato.NAME is 'Наименование ОКАТО'
/
comment on column det_okato.DT is 'Дата открытия'
/
comment on column det_okato.REC_STATUS is 'REC_STATUS'
/
COMMENT ON TABLE det_okato is 'Классификатор ОКАТО'
/

ALTER TABLE det_okato
ADD CONSTRAINT pk_det_okato PRIMARY KEY(code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_DET_OKATO_unl
    on DET_OKATO( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_OKATO
ADD CONSTRAINT fk_det_okato_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

alter table det_okato
modify
(NAME NOT NULL,
DT NOT NULL,
REC_STATUS NOT NULL
)
;
