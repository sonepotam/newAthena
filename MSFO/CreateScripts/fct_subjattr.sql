create table fct_subjattr 
(
 ATTRVALUE VARCHAR2 ( 30) NOT NULL,
 DT VARCHAR2 ( 10) NOT NULL,
 SUBJECT_CODE VARCHAR2 (100),
 TYPEATTR_CODE VARCHAR2 (100),
 DEPARTMENT_CODE VARCHAR2(100) NOT NULL,
 SYSTEM_CODE VARCHAR2(100) NOT NULL,
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(16)
)
tablespace MSFO_DATA
/
comment on column fct_subjattr.ATTRVALUE is 'Значение идентификатора субъекта в учетной системе'
/
comment on column fct_subjattr.DT is 'Дата открытия'
/
comment on column fct_subjattr.SUBJECT_CODE is 'Уникальный код субъекта в учетной системе'
/
comment on column fct_subjattr.TYPEATTR_code is 'Код типа атрибута'
/
comment on column fct_subjattr.DEPARTMENT_CODE is 'Код подразделения субъекта'
/
comment on column fct_subjattr.SYSTEM_CODE is 'Код учетной системы субъекта'
/
comment on column fct_subjattr.REC_STATUS is 'REC_STATUS'
/
comment on table fct_subjattr is 'Идентификаторы субъектов'
/

ALTER TABLE fct_subjattr
ADD CONSTRAINT pk_fct_subjattr 
PRIMARY KEY(subject_code, typeattr_code)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_fct_subjattr_unl
    on fct_subjattr( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE fct_subjattr
ADD CONSTRAINT fk_fct_subjattr_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE fct_subjattr
ADD CONSTRAINT fk_fct_subjattr_subjcode
FOREIGN KEY(subject_code)
REFERENCES det_subject(code_subject)
/

ALTER TABLE fct_subjattr
ADD CONSTRAINT fk_fct_subjattr_typeattrcode
FOREIGN KEY(typeattr_code)
REFERENCES det_typeattr(code)
/

ALTER TABLE fct_subjattr
ADD CONSTRAINT fk_fct_subjattr_depart
FOREIGN KEY(department_code)
REFERENCES det_department(code_department)
/

ALTER TABLE fct_subjattr
ADD CONSTRAINT fk_fct_subjattr_system
FOREIGN KEY(system_code)
REFERENCES det_system(system_code)
/
