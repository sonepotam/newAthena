create table det_subject_cat 
(
 SUBJECT_CAT_CODE VARCHAR2 ( 30),
 SUBJECT_CAT_NAME VARCHAR2 ( 250) NOT NULL,
 DT VARCHAR2 ( 10) NOT NULL,
 REC_STATUS CHAR( 1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_subject_cat.SUBJECT_CAT_CODE is 'Код категории субъекта'
/
comment on column det_subject_cat.SUBJECT_CAT_NAME is 'Наименование категории субъекта'
/
comment on column det_subject_cat.DT is 'Дата открытия'
/
comment on column det_subject_cat.REC_STATUS is 'REC_STATUS'
/
 COMMENT ON TABLE det_subject_cat is 'Категория субъекта'
/

ALTER TABLE det_subject_cat
ADD CONSTRAINT pk_det_subject_cat PRIMARY KEY(subject_cat_code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_det_subject_cat_unl
    on det_subject_cat( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_subject_cat
ADD CONSTRAINT fk_det_subject_cat_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE MSFO.DET_SUBJECT_CAT
  MODIFY (SUBJECT_CAT_CODE  VARCHAR2(100) )
  MODIFY (SUBJECT_CAT_NAME   NULL)
/