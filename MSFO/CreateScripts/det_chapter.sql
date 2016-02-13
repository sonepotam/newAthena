create table det_chapter ( CHAPTER_CODE CHAR( 1),
CHAPTER_NAME VARCHAR2 ( 250),
DT VARCHAR2 ( 10),
REC_STATUS CHAR( 1),
REC_UNLOAD NUMBER(1),
REC_PROCESS NUMBER(1),
ID_FILE NUMBER(10)
)
tablespace MSFO_NSI
/
comment on column det_chapter.CHAPTER_CODE is 'Код главы'
/
comment on column det_chapter.CHAPTER_NAME is 'Название главы'
/
comment on column det_chapter.DT is 'Дата открытия'
/
comment on column det_chapter.REC_STATUS is 'REC_STATUS'
/
comment on column det_chapter.ID_FILE is 'ID_FILE'
/
 COMMENT ON TABLE det_chapter is 'Глава учета'
/
ALTER TABLE det_chapter
ADD CONSTRAINT pk_det_chapter PRIMARY KEY(chapter_code)
USING INDEX TABLESPACE MSFO_NSI;

create bitmap index idx_DET_CHAPTER_unl
    on DET_CHAPTER( rec_unload)
    TABLESPACE MSFO_NSI;

ALTER TABLE det_chapter
ADD CONSTRAINT fk_det_chapter_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

alter table det_chapter modify
(
DT NOT NULL,
REC_STATUS NOT NULL
)
;
