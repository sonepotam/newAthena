create table fct_finstr_rate ( DT VARCHAR2 ( 10),
FINSTR_RATE VARCHAR2 ( 20),
FINSTR_SCALE VARCHAR2 ( 20),
TYPE_RATE_CODE_TYPE_FINSTR_RAT VARCHAR2 ( 30),
FINSTR_CODE_FINSTR_DENIMINATOR VARCHAR2 ( 30),
FINSTR_CODE_FINSTR_NUMERATOR VARCHAR2 ( 30),
CODE_DEPARTMENT_DEPARTMENT VARCHAR2 ( 30),
REC_STATUS VARCHAR2 ( 1))
tablespace MSFO_NSI
/
comment on column fct_finstr_rate.DT is 'Дата начала действия курса'
/
comment on column fct_finstr_rate.FINSTR_RATE is 'Значение курса'
/
comment on column fct_finstr_rate.FINSTR_SCALE is 'Масштаб курса'
/
comment on column fct_finstr_rate.TYPE_RATE_CODE_TYPE_FINSTR_RAT is 'Код типа курса'
/
comment on column fct_finstr_rate.FINSTR_CODE_FINSTR_DENIMINATOR is 'Код фининструмента знаменателя'
/
comment on column fct_finstr_rate.FINSTR_CODE_FINSTR_NUMERATOR is 'Код фининструмента числителя'
/
comment on column fct_finstr_rate.CODE_DEPARTMENT_DEPARTMENT is 'Код подразделения'
/
comment on column fct_finstr_rate.REC_STATUS is 'REC_STATUS'
/
 COMMENT ON TABLE fct_finstr_rate is 'Курс фининструмента'
/


exit