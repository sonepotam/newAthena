create table det_juridic_person
( 
JURIDIC_PERSON_NAME_S VARCHAR2 (50),
JURIDIC_PERSON_NAME VARCHAR2(250),
DT VARCHAR2 ( 10),
SUBJECT_CODE VARCHAR2 (100),
OKVED_CODE VARCHAR2(100),
OKATO_CODE VARCHAR2 (100),
REC_STATUS CHAR( 1),
REC_UNLOAD NUMBER(1),
REC_PROCESS NUMBER(1),
ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/
comment on column det_juridic_person.JURIDIC_PERSON_NAME_S is 'Наименование юр лица короткое'
/
comment on column det_juridic_person.JURIDIC_PERSON_NAME is 'Наименование юр лица'
/
comment on column det_juridic_person.DT is 'Дата открытия'
/
comment on column det_juridic_person.SUBJECT_CODE is 'Уникальный код субъекта в учетной системе'
/
comment on column det_juridic_person.OKVED_CODE is 'Код ОКВЭД'
/
comment on column det_juridic_person.OKATO_CODE is 'Код ОКАТО'
/
comment on column det_juridic_person.REC_STATUS is 'REC_STATUS'
/
 COMMENT ON TABLE det_juridic_person is 'Юридическое лицо'
/

ALTER TABLE det_juridic_person
ADD CONSTRAINT pk_det_juridic_person 
PRIMARY KEY(SUBJECT_CODE)
USING INDEX TABLESPACE MSFO_INDEX
/
ALTER TABLE MSFO.DET_JURIDIC_PERSON
 ADD CONSTRAINT FK_DET_JURIDIC_PERSON_OKVED
 FOREIGN KEY (OKVED_CODE)
 REFERENCES MSFO.DET_OKVED (OKVED_CODE) ENABLE
 VALIDATE


create bitmap index idx_DET_JURIDIC_PERSON_unl
    on DET_JURIDIC_PERSON( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE det_juridic_person
ADD CONSTRAINT fk_det_juridic_person_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE det_juridic_person
ADD CONSTRAINT fk_det_juridic_person_subject
FOREIGN KEY(subject_code)
REFERENCES det_subject(code_subject)
/

alter table det_juridic_person modify
( 
DT NOT NULL,
OKVED_CODE NOT NULL,
OKATO_CODE NOT NULL,
REC_STATUS NOT NULL
)
/
ALTER TABLE det_juridic_person
ADD CONSTRAINT FK_DET_JURIDIC_PERSON_OKATO
FOREIGN KEY(okato_code)
REFERENCES det_okato(code)
/
ALTER TABLE det_juridic_person
ADD CONSTRAINT FK_DET_JURIDIC_PERSON_OKVED
FOREIGN KEY(okved_code)
REFERENCES det_okved(okved_code)
/