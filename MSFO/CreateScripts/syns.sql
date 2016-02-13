begin 
  for rec in 
  ( 
   select ut.table_name from user_tables ut
    where not exists
    (
     SELECT 'A' FROM all_synonyms als
      WHERE als.owner='PUBLIC'
       AND als.table_name=ut.table_name
       AND als.synonym_name=ut.table_name
    )
  ) loop
    execute immediate 'create public synonym  ' || rec.table_name || ' for msfo.' || rec.table_name;
  end loop;
end;  
/
create public synonym bp_seq_reval_code for bp_seq_reval_code;
