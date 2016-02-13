create table det_phyz_person
(
IS_INSIDER NUMBER(1),
PERSON_NAME VARCHAR2( 250),
DOCUMENT_KIND VARCHAR2 ( 250),
DOCUMENT_SER VARCHAR2 ( 20),
DOCUMENT_NUMB VARCHAR2 ( 20),
DOCUMENT_DATA_ISSUE VARCHAR2 ( 250),
DT VARCHAR2 (10),
SUBJECT_CODE VARCHAR2(100),
REC_STATUS CHAR( 1),
REC_UNLOAD NUMBER(1),
REC_PROCESS NUMBER(1),
ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/
comment on column det_phyz_person.IS_INSIDER is 'Признак инсайдера'
/
comment on column det_phyz_person.PERSON_NAME is 'ФИО'
/
comment on column det_phyz_person.DOCUMENT_KIND is 'Вид документа удостоверяющего личность'
/
comment on column det_phyz_person.DOCUMENT_SER is 'Серия документа'
/
comment on column det_phyz_person.DOCUMENT_NUMB is 'Номер документа'
/
comment on column det_phyz_person.DOCUMENT_DATA_ISSUE is 'Кем и когда выдан документ'
/
comment on column det_phyz_person.DT is 'Дата открытия'
/
comment on column det_phyz_person.SUBJECT_CODE is 'Уникальный код субъекта в учетной системе'
/
comment on column det_phyz_person.REC_STATUS is 'REC_STATUS'
/
 COMMENT ON TABLE det_phyz_person is 'Физическое лицо'
/

ALTER TABLE det_phyz_person
ADD CONSTRAINT pk_det_phyz_person 
PRIMARY KEY(SUBJECT_CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_det_phyz_person_unl
    on det_phyz_person( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE det_phyz_person
ADD CONSTRAINT fk_det_phyz_person_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE det_phyz_person
ADD CONSTRAINT fk_det_phyz_person_subject
FOREIGN KEY(subject_code)
REFERENCES det_subject(code_subject)
/

alter table det_phyz_person modify
(
IS_INSIDER NOT NULL,
DT NOT NULL,
REC_STATUS NOT NULL
)
;
