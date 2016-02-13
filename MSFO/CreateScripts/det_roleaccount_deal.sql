create table det_roleaccount_deal
(
 CODE VARCHAR2 (100), 
 NAME VARCHAR2 (250),
 MSFOROLE NUMBER(2) not null,
 DT VARCHAR2 (10),
 REC_STATUS CHAR( 1),
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
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

ALTER TABLE det_roleaccount_deal
ADD CONSTRAINT pk_det_roleaccount_deal PRIMARY KEY(code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_det_roleaccount_deal_unl
    on det_roleaccount_deal( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_roleaccount_deal
ADD CONSTRAINT fk_det_roleacc_deal_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

alter table det_roleaccount_deal modify
(
NAME NOT NULL,
DT NOT NULL,
REC_STATUS NOT NULL
)
;
