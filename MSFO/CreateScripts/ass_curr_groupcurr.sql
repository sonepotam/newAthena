create table ass_curr_groupcurr ( DT VARCHAR2 ( 10),
CODE_CURRENCYGROUP VARCHAR2 ( 30),
CURR_CODE_TXT_CURRENCY VARCHAR2 ( 3),
REC_STATUS VARCHAR2 ( 1),
ID_FILE NUMBER ( 16))
tablespace MSFO_NSI
/
comment on column ass_curr_groupcurr.DT is '���� ��������'
/
comment on column ass_curr_groupcurr.CODE_CURRENCYGROUP is '��� ������ �����'
/
comment on column ass_curr_groupcurr.CURR_CODE_TXT_CURRENCY is '��� ������ ISO'
/
comment on column ass_curr_groupcurr.REC_STATUS is 'REC_STATUS'
/
comment on column ass_curr_groupcurr.ID_FILE is 'ID_FILE'
/
 COMMENT ON TABLE ass_curr_groupcurr is '���������� ����� � ������� �����'
/


EXIT