create table det_currency ( CURR_CODE_TXT CHAR( 3),
CURR_CODE_NUM VARCHAR2 ( 3),
CURR_CODE_ACCOUNT VARCHAR2 ( 3),
CURR_CONVERT VARCHAR2 ( 1),
DT VARCHAR2 ( 10),
FINSTR_CODE_FINSTR VARCHAR2 (100),
REC_STATUS CHAR( 1),
REC_UNLOAD NUMBER(1),
REC_PROCESS NUMBER(1),
ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_currency.CURR_CODE_TXT is 'Код валюты ISO'
/
comment on column det_currency.CURR_CODE_NUM is 'Код валюты цифровой'
/
comment on column det_currency.CURR_CODE_ACCOUNT is 'Код валюты в номерах счетов'
/
comment on column det_currency.CURR_CONVERT is 'Конвертируемость (1 - СКВ, 0 - не СКВ)'
/
comment on column det_currency.DT is 'Дата открытия'
/
comment on column det_currency.FINSTR_CODE_FINSTR is 'Код фининструмента'
/
comment on column det_currency.REC_STATUS is 'REC_STATUS'
/
comment on column det_currency.ID_FILE is 'ID_FILE'
/
 COMMENT ON TABLE det_currency is 'Валюты и драгметаллы'
/

ALTER TABLE det_currency
ADD CONSTRAINT pk_det_currency PRIMARY KEY(curr_code_txt)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_DET_CURRENCY_unl
    on DET_CURRENCY( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_currency
ADD CONSTRAINT fk_det_currency_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

alter table det_currency modify
(
CURR_CODE_NUM NOT NULL,
CURR_CODE_ACCOUNT NOT NULL,
CURR_CONVERT NOT NULL,
DT NOT NULL,
FINSTR_CODE_FINSTR NOT NULL,
REC_STATUS NOT NULL
)
;

ALTER TABLE MSFO.DET_CURRENCY
  MODIFY (CURR_CODE_NUM   NULL)
  MODIFY (CURR_CODE_ACCOUNT   NULL)
  MODIFY (CURR_CONVERT   NULL);

