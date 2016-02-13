create table ass_subject_subjgroup
(
 DT VARCHAR2 ( 10) NOT NULL,
 SUBJECTGROUP_CODE VARCHAR2(100) NOT NULL,
 SUBJECT_CODE VARCHAR2(100),
 REC_STATUS CHAR( 1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/
comment on column ass_subject_subjgroup.DT is 'Дата открытия'
/
comment on column ass_subject_subjgroup.SUBJECTGROUP_CODE is 'Код группы'
/
comment on column ass_subject_subjgroup.SUBJECT_CODE is 'Уникальный код субъекта в учетной системе'
/
comment on column ass_subject_subjgroup.REC_STATUS is 'REC_STATUS'
/
 COMMENT ON TABLE ass_subject_subjgroup is 'Ассоциатор субъектов с группой субъектов'
/

ALTER TABLE ass_subject_subjgroup
ADD CONSTRAINT pk_ass_subject_subjgroup PRIMARY KEY(SUBJECT_CODE)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_ass_subj_subjgroup_unl
    on ass_subject_subjgroup( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE ass_subject_subjgroup
ADD CONSTRAINT fk_ass_subj_subjgroup_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE ass_subject_subjgroup
ADD CONSTRAINT fk_ass_subj_subjgroup_sg_code
 FOREIGN KEY(subjectgroup_code)
REFERENCES det_subjectgroup(code)
/

ALTER TABLE ass_subject_subjgroup
ADD CONSTRAINT fk_ass_subj_subjgroup_subjcode
 FOREIGN KEY(subject_code)
REFERENCES det_subject(code_subject)
/
