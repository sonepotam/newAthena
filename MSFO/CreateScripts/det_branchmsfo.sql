create table det_branchmsfo 
(
 CODE VARCHAR2 ( 30),
 NAME VARCHAR2 ( 250),
 DT VARCHAR2 ( 10),
 REC_STATUS CHAR( 1),
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10),
 RESERVRATE NUMBER(12,4)
)
tablespace MSFO_NSI
/
comment on column det_branchmsfo.CODE is 'Код отрасли'
/
comment on column det_branchmsfo.NAME is 'Название отрасли'
/
comment on column det_branchmsfo.DT is 'Дата открытия'
/
comment on column det_branchmsfo.REC_STATUS is 'REC_STATUS'
/
comment on table det_branchmsfo is 'Коды отраслей'
/

ALTER TABLE det_branchmsfo
ADD CONSTRAINT pk_det_branchmsfo PRIMARY KEY(code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_det_branchmsfo_unl
    on det_branchmsfo( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_branchmsfo
ADD CONSTRAINT fk_det_branchmsfo_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

alter table det_branchmsfo modify
(
 NAME NOT NULL,
 DT NOT NULL,
 REC_STATUS NOT NULL
)
;
