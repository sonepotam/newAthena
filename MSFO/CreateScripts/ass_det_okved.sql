create table ass_det_okved ( DT VARCHAR2 ( 10),
OKVED_CODE_PARENT VARCHAR2 ( 30),
OKVED_CODE_CHILD VARCHAR2 ( 30),
REC_STATUS VARCHAR2 ( 1),
ID_FILE NUMBER ( 16))
tablespace MSFO_NSI
/
comment on column ass_det_okved.DT is 'Дата открытия'
/
comment on column ass_det_okved.OKVED_CODE_PARENT is 'Код ОКВЭД'
/
comment on column ass_det_okved.OKVED_CODE_CHILD is 'Код ОКВЭД'
/
comment on column ass_det_okved.REC_STATUS is 'REC_STATUS'
/
comment on column ass_det_okved.ID_FILE is 'ID_FILE'
/
 COMMENT ON TABLE ass_det_okved is 'Ассоциатор ОКВЭД'
/


EXIT