create table bp_tmp_defPayments(
  TaskNo    number,
  debSchet  varChar2( 32),
  credSchet varChar2( 32),
  amount    number( 23, 4),
  curDate   DATE,
  DTParent  number,
  PMClass   number);

grant all on bp_tmp_defPayments to bbr;
