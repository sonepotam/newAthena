create table bp_fct_files
(
 ID_FILE NUMBER(10),
 FILENAME VARCHAR2(254),
 UNLOAD_DATE DATE
)
tablespace MSFO_NSI
/
comment on column bp_fct_files.ID_FILE is 'Идентификатор файла'
/
comment on column bp_fct_files.FILENAME is 'Имя файла'
/
comment on column bp_fct_files.UNLOAD_DATE is 'Дата выгрузки'
/
COMMENT ON TABLE bp_fct_files is 'Протокол файловой выгрузки'
/

ALTER TABLE bp_fct_files
ADD CONSTRAINT pk_fct_files PRIMARY KEY(id_file)
USING INDEX TABLESPACE MSFO_NSI;
CREATE UNIQUE INDEX idx_bp_fct_files_filename_un
ON bp_fct_files(filename)
tablespace MSFO_NSI;

CREATE TRIGGER T_BP_FCT_FILES_CREATE
before insert ON BP_FCT_FILES
for each row
begin
 IF :new.id_file is null THEN
   select BP_SEQ_ID_FILE.NEXTVAL into :new.id_file from dual;
 END IF;
end;
/
