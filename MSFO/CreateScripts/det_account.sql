create table det_account 
(
 IS_INCONSOLIDATE NUMBER(1) DEFAULT 0,
 DT_OPEN_ACC DATE,
 DT_CLOSE_ACC DATE,
 DT VARCHAR2 ( 10),
 SYSTEM_CODE VARCHAR2(100),
 SUBJECT_CODE VARCHAR2 (100),
 FINSTR_CODE VARCHAR2 (100),
 DEPARTMENT_CODE VARCHAR2(100),
 CURRENCY_CURR_CODE_TXT CHAR(3),
 CHAPTER_CODE CHAR(1),
 REC_STATUS CHAR( 1),
 CODE VARCHAR2(100),
 ACCOUNT_NUMBER VARCHAR2(30),
 ACCOUNT_NAME VARCHAR2(250),
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(10)
)
tablespace MSFO_DATA
/
comment on column det_account.IS_INCONSOLIDATE is 'Признак вхождения в консолидированный счет. 1 -входит, 0 - не входит'
/
comment on column det_account.DT_OPEN_ACC is 'Дата открытия счета'
/
comment on column det_account.DT_CLOSE_ACC is 'Дата закрытия счета'
/
comment on column det_account.DT is 'Дата открытия'
/
comment on column det_account.SYSTEM_CODE is 'Код учетной системы'
/
comment on column det_account.SUBJECT_CODE is 'Уникальный код субъекта в учетной системе'
/
comment on column det_account.FINSTR_CODE is 'Код фининструмента'
/
comment on column det_account.DEPARTMENT_CODE is 'Код подразделения'
/
comment on column det_account.CURRENCY_CURR_CODE_TXT is 'Код валюты ISO'
/
comment on column det_account.CHAPTER_CODE is 'Код главы'
/
comment on column det_account.CODE is 'Код лицевого счета'
/
comment on column det_account.ACCOUNT_NUMBER is 'Номер лицевого счета'
/
comment on column det_account.ACCOUNT_NAME is 'Наименование счета'
/
COMMENT ON TABLE det_account is 'Лицевой счет'
/

ALTER TABLE det_account
ADD CONSTRAINT pk_det_account PRIMARY KEY(CODE)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_DET_ACCOUNT_unl
    on DET_ACCOUNT( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE det_account
ADD CONSTRAINT fk_det_account_id_file
 FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE det_account
ADD CONSTRAINT fk_det_account_subject
FOREIGN KEY(subject_code)
REFERENCES det_subject(code_subject)
/

ALTER TABLE det_account
ADD CONSTRAINT fk_det_account_finstr
FOREIGN KEY(finstr_code)
REFERENCES det_finstr(finstr_code)
/

ALTER TABLE det_account
ADD CONSTRAINT fk_det_account_department_code
FOREIGN KEY(department_code)
REFERENCES det_department(code_department)
/

ALTER TABLE det_account
ADD CONSTRAINT fk_det_account_currency
FOREIGN KEY(currency_curr_code_txt)
REFERENCES det_currency(CURR_CODE_TXT)
/

ALTER TABLE det_account
ADD CONSTRAINT fk_det_account_chapter
FOREIGN KEY(chapter_code)
REFERENCES det_chapter(chapter_code)
/

ALTER TABLE det_account MODIFY
(
 IS_INCONSOLIDATE NOT NULL,
 DT_OPEN_ACC  NOT NULL,
 DT_CLOSE_ACC  NOT NULL,
 DT NOT NULL,
 SYSTEM_CODE NOT NULL,
 SUBJECT_CODE NOT NULL,
 FINSTR_CODE NOT NULL,
 DEPARTMENT_CODE NOT NULL,
 CURRENCY_CURR_CODE_TXT NOT NULL,
 CHAPTER_CODE NOT NULL,
 REC_STATUS NOT NULL
)
;

CREATE INDEX idx_det_account_account_number
ON det_account(account_number)
 TABLESPACE MSFO_INDEX;
