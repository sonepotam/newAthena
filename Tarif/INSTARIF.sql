-- ����� : ��� "Dictionary" , �������� "DocGen:�������� ������������"
-- �������� : "������ ��� ��������"
-- 
-- �������:
-- |     |             ���               |            ��������           |�����
-- |-----|-------------------------------|-------------------------------|-----
-- | 1   | AllFunction                   | ���������� �������            | 5
-- | 2   | AllFuncParameter              | ��������� �������             | 8
-- 
spool export.log
set serveroutput on
set echo off






Prompt !������ ��� ��������:AllFunction
declare
  ref_1    number;
  ref_2    number;
  ref_3    number;
  ref_4    number;
begin
  select Classified.NEXTVAL into ref_2 from DUAL;
ref_4 := NULL;

select CODE into ref_3 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_4) = 1 and CONSTTYPE = 5;

  begin
    select CLASSIFIED into ref_1 from ALLFUNCTION where  FUNCTIONNAME = 'TARIF_TOOLS.CHECKOBJTYPE' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_3) = 1;
    update ALLFUNCTION set LABEL = '����� � TypeTree(TARIF_TOOLS)',DESCRIPTION = NULL,DOCCATEGORY = NULL,SUBSYSTEM = NULL where  FUNCTIONNAME = 'TARIF_TOOLS.CHECKOBJTYPE' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_3) = 1;
  exception
    when No_Data_Found then
      insert into ALLFUNCTION(CLASSIFIED,LABEL,DESCRIPTION,FUNCTIONNAME,FUNCINTENTION,DOCCATEGORY,RETURNOBJTYPE,SUBSYSTEM) values(ref_2,'����� � TypeTree(TARIF_TOOLS)',NULL,'TARIF_TOOLS.CHECKOBJTYPE',1,NULL,ref_3,NULL);
  end;
end;
/
declare
  ref_1    number;
  ref_2    number;
  ref_3    number;
  ref_4    number;
begin
  select Classified.NEXTVAL into ref_2 from DUAL;
ref_4 := NULL;

select CODE into ref_3 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_4) = 1 and CONSTTYPE = 5;

  begin
    select CLASSIFIED into ref_1 from ALLFUNCTION where  FUNCTIONNAME = 'TARIF_TOOLS.CHECKACCOUNTTYPE' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_3) = 1;
    update ALLFUNCTION set LABEL = '�������� ���� �����',DESCRIPTION = '�������� ���� �����',DOCCATEGORY = NULL,SUBSYSTEM = NULL where  FUNCTIONNAME = 'TARIF_TOOLS.CHECKACCOUNTTYPE' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_3) = 1;
  exception
    when No_Data_Found then
      insert into ALLFUNCTION(CLASSIFIED,LABEL,DESCRIPTION,FUNCTIONNAME,FUNCINTENTION,DOCCATEGORY,RETURNOBJTYPE,SUBSYSTEM) values(ref_2,'�������� ���� �����','�������� ���� �����','TARIF_TOOLS.CHECKACCOUNTTYPE',1,NULL,ref_3,NULL);
  end;
end;
/
declare
  ref_1    number;
  ref_2    number;
  ref_3    number;
  ref_4    number;
begin
  select Classified.NEXTVAL into ref_2 from DUAL;
ref_4 := NULL;

select CODE into ref_3 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_4) = 1 and CONSTTYPE = 5;

  begin
    select CLASSIFIED into ref_1 from ALLFUNCTION where  FUNCTIONNAME = 'TARIF_TOOLS.CHECKTRANSFERMESSAGE' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_3) = 1;
    update ALLFUNCTION set LABEL = '����� � transfermessage',DESCRIPTION = NULL,DOCCATEGORY = NULL,SUBSYSTEM = 1 where  FUNCTIONNAME = 'TARIF_TOOLS.CHECKTRANSFERMESSAGE' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_3) = 1;
  exception
    when No_Data_Found then
      insert into ALLFUNCTION(CLASSIFIED,LABEL,DESCRIPTION,FUNCTIONNAME,FUNCINTENTION,DOCCATEGORY,RETURNOBJTYPE,SUBSYSTEM) values(ref_2,'����� � transfermessage',NULL,'TARIF_TOOLS.CHECKTRANSFERMESSAGE',1,NULL,ref_3,1);
  end;
