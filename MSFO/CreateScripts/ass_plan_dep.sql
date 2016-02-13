create table ass_plan_dep
(
 DT VARCHAR2 ( 10) NOT NULL,
 DEPARTMENT_CODE VARCHAR2(100) NOT NULL,
 PLAN_BAL_CODE VARCHAR2(100) NOT NULL ,
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10),
 SYSMOMENT DATE NOT NULL
)
tablespace MSFO_DATA
/
comment on column ass_plan_dep.DT is 'Дата открытия';
comment on column ass_plan_dep.DEPARTMENT_CODE is 'Код подразделения';
comment on column ass_plan_dep.PLAN_BAL_CODE is 'Код плана счетов';

ALTER TABLE ass_plan_dep
ADD CONSTRAINT pk_ass_plan_dep PRIMARY KEY(DEPARTMENT_CODE)
USING INDEX TABLESPACE MSFO_INDEX;


ALTER TABLE ass_plan_dep
ADD CONSTRAINT fk_ass_plan_dep_depcode
 FOREIGN KEY(DEPARTMENT_CODE)
REFERENCES det_department(code_department)
/

ALTER TABLE ass_plan_dep
ADD CONSTRAINT fk_ass_plan_dep
 FOREIGN KEY(PLAN_BAL_CODE)
REFERENCES det_plan_bal(plan_bal_code)
/


