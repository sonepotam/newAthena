---
--- ¤®Ў ў«Ґ­ЁҐ вҐе­ЁзҐбЄЁе Є®«®­®Є ¤«п ўлЈаг§ЄЁ
---
ALTER TABLE ASS_ACCOUNT_BALANCE
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE ASS_ACCOUNT_CAT
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE ASS_BANK_DEPARTMENT
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE ASS_CARRY_CAT
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE ASS_CFA_ACCOUNT
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE ASS_CURR_GROUPCURR
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE ASS_DET_ACCOUNT
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE ASS_DET_BALANCE
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE ASS_DET_OKONH
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE ASS_DET_OKVED
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE ASS_SUBJECT_CAT
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_ACCOUNT
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_ACCOUNT_CAT
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_ACCOUNT_CAT_VAL
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_ACC_ASS_KIND
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_BALANCE
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_CARRY_CAT
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_CARRY_CAT_VAL
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_CFA
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_CHAPTER
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_COUNTRY
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_CURRENCY
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_CURRENCYGROUP
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_DEPARTMENT
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_FINSTR
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_JURIDIC_PERSON
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_OKATO
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_OKONH
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_OKVED
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_PHYZ_PERSON
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_PLAN_BAL
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_ROLEACCOUNT_DEAL
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_SUBJECT
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_SUBJECTGROUP
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_SUBJECT_CAT
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_SUBJECT_CAT_VAL
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_SYSTEM
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_TYPEATTR
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_TYPELINKGROUP
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE DET_TYPE_RATE
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE FCT_ACCOUNT
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE FCT_BALANCE
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE FCT_BALANCE_CFA
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE FCT_CARRY
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE FCT_FINSTR_RATE
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE FCT_HALFCARRY
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE FCT_PAYMENT
    add ( rec_unload number(1), rec_process number( 1));
ALTER TABLE FCT_SUBJATTR
    add ( rec_unload number(1), rec_process number( 1));

