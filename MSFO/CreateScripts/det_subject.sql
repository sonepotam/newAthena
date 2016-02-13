create table det_subject 
(
 SUBJECT_INN VARCHAR2 ( 20),
 CODE_SUBJECT VARCHAR2 ( 30),
 ID_MDM VARCHAR2 ( 30),
 DT VARCHAR2 ( 10),
 SYSTEM_CODE VARCHAR2 ( 30),
 DEPARTMENT_CODE VARCHAR2 ( 30),
 COUNTRY_CODE_NUM NUMBER(3),
 CFA_CODE VARCHAR2 ( 30),
 BRANCHMSFO_CODE VARCHAR2(30),
 REC_STATUS CHAR(1),
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/
comment on column det_subject.SUBJECT_INN is 'ИНН'
/
comment on column det_subject.CODE_SUBJECT is 'Уникальный код субъекта в учетной системе'
/
comment on column det_subject.ID_MDM is 'ID МДМ'
/
comment on column det_subject.DT is 'Дата открытия'
/
comment on column det_subject.SYSTEM_CODE is 'Код учетной системы'
/
comment on column det_subject.DEPARTMENT_CODE is 'Код подразделения'
/
comment on column det_subject.COUNTRY_CODE_NUM is 'Код страны цифровой'
/
comment on column det_subject.CFA_CODE is 'Код ЦФУ'
/
comment on column det_subject.BRANCHMSFO_CODE IS 'Код отрасли'
/
COMMENT ON TABLE det_subject is 'Субъект экономической деятельности'
/

ALTER TABLE DET_SUBJECT
ADD CONSTRAINT pk_det_subject PRIMARY KEY(CODE_SUBJECT)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_DET_SUBJECT_unl
    on DET_SUBJECT( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE det_subject
ADD CONSTRAINT fk_det_subject_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE det_subject
ADD CONSTRAINT fk_det_subject_system_code
FOREIGN KEY(system_code)
REFERENCES det_system(system_code)
/

ALTER TABLE det_subject
ADD CONSTRAINT fk_det_subject_department_code
FOREIGN KEY(department_code)
REFERENCES det_department(code_department)
/

ALTER TABLE det_subject
ADD CONSTRAINT fk_det_subject_country
FOREIGN KEY(country_code_num)
REFERENCES det_country(country_code_num)
/

ALTER TABLE det_subject
ADD CONSTRAINT fk_det_subject_branchmsfo
FOREIGN KEY(branchmsfo_code)
REFERENCES det_branchmsfo(code)
/

alter table det_subject modify
(
 DT NOT NULL,
 SYSTEM_CODE NOT NULL,
 DEPARTMENT_CODE NOT NULL,
 COUNTRY_CODE_NUM NOT NULL,
 CFA_CODE NOT NULL,
 BRANCHMSFO_CODE NOT NULL,
 REC_STATUS NOT NULL
)
;

ALTER TABLE det_subject
ADD CONSTRAINT fk_det_subject_cfa
FOREIGN KEY(cfa_code)
REFERENCES det_cfa(code)
/

ALTER TABLE MSFO.DET_SUBJECT
  MODIFY (CODE_SUBJECT  VARCHAR2(100) )
  MODIFY (SYSTEM_CODE  VARCHAR2(100) )
  MODIFY (DEPARTMENT_CODE  VARCHAR2(100) )
  MODIFY (CFA_CODE  VARCHAR2(100) )
  MODIFY (BRANCHMSFO_CODE  VARCHAR2(100) );
