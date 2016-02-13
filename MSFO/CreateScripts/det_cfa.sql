create table det_cfa 
(
 CODE VARCHAR2 (100),
 HIERCODE VARCHAR2 (100),
 NAME VARCHAR2 ( 250),
 DT VARCHAR2 ( 10) NOT NULL,
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
 tablespace MSFO_NSI
/
comment on column det_cfa.CODE is 'Код ЦФУ'
/
comment on column det_cfa.HIERCODE is 'Иерархический код ЦФУ'
/
comment on column det_cfa.NAME is 'Наименование ЦФУ'
/
comment on column det_cfa.DT is 'Дата открытия'
/
comment on column det_cfa.REC_STATUS is 'REC_STATUS'
/
comment on column det_cfa.ID_FILE is 'ID_FILE'
/
COMMENT ON TABLE det_cfa is 'Справочник ЦФУ'
/

ALTER TABLE det_cfa
ADD CONSTRAINT pk_det_cfa PRIMARY KEY(code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_DET_cfa_unl
    on DET_cfa(rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_cfa
ADD CONSTRAINT fk_det_cfa_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