comment on column ASS_ACCOUNT_BALANCE.rec_unload is 'Признак выгрузки';
comment on column ASS_ACCOUNT_BALANCE.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column ASS_ACCOUNT_CAT.rec_unload is 'Признак выгрузки';
comment on column ASS_ACCOUNT_CAT.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column ASS_BANK_DEPARTMENT.rec_unload is 'Признак выгрузки';
comment on column ASS_BANK_DEPARTMENT.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column ASS_CARRY_CAT.rec_unload is 'Признак выгрузки';
comment on column ASS_CARRY_CAT.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column ASS_CFA_ACCOUNT.rec_unload is 'Признак выгрузки';
comment on column ASS_CFA_ACCOUNT.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column ASS_CURR_GROUPCURR.rec_unload is 'Признак выгрузки';
comment on column ASS_CURR_GROUPCURR.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column ASS_DET_ACCOUNT.rec_unload is 'Признак выгрузки';
comment on column ASS_DET_ACCOUNT.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column ASS_DET_BALANCE.rec_unload is 'Признак выгрузки';
comment on column ASS_DET_BALANCE.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column ASS_DET_OKONH.rec_unload is 'Признак выгрузки';
comment on column ASS_DET_OKONH.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column ASS_DET_OKVED.rec_unload is 'Признак выгрузки';
comment on column ASS_DET_OKVED.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column ASS_SUBJECT_CAT.rec_unload is 'Признак выгрузки';
comment on column ASS_SUBJECT_CAT.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_ACCOUNT.rec_unload is 'Признак выгрузки';
comment on column DET_ACCOUNT.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_ACCOUNT_CAT.rec_unload is 'Признак выгрузки';
comment on column DET_ACCOUNT_CAT.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_ACCOUNT_CAT_VAL.rec_unload is 'Признак выгрузки';
comment on column DET_ACCOUNT_CAT_VAL.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_ACC_ASS_KIND.rec_unload is 'Признак выгрузки';
comment on column DET_ACC_ASS_KIND.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_BALANCE.rec_unload is 'Признак выгрузки';
comment on column DET_BALANCE.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_CARRY_CAT.rec_unload is 'Признак выгрузки';
comment on column DET_CARRY_CAT.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_CARRY_CAT_VAL.rec_unload is 'Признак выгрузки';
comment on column DET_CARRY_CAT_VAL.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_CFA.rec_unload is 'Признак выгрузки';
comment on column DET_CFA.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_CHAPTER.rec_unload is 'Признак выгрузки';
comment on column DET_CHAPTER.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_COUNTRY.rec_unload is 'Признак выгрузки';
comment on column DET_COUNTRY.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_CURRENCY.rec_unload is 'Признак выгрузки';
comment on column DET_CURRENCY.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_CURRENCYGROUP.rec_unload is 'Признак выгрузки';
comment on column DET_CURRENCYGROUP.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_DEPARTMENT.rec_unload is 'Признак выгрузки';
comment on column DET_DEPARTMENT.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_FINSTR.rec_unload is 'Признак выгрузки';
comment on column DET_FINSTR.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_JURIDIC_PERSON.rec_unload is 'Признак выгрузки';
comment on column DET_JURIDIC_PERSON.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_OKATO.rec_unload is 'Признак выгрузки';
comment on column DET_OKATO.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_OKONH.rec_unload is 'Признак выгрузки';
comment on column DET_OKONH.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_OKVED.rec_unload is 'Признак выгрузки';
comment on column DET_OKVED.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_PHYZ_PERSON.rec_unload is 'Признак выгрузки';
comment on column DET_PHYZ_PERSON.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_PLAN_BAL.rec_unload is 'Признак выгрузки';
comment on column DET_PLAN_BAL.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_ROLEACCOUNT_DEAL.rec_unload is 'Признак выгрузки';
comment on column DET_ROLEACCOUNT_DEAL.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_SUBJECT.rec_unload is 'Признак выгрузки';
comment on column DET_SUBJECT.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_SUBJECTGROUP.rec_unload is 'Признак выгрузки';
comment on column DET_SUBJECTGROUP.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_SUBJECT_CAT.rec_unload is 'Признак выгрузки';
comment on column DET_SUBJECT_CAT.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_SUBJECT_CAT_VAL.rec_unload is 'Признак выгрузки';
comment on column DET_SUBJECT_CAT_VAL.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_SYSTEM.rec_unload is 'Признак выгрузки';
comment on column DET_SYSTEM.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_TYPEATTR.rec_unload is 'Признак выгрузки';
comment on column DET_TYPEATTR.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_TYPELINKGROUP.rec_unload is 'Признак выгрузки';
comment on column DET_TYPELINKGROUP.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column DET_TYPE_RATE.rec_unload is 'Признак выгрузки';
comment on column DET_TYPE_RATE.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column FCT_ACCOUNT.rec_unload is 'Признак выгрузки';
comment on column FCT_ACCOUNT.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column FCT_BALANCE.rec_unload is 'Признак выгрузки';
comment on column FCT_BALANCE.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column FCT_BALANCE_CFA.rec_unload is 'Признак выгрузки';
comment on column FCT_BALANCE_CFA.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column FCT_CARRY.rec_unload is 'Признак выгрузки';
comment on column FCT_CARRY.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column FCT_FINSTR_RATE.rec_unload is 'Признак выгрузки';
comment on column FCT_FINSTR_RATE.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column FCT_HALFCARRY.rec_unload is 'Признак выгрузки';
comment on column FCT_HALFCARRY.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column FCT_PAYMENT.rec_unload is 'Признак выгрузки';
comment on column FCT_PAYMENT.rec_process is 'Признак обработки(для поиска удаленных)';
comment on column FCT_SUBJATTR.rec_unload is 'Признак выгрузки';
comment on column FCT_SUBJATTR.rec_process is 'Признак обработки(для поиска удаленных)';
