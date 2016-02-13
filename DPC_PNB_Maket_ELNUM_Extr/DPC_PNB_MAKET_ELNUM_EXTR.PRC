CREATE OR REPLACE procedure DPC_PNB_Maket_ELNUM_Extr
---------------------------------------------------------------------------------------------------
-- формирует уникальный номер документа (ELNUM) и  Extract затем пишет их в
-- DocTree.Extract  обрабатывает  только документы с не пустой транспортной системой
-- VSS : $/Новая Афина/DPC - процедуры/формирует уникальный номер документа (ELNUM) и  Extract для исходящих документов
-- 07.06.2005 Цейтлин П.М. Изменен принцип заполнения поля Extract теперь
-- сначала заполняется старый Extract : Elnum. Раньше было наоборот.
---------------------------------------------------------------------------------------------------
as
   nMaketDoc   DT.Reference      default Context.CurrentDoc;               /* макет                   */
   nRefDesc    DT.Reference      default DescClass(84);       /* внешний номер документа */
   sErr        DT.Description;                                             /* сообщение об ошибке     */
   sElNum      DT.Label;                                                   /* ELNUM                   */
   sOurBIC     BankCode.Code%type;                                         /* наш БИК                 */
   dtOperDate  date := Context.OperDate;                 /* дата тек.опер.дня --EVG 301202 */
   idBICRU     DT.Reference;                                               /* Classified БИК-а        */
   sExtract    DocTree.Extract%type;                                       /* Выжимка                 */
---------------------------------------------------------------------------------------------------
   -- документы в макете у которых транспортная система не пуста
   cursor curDocsInMaket is
      select Dim.SendDoc
        from DocsInMaket Dim , CustomerTransfer Ct
       where Dim.Doc = nMaketDoc
         and Ct.Doc = Dim.SendDoc
         and Ct.ClearingHouse is not null;
---------------------------------------------------------------------------------------------------
   -- формирование Extract
   cursor curExtrct(idDoc DT.Reference) is
     select to_number(nvl(substr(DT.Label,-3),DT.Label))                /* номер документа*/ -- 141202
        ||' '||sOurBIC                                                  /* наш БИК */
        ||' '||CT.PayAccount                                            /* счет отправителя_  */
        ||' -'||ltrim(to_char(BO.SumAccount,'9999999999999999999990.99')) /* сумма платежа */
        ||' '||ClientCode(CT.BeneficiaryBank,idBICRU)                   /* БИК банка получателя_ */
        ||' '||CT.BeneficiaryAccount                                    /* счет получателя_ */
        ||' '||to_char(DT.ValidFromDate,'YYYYMMDD')                     /* дата документа */
                                                     str
      from BankOper           BO,
           CustomerTransfer   CT,
           DocTree            DT
     where BO.Doc = idDoc
       and CT.Doc = idDoc
       and DT.Classified = idDoc;
---------------------------------------------------------------------------------------------------
begin
   -- Кодовая система БИК
   sErr := 'Кодовая система БИК';
   select Classified into idBICRU from CodeSystem where Const = 7;
   -- наш БИК
   sOurBIC := ClientCode(pref.OurBank, idBICRU);
   -- select OurBank into nOBank from Preference where SysFilial = c_access.getfilial;
   sErr := 'При формировании первых 7 символов эл. номера документа';
   sElNum := lpad(to_36(substr(sOurBIC,3,7)||'000'), 7, '0');
   sErr := 'При обработке даты документа <'||teller_proc.DocIdent(nMaketDoc)||'>';
    sElNum := 'A2'     ||
          sElNum   ||
          to_36(to_number(to_char(dtOperDate,'YYYY')) - 1990) ||
          to_36(to_number(to_char(dtOperDate, 'MM')))         ||
          to_36(to_number(to_char(dtOperDate, 'DD')));
    --***

   -- запишем Extract документам
   sErr := 'При формировании эл. номера документа документов в макете <'||teller_proc.DocIdent(nMaketDoc)||'>';
   for rDoc in curDocsInMaket loop
      -- вычислим Extract по документу
      for rec in curExtrct(rDoc.SendDoc) loop
         sExtract := rec.str;
         exit;
      end loop;
      -- запишем Extract в DocTree
      update DocTree
         set Extract =
            substr(sExtract || ':'|| sElNum ||lpad(to_36(to_number(GetObjDesc(rDoc.SendDoc, nRefDesc))), 4, '0')
                     ,1,254)
      where Classified = rDoc.SendDoc;
   end loop;
exception
   when NO_DATA_FOUND then
      raise_application_error(-20000,'Не найдено значение : '||sErr);
   when TOO_MANY_ROWS then
      raise_application_error(-20000, 'Найдено более одного значения : '||sErr);
   when VALUE_ERROR or INVALID_NUMBER then
      raise_application_error(-20000,'Невозможно преобразовать значение : '||sErr);
   when OTHERS then
   if sqlCode = -20000 then
      raise;
   end if; /* sqlCode = -20000 */
      raise_application_error(-20000,'Нераспознаная ошибка ('||sErr||') - <'||sqlerrm||'>');
end DPC_PNB_Maket_ELNUM_Extr;
/
