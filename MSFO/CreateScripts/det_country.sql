create table det_country ( COUNTRY_NAME VARCHAR2 ( 250),
COUNTRY_CODE_NUM NUMBER(3),
PRIZN_RS VARCHAR2 ( 1),
DT VARCHAR2 ( 10),
REC_STATUS CHAR(1),
REC_UNLOAD NUMBER(1),
REC_PROCESS NUMBER(1),
ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_country.COUNTRY_NAME is 'Название страны'
/
comment on column det_country.COUNTRY_CODE_NUM is 'Код страны цифровой'
/
comment on column det_country.PRIZN_RS is 'Вхождение в группу развитых стран (0 - нет, 1 - да)'
/
comment on column det_country.DT is 'Дата открытия'
/
comment on column det_country.REC_STATUS is 'REC_STATUS'
/
comment on column det_country.ID_FILE is 'ID_FILE'
/
 COMMENT ON TABLE det_country is 'Страна'
/

ALTER TABLE det_country
ADD CONSTRAINT pk_det_country PRIMARY KEY(country_code_num)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_DET_COUNTRY_unl
    on DET_COUNTRY( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_country
ADD CONSTRAINT fk_det_country_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

alter table det_country 
modify
(COUNTRY_NAME NOT NULL,
DT NOT NULL,
REC_STATUS NOT NULL
)
;
