create table det_roleaccount_deal ( CODE VARCHAR2 ( 30),
NAME VARCHAR2 ( 250),
DT VARCHAR2 ( 10),
REC_STATUS varchar2( 1))
tablespace MSFO_NSI
/
comment on column det_roleaccount_deal.CODE is 'Код  роли лицевого счета для сделки'
/
comment on column det_roleaccount_deal.NAME is 'Название  роли лицевого счета для сделки'
/
comment on column det_roleaccount_deal.DT is 'Дата открытия'
/
comment on column det_roleaccount_deal.REC_STATUS is 'REC_STATUS'
/
 COMMENT ON TABLE det_roleaccount_deal is 'Роли лицевых счетов для сделок'
/


EXIT