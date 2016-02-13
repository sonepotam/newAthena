begin 
  for rec in ( select table_name from user_tables) loop
    execute immediate 'grant all on ' || rec.table_name || ' to olap_remote';
  end loop;
end;  
/
grant select on bp_seq_reval_code to olap_remote;
