create table ass_halfcarry_cat
(
 DT VARCHAR2 ( 10) NOT NULL,
 CARRY_CAT_VAL_CODE VARCHAR2(100) NOT NULL,
 CARRY_CAT_VAL_CARRY_CAT_CODE VARCHAR2 (100) NOT NULL,
 HALFCARRY_CODE VARCHAR2 (100),
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/
comment on column ass_halfcarry_cat.DT is 'Дата открытия'
/
comment on column ass_halfcarry_cat.CARRY_CAT_VAL_CODE is 'Код значения категории проводки'
/
comment on column ass_halfcarry_cat.CARRY_CAT_VAL_CARRY_CAT_CODE is 'Код категории проводки'
/
comment on column ass_halfcarry_cat.HALFCARRY_CODE is 'Код полупроводки'
/
comment on column ass_halfcarry_cat.REC_STATUS is 'REC_STATUS'
/
COMMENT ON TABLE ass_halfcarry_cat is 'Ассоциатор полупроводки со значением категории'
/

ALTER TABLE ass_halfcarry_cat
ADD CONSTRAINT pk_ass_halfcarry_cat PRIMARY KEY(HALFCARRY_CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_ass_halfcarry_cat_unl
    on ass_halfcarry_cat( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE ass_halfcarry_cat
ADD CONSTRAINT fk_ass_halfcarry_cat_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE ass_halfcarry_cat
ADD CONSTRAINT fk_ass_halfcarry_cat_catval
 FOREIGN KEY(carry_cat_val_carry_cat_code, carry_cat_val_code)
REFERENCES det_carry_cat_val(carry_cat_code, carry_cat_val_code)
/

ALTER TABLE ass_halfcarry_cat
ADD CONSTRAINT fk_ass_halfcarry_cat_carrycode
 FOREIGN KEY(halfcarry_code)
REFERENCES fct_halfcarry(code)
/