end;
/
declare
  ref_1    number;
  ref_2    number;
  ref_3    number;
  ref_4    number;
begin
  select Classified.NEXTVAL into ref_2 from DUAL;
ref_4 := NULL;

select CODE into ref_3 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_4) = 1 and CONSTTYPE = 3;

  begin
    select CLASSIFIED into ref_1 from ALLFUNCTION where  FUNCTIONNAME = 'TARIF_TOOLS.REESTRINITDOC' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_3) = 1;
    update ALLFUNCTION set LABEL = '����� ���-�� ���������� � ����',DESCRIPTION = '����� ��������� ���������� � ���������',DOCCATEGORY = NULL,SUBSYSTEM = 1 where  FUNCTIONNAME = 'TARIF_TOOLS.REESTRINITDOC' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_3) = 1;
  exception
    when No_Data_Found then
      insert into ALLFUNCTION(CLASSIFIED,LABEL,DESCRIPTION,FUNCTIONNAME,FUNCINTENTION,DOCCATEGORY,RETURNOBJTYPE,SUBSYSTEM) values(ref_2,'����� ���-�� ���������� � ����','����� ��������� ���������� � ���������','TARIF_TOOLS.REESTRINITDOC',1,NULL,ref_3,1);
  end;
end;
/
declare
  ref_1    number;
  ref_2    number;
  ref_3    number;
  ref_4    number;
begin
  select Classified.NEXTVAL into ref_2 from DUAL;
ref_4 := NULL;

select CODE into ref_3 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_4) = 1 and CONSTTYPE = 5;

  begin
    select CLASSIFIED into ref_1 from ALLFUNCTION where  FUNCTIONNAME = 'TARIF_TOOLS.ISINERNALPAYMENT' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_3) = 1;
    update ALLFUNCTION set LABEL = '�������� ���������� ?',DESCRIPTION = NULL,DOCCATEGORY = NULL,SUBSYSTEM = 1 where  FUNCTIONNAME = 'TARIF_TOOLS.ISINERNALPAYMENT' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_3) = 1;
  exception
    when No_Data_Found then
      insert into ALLFUNCTION(CLASSIFIED,LABEL,DESCRIPTION,FUNCTIONNAME,FUNCINTENTION,DOCCATEGORY,RETURNOBJTYPE,SUBSYSTEM) values(ref_2,'�������� ���������� ?',NULL,'TARIF_TOOLS.ISINERNALPAYMENT',1,NULL,ref_3,1);
  end;
end;
/
Prompt !������ ��� ��������:AllFuncParameter
declare
  ref_1    number;
  ref_5    number;
  ref_6    number;
  ref_7    number;
  ref_8    number;
  ref_9    number;
  ref_10    number;
begin
  select Classified.NEXTVAL into ref_5 from DUAL;
ref_8 := NULL;

select CODE into ref_7 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_8) = 1 and CONSTTYPE = 5;


select CLASSIFIED into ref_6 from ALLFUNCTION where  FUNCTIONNAME = 'TARIF_TOOLS.CHECKOBJTYPE' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_7) = 1;

ref_10 := NULL;

select CODE into ref_9 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_10) = 1 and CONSTTYPE = 3;

  begin
    select CLASSIFIED into ref_1 from ALLFUNCPARAMETER where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 1;
    update ALLFUNCPARAMETER set LABEL = 'Classified ����',OBJTYPE = ref_9 where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 1;
  exception
    when No_Data_Found then
      insert into ALLFUNCPARAMETER(CLASSIFIED,LABEL,ALLFUNCTION,PARAMORDER,OBJTYPE) values(ref_5,'Classified ����',ref_6,1,ref_9);
  end;
end;
/
declare
  ref_1    number;
  ref_5    number;
  ref_6    number;
  ref_7    number;
  ref_8    number;
  ref_9    number;
  ref_10    number;
