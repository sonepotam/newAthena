SET SERVEROUTPUT ON SIZE 1000000
DECLARE
 sTriggerText VARCHAR2(4000);
 bFirstColumn BOOLEAN;
 sTriggerName VARCHAR2(30);
BEGIN
 FOR rwTables IN
 (
  SELECT utc.table_name FROM user_tab_columns utc
   WHERE utc.column_name='SYSMOMENT'
/*    AND NOT EXISTS
    (
     SELECT 'A' FROM user_triggers utr
      WHERE utr.table_name=utc.table_name
       AND utr.trigger_name LIKE '%SYSMOM'
    ) */
 )
 LOOP
  sTriggerName:='T_'||SUBSTR(rwTables.table_name,1,21)||'_SYSMOM';
  sTriggerText:='CREATE OR REPLACE TRIGGER '||sTriggerName||' ';
  sTriggerText:=sTriggerText||CHR(13)||CHR(10);
  sTriggerText:=sTriggerText||' BEFORE INSERT OR UPDATE OF ';
  bFirstColumn:=TRUE;
  FOR rwColumns IN
  (
   SELECT utc.column_name
     FROM user_tab_columns utc
    WHERE utc.table_name=rwTables.table_name
     AND utc.column_name NOT IN
     ('REC_UNLOAD','REC_PROCESS','ID_FILE','SYSMOMENT') 
  )
  LOOP
   IF NOT bFirstColumn THEN
    sTriggerText:=sTriggerText||', ';
   END IF;
   bFirstColumn:=FALSE;
   sTriggerText:=sTriggerText||rwColumns.column_name;
  END LOOP;
  sTriggerText:=sTriggerText||CHR(13)||CHR(10);
  sTriggerText:=sTriggerText||' ON '||rwTables.table_name||' ';
  sTriggerText:=sTriggerText||CHR(13)||CHR(10);
  sTriggerText:=sTriggerText||' FOR EACH ROW ';
  sTriggerText:=sTriggerText||CHR(13)||CHR(10);
  sTriggerText:=sTriggerText||'BEGIN';
  sTriggerText:=sTriggerText||' :NEW.sysmoment:=SYSDATE;';
  sTriggerText:=sTriggerText||' END; ';
  DBMS_OUTPUT.PUT_LINE('Создаем триггер '||sTriggerName);
  BEGIN
   EXECUTE IMMEDIATE sTriggerText;
  EXCEPTION
   WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка создания триггера '||sTriggerName||':');
    DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 254));
  END;
 END LOOP;
END;
/
