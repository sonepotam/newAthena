DECLARE
 sCommString VARCHAR2(254);
BEGIN
 FOR iRow IN
 (
  SELECT table_name FROM user_tables ut
   WHERE NOT EXISTS
   (
    SELECT 'A' FROM user_tab_columns utc
     WHERE utc.table_name=ut.table_name
      AND utc.column_name='SYSMOMENT'
   )
   AND ut.table_name NOT IN ('BP_FCT_FILES', 'BP_TABLEDEF')
 )
 LOOP
  sCommString:='ALTER TABLE '||iRow.table_name||' ADD (SYSMOMENT DATE)';
  EXECUTE IMMEDIATE sCommString;
  sCommString:='UPDATE '||iRow.table_name||' SET SYSMOMENT=SYSDATE WHERE SYSMOMENT IS NULL';
  EXECUTE IMMEDIATE sCommString;
  sCommString:='ALTER TABLE '||iRow.table_name||' MODIFY (SYSMOMENT NOT NULL)';
  EXECUTE IMMEDIATE sCommString;
 END LOOP;
END;
/