begin
  select Classified.NEXTVAL into ref_5 from DUAL;
ref_8 := NULL;

select CODE into ref_7 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_8) = 1 and CONSTTYPE = 5;


select CLASSIFIED into ref_6 from ALLFUNCTION where  FUNCTIONNAME = 'TARIF_TOOLS.CHECKOBJTYPE' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_7) = 1;

ref_10 := NULL;

select CODE into ref_9 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_10) = 1 and CONSTTYPE = 2;

  begin
    select CLASSIFIED into ref_1 from ALLFUNCPARAMETER where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 2;
    update ALLFUNCPARAMETER set LABEL = '������',OBJTYPE = ref_9 where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 2;
  exception
    when No_Data_Found then
      insert into ALLFUNCPARAMETER(CLASSIFIED,LABEL,ALLFUNCTION,PARAMORDER,OBJTYPE) values(ref_5,'������',ref_6,2,ref_9);
  end;
end;
/
declare
  ref_1    number;
  ref_5    number;
  ref_6    number;
  ref_7    number;
  ref_8    number;
  ref_9    number;
  ref_10    number;
begin
  select Classified.NEXTVAL into ref_5 from DUAL;
ref_8 := NULL;

select CODE into ref_7 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_8) = 1 and CONSTTYPE = 5;


select CLASSIFIED into ref_6 from ALLFUNCTION where  FUNCTIONNAME = 'TARIF_TOOLS.CHECKACCOUNTTYPE' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_7) = 1;


select CLASSIFIED into ref_10 from DICTIONARY where  CODE = 'Account';


select CODE into ref_9 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_10) = 1 and CONSTTYPE = 7;

  begin
    select CLASSIFIED into ref_1 from ALLFUNCPARAMETER where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 1;
    update ALLFUNCPARAMETER set LABEL = 'Classified �����',OBJTYPE = ref_9 where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 1;
  exception
    when No_Data_Found then
      insert into ALLFUNCPARAMETER(CLASSIFIED,LABEL,ALLFUNCTION,PARAMORDER,OBJTYPE) values(ref_5,'Classified �����',ref_6,1,ref_9);
  end;
end;
/
declare
  ref_1    number;
  ref_5    number;
  ref_6    number;
  ref_7    number;
  ref_8    number;
  ref_9    number;
  ref_10    number;
begin
  select Classified.NEXTVAL into ref_5 from DUAL;
ref_8 := NULL;

select CODE into ref_7 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_8) = 1 and CONSTTYPE = 5;


select CLASSIFIED into ref_6 from ALLFUNCTION where  FUNCTIONNAME = 'TARIF_TOOLS.CHECKACCOUNTTYPE' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_7) = 1;


select CLASSIFIED into ref_10 from DICTIONARY where  CODE = 'AccountType';


select CODE into ref_9 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_10) = 1 and CONSTTYPE = 7;

  begin
    select CLASSIFIED into ref_1 from ALLFUNCPARAMETER where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 2;
    update ALLFUNCPARAMETER set LABEL = '��� �����',OBJTYPE = ref_9 where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 2;
  exception
    when No_Data_Found then
      insert into ALLFUNCPARAMETER(CLASSIFIED,LABEL,ALLFUNCTION,PARAMORDER,OBJTYPE) values(ref_5,'��� �����',ref_6,2,ref_9);
  end;
end;
/
declare
  ref_1    number;
  ref_5    number;
  ref_6    number;
  ref_7    number;
  ref_8    number;
  ref_9    number;
  ref_10    number;
begin
  select Classified.NEXTVAL into ref_5 from DUAL;
ref_8 := NULL;

select CODE into ref_7 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_8) = 1 and CONSTTYPE = 5;


select CLASSIFIED into ref_6 from ALLFUNCTION where  FUNCTIONNAME = 'TARIF_TOOLS.CHECKTRANSFERMESSAGE' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_7) = 1;

ref_10 := NULL;

