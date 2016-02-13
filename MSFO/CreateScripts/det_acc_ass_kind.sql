create table det_acc_ass_kind 
(
 ACC_ASS_KIND_CODE VARCHAR2 (100), 
 ACC_ASS_KIND_NAME VARCHAR2 ( 250),
 DT VARCHAR2 ( 10) NOT NULL,
 REC_STATUS CHAR(1) NOT NULL,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(16)
)
tablespace MSFO_NSI
/
comment on column det_acc_ass_kind.ACC_ASS_KIND_CODE is 'Код отношения между лицевыми счетами'
/
comment on column det_acc_ass_kind.ACC_ASS_KIND_NAME is 'Наименование отношения между лицевыми счетами'
/
comment on column det_acc_ass_kind.DT is 'Дата открытия'
/
comment on column det_acc_ass_kind.REC_STATUS is 'REC_STATUS'
/
comment on column det_acc_ass_kind.ID_FILE is 'ID_FILE'
/
COMMENT ON TABLE det_acc_ass_kind is 'Вид отношения между лицевыми счетами'
/

ALTER TABLE det_acc_ass_kind 
ADD CONSTRAINT pk_det_acc_ass_kind 
PRIMARY KEY(acc_ass_kind_code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_det_acc_ass_kind_unl
    on det_acc_ass_kind( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_acc_ass_kind
ADD CONSTRAINT fk_det_acc_ass_kind_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/
