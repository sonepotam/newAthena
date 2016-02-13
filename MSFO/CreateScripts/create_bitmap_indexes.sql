create bitmap index idx_ASS_ACCOUNT_BALANCE_unl
    on ASS_ACCOUNT_BALANCE( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_ASS_ACCOUNT_CAT_unl
    on ASS_ACCOUNT_CAT( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_ASS_BANK_DEPARTMENT_unl
    on ASS_BANK_DEPARTMENT( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_ASS_CARRY_CAT_unl
    on ASS_CARRY_CAT( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_ASS_CFA_ACCOUNT_unl
    on ASS_CFA_ACCOUNT( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_ASS_CURR_GROUPCURR_unl
    on ASS_CURR_GROUPCURR( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_ASS_DET_ACCOUNT_unl
    on ASS_DET_ACCOUNT( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_ASS_DET_BALANCE_unl
    on ASS_DET_BALANCE( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_ASS_DET_OKONH_unl
    on ASS_DET_OKONH( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_ASS_DET_OKVED_unl
    on ASS_DET_OKVED( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_ASS_SUBJECT_CAT_unl
    on ASS_SUBJECT_CAT( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_ACCOUNT_unl
    on DET_ACCOUNT( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_DET_ACCOUNT_CAT_unl
    on DET_ACCOUNT_CAT( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_ACCOUNT_CAT_VAL_unl
    on DET_ACCOUNT_CAT_VAL( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_ACC_ASS_KIND_unl
    on DET_ACC_ASS_KIND( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_BALANCE_unl
    on DET_BALANCE( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_CARRY_CAT_unl
    on DET_CARRY_CAT( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_CARRY_CAT_VAL_unl
    on DET_CARRY_CAT_VAL( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_CFA_unl
    on DET_CFA( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_CHAPTER_unl
    on DET_CHAPTER( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_COUNTRY_unl
    on DET_COUNTRY( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_CURRENCY_unl
    on DET_CURRENCY( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_CURRENCYGROUP_unl
    on DET_CURRENCYGROUP( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_DEPARTMENT_unl
    on DET_DEPARTMENT( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_FINSTR_unl
    on DET_FINSTR( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_JURIDIC_PERSON_unl
    on DET_JURIDIC_PERSON( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_DET_OKATO_unl
    on DET_OKATO( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_OKONH_unl
    on DET_OKONH( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_OKVED_unl
    on DET_OKVED( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_PHYZ_PERSON_unl
    on DET_PHYZ_PERSON( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_DET_PLAN_BAL_unl
    on DET_PLAN_BAL( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_ROLEACCOUNT_DEAL_unl
    on DET_ROLEACCOUNT_DEAL( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_SUBJECT_unl
    on DET_SUBJECT( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_DET_SUBJECTGROUP_unl
    on DET_SUBJECTGROUP( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_SUBJECT_CAT_unl
    on DET_SUBJECT_CAT( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_SUBJECT_CAT_VAL_unl
    on DET_SUBJECT_CAT_VAL( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_SYSTEM_unl
    on DET_SYSTEM( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_TYPEATTR_unl
    on DET_TYPEATTR( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_TYPELINKGROUP_unl
    on DET_TYPELINKGROUP( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_DET_TYPE_RATE_unl
    on DET_TYPE_RATE( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_FCT_ACCOUNT_unl
    on FCT_ACCOUNT( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_FCT_BALANCE_unl
    on FCT_BALANCE( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_FCT_BALANCE_CFA_unl
    on FCT_BALANCE_CFA( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_FCT_CARRY_unl
    on FCT_CARRY( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_FCT_FINSTR_RATE_unl
    on FCT_FINSTR_RATE( rec_unload)
    TABLESPACE MSFO_NSI;

create bitmap index idx_FCT_HALFCARRY_unl
    on FCT_HALFCARRY( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_FCT_PAYMENT_unl
    on FCT_PAYMENT( rec_unload)
    TABLESPACE MSFO_INDEX;

create bitmap index idx_FCT_SUBJATTR_unl
    on FCT_SUBJATTR( rec_unload)
    TABLESPACE MSFO_INDEX;

