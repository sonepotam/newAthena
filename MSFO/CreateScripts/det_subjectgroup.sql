create table det_subjectgroup 
(
 CODE VARCHAR2 (100),
 NAME VARCHAR2 (250),
 RISK CHAR( 1),
 DT VARCHAR2 ( 10) NOT NULL,
 TYPESUBJECTGROUP_CODE VARCHAR2 (100) NOT NULL,
 REC_STATUS CHAR( 1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10),
 RESERVERATE NUMBER(12,4)
)
tablespace MSFO_NSI
/
comment on column det_subjectgroup.CODE is 'Код группы'
/
comment on column det_subjectgroup.NAME is 'Название группы'
/
comment on column det_subjectgroup.RISK is 'Группа риска, присвоенная группе субъектов, например, группе связанных заемщиков.'
/
comment on column det_subjectgroup.DT is 'Дата открытия'
/
comment on column det_subjectgroup.TYPESUBJECTGROUP_CODE is 'Код типа группы клиентов'
/
comment on column det_subjectgroup.REC_STATUS is 'REC_STATUS'
/
comment on table det_subjectgroup is 'Группа субъектов экономической деятельности'
/

ALTER TABLE det_subjectgroup
ADD CONSTRAINT pk_det_subjectgroup PRIMARY KEY(CODE)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_det_subjectgroup_unl
    on det_subjectgroup( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE det_subjectgroup
ADD CONSTRAINT fk_det_subjectgroup_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/
