create table fct_asset
(
 CODE VARCHAR2(100) NOT NULL,
 INVNUMB VARCHAR2(250) NOT NULL,
 NAME VARCHAR2(250) NOT NULL,
 CORIND NUMBER(12,3) NOT NULL,
 AMCODE VARCHAR2(100),
 PAYDATE DATE NOT NULL,
 OPERDATE DATE NOT NULL,
 ENDDATE DATE,
 BALSUM NUMBER(24,3) NOT NULL,
 IS_REVALUE NUMBER(1) NOT NULL, 
 AMORDATE_YEAR NUMBER(10) NOT NULL, 
 AMORLEVEL_PROC NUMBER(7,4) NOT NULL,
 DT VARCHAR2(10) NOT NULL,
 CFA_CODE VARCHAR2(100) NOT NULL,
 TYPEASSET_CODE VARCHAR2(100) NOT NULL,
 REC_STATUS CHAR(1) NOT NULL,
 SYSMOMENT DATE,
 REC_UNLOAD NUMBER(1),
 REC_PROCESS NUMBER(1),
 ID_FILE NUMBER(16)
)
tablespace MSFO_DATA
/

comment on column fct_asset.CODE IS '��� ��������� ��������';
comment on column fct_asset.INVNUMB IS '����������� �����';
comment on column fct_asset.NAME IS '�������� ��������� ��������';
comment on column fct_asset.CORIND IS '����������� �����������';
comment on column fct_asset.AMCODE IS '��� ����� �����������';
comment on column fct_asset.PAYDATE IS '���� ������';
comment on column fct_asset.OPERDATE IS '���� ����� � �������������';
comment on column fct_asset.ENDDATE IS '���� ������� �� ������������';
comment on column fct_asset.BALSUM IS '���������� ���������';
comment on column fct_asset.IS_REVALUE IS '������� ����������';
comment on column fct_asset.AMORDATE_YEAR IS '���� ����������� � �����';
comment on column fct_asset.AMORLEVEL_PROC IS '������� ����������� � ���������';
comment on column fct_asset.DT IS '���� ��������';
comment on column fct_asset.CFA_CODE IS '��� ���';
comment on column fct_asset.TYPEASSET_CODE IS '��� ���� ��������� ��������';

comment on table fct_asset is '�������� ��������';

ALTER TABLE fct_asset
ADD CONSTRAINT pk_fct_asset 
PRIMARY KEY(code)
USING INDEX TABLESPACE MSFO_INDEX;

create bitmap index idx_fct_asset_unl
    on fct_asset( rec_unload)
    TABLESPACE MSFO_INDEX;

ALTER TABLE fct_asset
ADD CONSTRAINT fk_fct_asset_id_file
FOREIGN KEY(id_file)
REFERENCES bp_fct_files(ID_FILE)
/

ALTER TABLE fct_asset
ADD CONSTRAINT fk_fct_asset_typeasset
FOREIGN KEY(typeasset_code)
REFERENCES det_typeasset(code)
/

ALTER TABLE fct_asset
ADD CONSTRAINT fk_fct_asset_cfa
FOREIGN KEY(cfa_code)
REFERENCES det_cfa(code)
/
