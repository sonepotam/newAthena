create table det_carry_cat 
(
 CARRY_CAT_CODE VARCHAR2 ( 100),
 CARRY_CAT_NAME VARCHAR2 ( 250),
 DT VARCHAR2 ( 10) NOT NULL,
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_carry_cat.CARRY_CAT_CODE is 'Код категории проводки'
/
comment on column det_carry_cat.CARRY_CAT_NAME is 'Наименование категории проводки'
/
comment on column det_carry_cat.DT is 'Дата открытия'
/
comment on column det_carry_cat.REC_STATUS is 'REC_STATUS'
/
comment on column det_carry_cat.ID_FILE is 'ID_FILE'
/
COMMENT ON TABLE det_carry_cat is 'Категория проводки'
/

ALTER TABLE det_carry_cat
ADD CONSTRAINT pk_det_carry_cat PRIMARY KEY(CARRY_CAT_CODE)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_det_carry_cat_unl
    on det_carry_cat( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_carry_cat
ADD CONSTRAINT fk_det_carry_cat_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

