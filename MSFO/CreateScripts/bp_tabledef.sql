-- Таблица перекодировки имен полей
create table bp_tabledef (
  TblName    varchar2(40),
  FldName    varchar2(40),
  FldNameDbf varchar2(40),
  Unload     number(1) default 1 not null )
tablespace MSFO_NSI
;

alter table bp_tabledef 
add constraint bp_tabledef_p primary key (TblName,FldName)
tablespace MSFO_NSI;

