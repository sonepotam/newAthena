create table det_finstr ( FINSTR_CODE VARCHAR2 (100),
FINSTR_NAME VARCHAR2 ( 250),
FINSTR_NAME_S VARCHAR2 ( 30),
DT VARCHAR2 ( 10),
REC_STATUS CHAR( 1),
REC_UNLOAD NUMBER(1),
REC_PROCESS NUMBER(1),
ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_finstr.FINSTR_CODE is 'Код фининструмента'
/
comment on column det_finstr.FINSTR_NAME is 'Название фининструмента'
/
comment on column det_finstr.FINSTR_NAME_S is 'Название фининструмента короткое'
/
comment on column det_finstr.DT is 'Дата открытия'
/
comment on column det_finstr.REC_STATUS is 'REC_STATUS'
/
 COMMENT ON TABLE det_finstr is 'Финансовый инструмент'
/

ALTER TABLE det_finstr
ADD CONSTRAINT pk_det_finstr PRIMARY KEY(finstr_code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_DET_FINSTR_unl
    on DET_FINSTR( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_finstr
ADD CONSTRAINT fk_det_finstr_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

alter table det_finstr modify
(
 FINSTR_NAME NOT NULL,
 FINSTR_NAME_S NOT NULL,
 DT NOT NULL,
 REC_STATUS NOT NULL
)
;
