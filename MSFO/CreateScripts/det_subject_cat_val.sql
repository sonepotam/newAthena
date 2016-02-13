create table det_subject_cat_val 
(
 SUBJECT_CAT_VAL_CODE VARCHAR2( 100),
 SUBJECT_CAT_VAL_NAME VARCHAR2( 250),
 DT VARCHAR2 (10) NOT NULL,
 SUBJECT_CAT_CODE VARCHAR2 ( 100),
 REC_STATUS CHAR( 1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
 tablespace MSFO_NSI
/
comment on column det_subject_cat_val.SUBJECT_CAT_VAL_CODE is 'Код значения категории субъекта'
/
comment on column det_subject_cat_val.SUBJECT_CAT_VAL_NAME is 'Наименование значения категории субъекта'
/
comment on column det_subject_cat_val.DT is 'Дата открытия'
/
comment on column det_subject_cat_val.SUBJECT_CAT_CODE is 'Код категории субъекта'
/
comment on column det_subject_cat_val.REC_STATUS is 'REC_STATUS'
/
 COMMENT ON TABLE det_subject_cat_val is 'Значение категории субъекта'
/

ALTER TABLE det_subject_cat_val
ADD CONSTRAINT pk_det_subject_cat_val PRIMARY KEY(SUBJECT_CAT_CODE, subject_cat_val_code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_det_subject_cat_val_unl
    on det_subject_cat_val( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_subject_cat_val
ADD CONSTRAINT fk_det_subject_cat_val_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE det_subject_cat_val
ADD CONSTRAINT fk_det_subject_cat_val_subcatc
FOREIGN KEY(subject_cat_code)
REFERENCES det_subject_cat(subject_cat_code)
/
