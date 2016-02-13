create table ass_subject_cat 
(
 DT VARCHAR2 ( 10) NOT NULL,
 SUBJECT_CODE VARCHAR2(100),
 SUBJECT_CAT_VAL_CODE VARCHAR2 ( 100) NOT NULL,
 SUBJECT_CAT_VAL_SUBJECT_CAT_CO VARCHAR2 ( 30),
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(16)
)
tablespace MSFO_DATA
/
comment on column ass_subject_cat.DT is 'Дата открытия'
/
comment on column ass_subject_cat.SUBJECT_CODE is 'Уникальный код субъекта в учетной системе'
/
comment on column ass_subject_cat.SUBJECT_CAT_VAL_CODE is 'Код значения категории субъекта'
/
comment on column ass_subject_cat.SUBJECT_CAT_VAL_SUBJECT_CAT_CO is 'Код категории субъекта'
/
comment on column ass_subject_cat.REC_STATUS is 'REC_STATUS'
/
COMMENT ON TABLE ass_subject_cat is 'Ассоциатор субъекта с категорией'
/

ALTER TABLE ass_subject_cat
ADD CONSTRAINT pk_ass_subject_cat PRIMARY KEY(SUBJECT_CODE, SUBJECT_CAT_VAL_SUBJECT_CAT_CO)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_ass_subject_cat_unl
    on ass_subject_cat( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE ass_subject_cat
ADD CONSTRAINT fk_ass_subject_cat_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE ass_subject_cat
ADD CONSTRAINT fk_ass_subject_cat_subjcode
FOREIGN KEY(subject_code)
REFERENCES det_subject(code_subject)
/

ALTER TABLE ass_subject_cat
ADD CONSTRAINT fk_ass_subj_cat_catval
FOREIGN KEY(SUBJECT_CAT_VAL_SUBJECT_CAT_CO, SUBJECT_CAT_VAL_CODE)
REFERENCES det_subject_cat_val(subject_cat_code, subject_cat_val_code)
/