select CODE into ref_9 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_10) = 1 and CONSTTYPE = 3;

  begin
    select CLASSIFIED into ref_1 from ALLFUNCPARAMETER where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 1;
    update ALLFUNCPARAMETER set LABEL = 'Classified  ����',OBJTYPE = ref_9 where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 1;
  exception
    when No_Data_Found then
      insert into ALLFUNCPARAMETER(CLASSIFIED,LABEL,ALLFUNCTION,PARAMORDER,OBJTYPE) values(ref_5,'Classified  ����',ref_6,1,ref_9);
  end;
end;
/
declare
  ref_1    number;
  ref_5    number;
  ref_6    number;
  ref_7    number;
  ref_8    number;
  ref_9    number;
  ref_10    number;
begin
  select Classified.NEXTVAL into ref_5 from DUAL;
ref_8 := NULL;

select CODE into ref_7 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_8) = 1 and CONSTTYPE = 5;


select CLASSIFIED into ref_6 from ALLFUNCTION where  FUNCTIONNAME = 'TARIF_TOOLS.CHECKTRANSFERMESSAGE' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_7) = 1;

ref_10 := NULL;

select CODE into ref_9 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_10) = 1 and CONSTTYPE = 3;

  begin
    select CLASSIFIED into ref_1 from ALLFUNCPARAMETER where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 2;
    update ALLFUNCPARAMETER set LABEL = '���������',OBJTYPE = ref_9 where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 2;
  exception
    when No_Data_Found then
      insert into ALLFUNCPARAMETER(CLASSIFIED,LABEL,ALLFUNCTION,PARAMORDER,OBJTYPE) values(ref_5,'���������',ref_6,2,ref_9);
  end;
end;
/
declare
  ref_1    number;
  ref_5    number;
  ref_6    number;
  ref_7    number;
  ref_8    number;
  ref_9    number;
  ref_10    number;
begin
  select Classified.NEXTVAL into ref_5 from DUAL;
ref_8 := NULL;

select CODE into ref_7 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_8) = 1 and CONSTTYPE = 3;


select CLASSIFIED into ref_6 from ALLFUNCTION where  FUNCTIONNAME = 'TARIF_TOOLS.REESTRINITDOC' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_7) = 1;

ref_10 := NULL;

select CODE into ref_9 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_10) = 1 and CONSTTYPE = 3;

  begin
    select CLASSIFIED into ref_1 from ALLFUNCPARAMETER where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 1;
    update ALLFUNCPARAMETER set LABEL = '������� ������',OBJTYPE = ref_9 where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 1;
  exception
    when No_Data_Found then
      insert into ALLFUNCPARAMETER(CLASSIFIED,LABEL,ALLFUNCTION,PARAMORDER,OBJTYPE) values(ref_5,'������� ������',ref_6,1,ref_9);
  end;
end;
/
declare
  ref_1    number;
  ref_5    number;
  ref_6    number;
  ref_7    number;
  ref_8    number;
  ref_9    number;
  ref_10    number;
begin
  select Classified.NEXTVAL into ref_5 from DUAL;
ref_8 := NULL;

select CODE into ref_7 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_8) = 1 and CONSTTYPE = 5;


select CLASSIFIED into ref_6 from ALLFUNCTION where  FUNCTIONNAME = 'TARIF_TOOLS.ISINERNALPAYMENT' and FUNCINTENTION = 1 and ExportReplace.IsEqualN(RETURNOBJTYPE,ref_7) = 1;

ref_10 := NULL;

select CODE into ref_9 from DESIGNOBJTYPE where  ExportReplace.IsEqualN(DICTIONARY,ref_10) = 1 and CONSTTYPE = 3;

  begin
    select CLASSIFIED into ref_1 from ALLFUNCPARAMETER where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 1;
    update ALLFUNCPARAMETER set LABEL = '������',OBJTYPE = ref_9 where  ExportReplace.IsEqualN(ALLFUNCTION,ref_6) = 1 and PARAMORDER = 1;
  exception
    when No_Data_Found then
      insert into ALLFUNCPARAMETER(CLASSIFIED,LABEL,ALLFUNCTION,PARAMORDER,OBJTYPE) values(ref_5,'������',ref_6,1,ref_9);
  end;
end;
/

spool off
