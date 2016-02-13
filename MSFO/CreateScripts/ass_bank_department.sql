create table ass_bank_department 
(
 DT VARCHAR2 ( 10) NOT NULL,
 PARENT_CODE_DEPARTMENT VARCHAR2 (100),
 CHILD_CODE_DEPARTMENT VARCHAR2 (100),
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(16)
)
tablespace MSFO_NSI
/
comment on column ass_bank_department.DT is 'Дата открытия'
/
comment on column ass_bank_department.PARENT_CODE_DEPARTMENT is 'Код подразделения'
/
comment on column ass_bank_department.CHILD_CODE_DEPARTMENT is 'Код подразделения'
/
comment on column ass_bank_department.REC_STATUS is 'REC_STATUS'
/
comment on column ass_bank_department.ID_FILE is 'ID_FILE'
/
 COMMENT ON TABLE ass_bank_department is 'Ассоциация между подразделениями'
/

ALTER TABLE ass_bank_department
ADD CONSTRAINT pk_ass_bank_department PRIMARY KEY(PARENT_CODE_DEPARTMENT, CHILD_CODE_DEPARTMENT)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_ass_bank_department_unl
    on ass_bank_department( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE ass_bank_department
ADD CONSTRAINT fk_ass_bank_department_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE ass_bank_department
ADD CONSTRAINT fk_ass_bank_department_parent
 FOREIGN KEY(parent_code_department)
REFERENCES det_department(code_department)
/

ALTER TABLE ass_bank_department
ADD CONSTRAINT fk_ass_bank_department_child
 FOREIGN KEY(child_code_department)
REFERENCES det_department(code_department)
/

