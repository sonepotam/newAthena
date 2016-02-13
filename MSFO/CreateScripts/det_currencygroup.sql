create table det_currencygroup ( CODE VARCHAR2 ( 30),
NAME VARCHAR2 ( 250),
DT VARCHAR2 ( 10),
REC_STATUS VARCHAR2 ( 1),
ID_FILE NUMBER ( 16))
tablespace MSFO_NSI
/
comment on column det_currencygroup.CODE is 'Код группы валют'
/
comment on column det_currencygroup.NAME is 'Наименование группы валют'
/
comment on column det_currencygroup.DT is 'Дата открытия'
/
comment on column det_currencygroup.REC_STATUS is 'REC_STATUS'
/
comment on column det_currencygroup.ID_FILE is 'ID_FILE'
/
 COMMENT ON TABLE det_currencygroup is 'Группа валют'
/


EXIT