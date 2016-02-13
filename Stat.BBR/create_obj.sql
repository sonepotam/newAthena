---
--- � ������� ��������� ���������� � ����� ���������� ������
--- �������������� ������ insert'�. Delete, Update �� ��������������
---
CREATE TABLE fei_repusage
    (reportproc                     VARCHAR2(254),
    userid                         VARCHAR2(254),
    userdate                       DATE,
    workplace                      NUMBER(10,0));

CREATE PUBLIC SYNONYM fei_repusage FOR od.fei_repusage;
  
GRANT all ON fei_repusage TO public;
  
CREATE INDEX ix_fei_repusage_proc ON fei_repusage(
    reportproc                      ASC);

