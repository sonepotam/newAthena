create table det_department 
( 
CODE_DEPARTMENT VARCHAR2 (100),
NAME_DEPARTMENT VARCHAR2 ( 250),
RANK NUMBER(3) not null,
DT VARCHAR2 ( 10),
CURR_CODE_TXT_CURRENCY CHAR( 3),
REC_STATUS CHAR(1),
REC_UNLOAD NUMBER(1),
REC_PROCESS NUMBER(1),
ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_department.CODE_DEPARTMENT is 'Код подразделения'
/
comment on column det_department.NAME_DEPARTMENT is 'Название подразделения'
/
comment on column det_department.DT is 'Дата открытия'
/
comment on column det_department.CURR_CODE_TXT_CURRENCY is 'Код валюты ISO'
/
comment on column det_department.REC_STATUS is 'REC_STATUS'
/
COMMENT ON TABLE det_department is 'Справочник подразделений'
/
create bitmap index idx_DET_DEPARTMENT_unl
    on DET_DEPARTMENT( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_department
ADD CONSTRAINT pk_det_department PRIMARY KEY(code_department)
USING INDEX TABLESPACE MSFO_NSI;

ALTER TABLE det_department
ADD CONSTRAINT fk_det_department_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE det_department
ADD CONSTRAINT fk_det_department_currency
 FOREIGN KEY(curr_code_txt_currency)
REFERENCES det_currency(curr_code_txt)
/

alter table det_department modify
( 
NAME_DEPARTMENT NOT NULL,
DT NOT NULL,
CURR_CODE_TXT_CURRENCY  NOT NULL,
REC_STATUS NOT NULL
)
;
