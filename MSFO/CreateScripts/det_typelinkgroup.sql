create table det_typelinkgroup 
(
 CODE_SUBJECTLINK VARCHAR2 (100),
 NAMELINK VARCHAR2 ( 250),
 DT VARCHAR2 ( 10) NOT NULL,
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_typelinkgroup.CODE_SUBJECTLINK is 'Код типа группы клиентов'
/
comment on column det_typelinkgroup.NAMELINK is 'Название типа группы клиентов'
/
comment on column det_typelinkgroup.DT is 'Дата открытия'
/
comment on column det_typelinkgroup.REC_STATUS is 'REC_STATUS'
/
COMMENT ON TABLE det_typelinkgroup is 'Тип группы связанных субъектов'
/

ALTER TABLE det_typelinkgroup
ADD CONSTRAINT pk_det_typelinkgroup PRIMARY KEY(code_subjectlink)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_det_typelinkgroup_unl
    on det_typelinkgroup(rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_typelinkgroup
ADD CONSTRAINT fk_det_typelinkgroup_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

