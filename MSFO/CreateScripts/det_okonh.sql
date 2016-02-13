create table det_okonh ( OKONH_CODE VARCHAR2 ( 30),
OKONH_NAME VARCHAR2 ( 250),
DT VARCHAR2 ( 10),
REC_STATUS VARCHAR2 ( 1))
tablespace MSFO_NSI
/
comment on column det_okonh.OKONH_CODE is 'Код ОКОНХ'
/
comment on column det_okonh.OKONH_NAME is 'Название ОКОНХ'
/
comment on column det_okonh.DT is 'Дата открытия'
/
comment on column det_okonh.REC_STATUS is 'REC_STATUS'
/
 COMMENT ON TABLE det_okonh is 'Справочник ОКОНХ'
/


EXIT