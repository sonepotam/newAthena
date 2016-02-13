create table det_okved ( 
OKVED_CODE VARCHAR2(100),
OKVED_NAME VARCHAR2(250),
DT VARCHAR2 ( 10),
REC_STATUS VARCHAR2 ( 1),
sysmoment DATE
)
tablespace MSFO_NSI
/
comment on column det_okved.OKVED_CODE is 'Код ОКВЭД'
/
comment on column det_okved.OKVED_NAME is 'Название ОКВЭД'
/
comment on column det_okved.DT is 'Дата открытия'
/
comment on column det_okved.REC_STATUS is 'REC_STATUS'
/
 COMMENT ON TABLE det_okved is 'Справочник ОКВЭД'
/

ALTER TABLE det_okved
ADD CONSTRAINT pk_det_okved PRIMARY KEY(okved_code)
USING INDEX TABLESPACE MSFO_NSI
/

EXIT