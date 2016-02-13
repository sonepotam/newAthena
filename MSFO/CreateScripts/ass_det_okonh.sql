create table ass_det_okonh ( DT VARCHAR2 ( 10),
OKONH_CODE_PARENT VARCHAR2 ( 30),
OKONH_CODE_CHILD VARCHAR2 ( 30),
REC_STATUS VARCHAR2 ( 1),
ID_FILE NUMBER ( 16))
tablespace MSFO_NSI
/
comment on column ass_det_okonh.DT is 'Дата открытия'
/
comment on column ass_det_okonh.OKONH_CODE_PARENT is 'Код ОКОНХ'
/
comment on column ass_det_okonh.OKONH_CODE_CHILD is 'Код ОКОНХ'
/
comment on column ass_det_okonh.REC_STATUS is 'REC_STATUS'
/
comment on column ass_det_okonh.ID_FILE is 'ID_FILE'
/
 COMMENT ON TABLE ass_det_okonh is 'Ассоциатор ОКОНХ'
/


EXIT