create table det_type_deal_rel 
(
 CODE VARCHAR2 (100),
 NAME VARCHAR2 ( 250),
 DT VARCHAR2 ( 10) NOT NULL,
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_type_deal_rel.CODE is 'Код типа отношений между сделками'
/
comment on column det_type_deal_rel.NAME is 'Название типа отношений между сделками'
/
comment on column det_type_deal_rel.DT is 'Дата открытия'
/
comment on column det_type_deal_rel.REC_STATUS is 'REC_STATUS'
/
COMMENT ON TABLE det_type_deal_rel is 'Типы отношений между сделками'
/

ALTER TABLE det_type_deal_rel
ADD CONSTRAINT pk_det_type_deal_rel PRIMARY KEY(code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_det_type_deal_rel_unl
    on det_type_deal_rel(rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_type_deal_rel
ADD CONSTRAINT fk_det_type_deal_rel_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

