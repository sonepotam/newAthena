create table det_carry_cat_val 
(
 CARRY_CAT_VAL_CODE VARCHAR2 ( 100),
 CARRY_CAT_VAL_NAME VARCHAR2 ( 250),
 DT VARCHAR2 ( 10) NOT NULL,
 CARRY_CAT_CODE VARCHAR2 ( 100),
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_carry_cat_val.CARRY_CAT_VAL_CODE is 'Код значения категории проводки'
/
comment on column det_carry_cat_val.CARRY_CAT_VAL_NAME is 'Наименование значения категории проводки'
/
comment on column det_carry_cat_val.DT is 'Дата открытия'
/
comment on column det_carry_cat_val.CARRY_CAT_CODE is 'Код категории проводки'
/
comment on column det_carry_cat_val.REC_STATUS is 'REC_STATUS'
/
comment on column det_carry_cat_val.ID_FILE is 'ID_FILE'
/
COMMENT ON TABLE det_carry_cat_val is 'Допустимое значение категории проводки'
/

ALTER TABLE det_carry_cat_val
ADD CONSTRAINT pk_det_carry_cat_val PRIMARY KEY(CARRY_CAT_CODE, CARRY_CAT_VAL_CODE)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_det_carry_cat_val_unl
    on det_carry_cat_val( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_carry_cat_val
ADD CONSTRAINT fk_det_carry_cat_val_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE det_carry_cat_val
ADD CONSTRAINT fk_det_carry_cat_val_carrycat
 FOREIGN KEY(carry_cat_code)
REFERENCES det_carry_cat(carry_cat_code)
/
