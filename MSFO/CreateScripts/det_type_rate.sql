create table det_type_rate ( TYPE_RATE_CODE VARCHAR2 ( 30),
TYPE_RATE_NAME VARCHAR2 ( 250),
DT VARCHAR2 ( 10),
REC_STATUS VARCHAR2 ( 1))
tablespace MSFO_NSI
/
comment on column det_type_rate.TYPE_RATE_CODE is '��� ���� �����'
/
comment on column det_type_rate.TYPE_RATE_NAME is '�������� ���� �����'
/
comment on column det_type_rate.DT is '���� ��������'
/
comment on column det_type_rate.REC_STATUS is 'REC_STATUS'
/
 COMMENT ON TABLE det_type_rate is '��� ����� ��������������'
/


EXIT