create table det_system
(
 SYSTEM_NAME VARCHAR2 ( 250),
 SYSTEM_CODE VARCHAR2 (100),
 RANK NUMBER(3) NOT NULL,
 DT VARCHAR2 ( 10),
 REC_STATUS CHAR(1),
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_system.SYSTEM_NAME is 'Наименование учетной системы'
/
comment on column det_system.SYSTEM_CODE is 'Код учетной системы'
/
comment on column det_system.DT is 'Дата открытия'
/
comment on column det_system.REC_STATUS is 'REC_STATUS'
/
comment on column det_system.RANK is 'Приоритет учетной системы'
/
COMMENT ON TABLE det_system is 'Учетная система (Главная книга, различные бэк-офиса), из которой приходят данные о счета, клиента и т.д.'
/

ALTER TABLE det_system
ADD CONSTRAINT pk_det_system PRIMARY KEY(system_code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_DET_SYSTEM_unl
    on DET_SYSTEM( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_system
ADD CONSTRAINT fk_det_system_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

alter table det_system modify
(
 SYSTEM_NAME NOT NULL,
 DT NOT NULL,
 REC_STATUS NOT NULL
)
;
