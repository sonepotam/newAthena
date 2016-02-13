CREATE OR REPLACE PROCEDURE ut_bp_ap_FillASVTable( dDate in date)
IS
/*
  Процедура : ut_bp_ap_FillASVTable
  Назначение: Заполняет набор таблиц, необходимых для аккумулирования данных о клиенте и остатке на его счетах для АСВ
  Путь в VSS: Новая Афина\Утилитные процедуры и функции\Подготовка данных для АСВ
  Версия    : 1.0.0.6

*/
nDummy 	        int;
sDocCode        VARCHAR2( 2);
sAddrPost       VARCHAR2( 254);
sAdrrJur        VARCHAR2( 254);
sClientDocRecv  VARCHAR2( 254);
sSurname        VARCHAR2( 50);
sName           VARCHAR2( 50);
sSecondname     VARCHAR2( 50);
dDate1          DATE := trunc( dDate) + 1 - 1/24/60/60;
idDocType1      DocType.Classified%Type;     --
idDocType2      DocType.Classified%Type;     --
nAccType        Number(1);                   --

-- Функция перекодировки справочника типов документов
FUNCTION ClientDocType( nClass IN NUMBER) RETURN VARCHAR2 IS
    Result VARCHAR2( 2);
	sCode VARCHAR2 (50);
BEGIN
	sCode := GetMainJurDocType(nClass);
    SELECT DECODE(sCode, 'Passport21' ,       '1',
		   				 'Passport3'  ,       '2',
						 'Passport4'  ,       '3',
						 'Passport7'  ,       '4',
						 'Passport6'  ,       '5',
						 'Passport26' ,       '5',
						 'PassportDN1',       '6',
						 'TempRegistration',  '8',
						 'Passport12' ,       '9',
						 'PassportDN2',       '10',
						 'Passport11' ,       '11',
						 'Passport13' ,       '12',
						 'Passport14' ,       '13',
									          '14' )
	INTO Result
	FROM DUAL;
	RETURN Result;
END;


function getPersData(aIdCl in DT.Reference,aRSCode in VarChar2,
                         aLCLineLabel in VarChar2) return VarChar2
is
Result VarChar2(200):='';
begin
 begin
   select QV.LineValue into Result
   from reportschema RS, linecode LC, QuestValue QV
   where RS.Code = aRSCode
   and RS.Classified = LC.ReportSchema
   and LC.LINELABEL=aLCLineLabel
   and QV.LINECODE = LC.Classified
   and QV.Client = aIdCl;
 exception when others then
   null;
 end;
 return Result;
end;

FUNCTION ClientPlaceReg( nClass IN NUMBER, sShema IN VARCHAR2) RETURN VARCHAR2 IS
    Result VARCHAR2( 254) := '';
	sCode VARCHAR2 (200);
BEGIN
	 Result := '';
	 sCode := REPLACE(getPersData(nClass,sShema,'Индекс'),',','#');
	 Result := Result||sCode||', ';
	 sCode := REPLACE(getPersData(nClass,sShema,'Область'),',','#');
	 Result := Result||sCode||', ';
	 sCode := REPLACE(getPersData(nClass,sShema,'Населенный пункт'),',','#');
	 Result := Result||sCode||', ';
	 sCode := REPLACE(getPersData(nClass,sShema,'Улица'),',','#');
	 Result := Result||sCode||', ';
	 sCode := REPLACE(getPersData(nClass,sShema,'Дом'),',','#');
	 Result := Result||sCode||', , ';
	 sCode := REPLACE(getPersData(nClass,sShema,'Корпус'),',','#');
	 Result := Result||sCode||', ';
	 sCode := REPLACE(getPersData(nClass,sShema,'Квартира'),',','#');
	 Result := Result||sCode;
/*
	 sCode := getPersData(nClass,sShema,'Индекс');
	 if sCode is not Null then Result := Result||sCode||', '; end if;
	 sCode := getPersData(nClass,sShema,'Область');
	 if sCode is not Null then Result := Result||sCode||', '; end if;
	 sCode := getPersData(nClass,sShema,'Район');
	 if sCode is not Null then Result := Result||sCode||' район, '; end if;
	 sCode := getPersData(nClass,sShema,'Населенный пункт');
	 if sCode is not Null then Result := Result||sCode||', '; end if;
	 sCode := getPersData(nClass,sShema,'Улица');
	 if sCode is not Null then Result := Result||sCode||', '; end if;
	 sCode := getPersData(nClass,sShema,'Дом');
	 if sCode is not Null then Result := Result||'д.'||sCode||', '; end if;
	 sCode := getPersData(nClass,sShema,'Корпус');
	 if sCode is not Null then Result := Result||'к.'||sCode||', '; end if;
	 sCode := getPersData(nClass,sShema,'Квартира');
	 if sCode is not Null then Result := Result||'кв.'||sCode; end if;
*/
 	RETURN Result;
END;
-- Функция получения реквизитов документа клиента
FUNCTION ClientDocRecv( nClass IN NUMBER) RETURN VARCHAR2 IS
    Result VARCHAR2( 254) := 'Нет в базе';
	sCode VARCHAR2 (50);
BEGIN
	sCode := GetMainJurDocType(nClass);
    IF sCode IS NOT NULL THEN
	   IF od.GetJurQuestCodeValue(sCode,'Series',nClass) IS NOT NULL THEN
	       Result := 'серия ' || od.GetJurQuestCodeValue(sCode,'Series',nClass);
	   ELSE
	       Result := '';
	   END IF;
	   IF od.GetJurQuestCodeValue(sCode,'Number',nClass) IS NOT NULL THEN
	       Result := Result || ' номер ' || od.GetJurQuestCodeValue(sCode,'Number',nClass);
       END IF;
	   IF od.GetJurQuestCodeValue(sCode,'GiveDate',nClass) IS NOT NULL THEN
	       Result := Result || ' выдан ' || to_char(TO_DATE(od.GetJurQuestCodeValue(sCode,'GiveDate',nClass),'DDMMYYYYhh24miss'),'DD.MM.YYYY');
	   End IF;
	   IF od.GetJurQuestCodeValue(sCode,'GiveBy', nClass) IS NOT NULL THEN
	       Result := Result || ' ' || od.GetJurQuestCodeValue(sCode,'GiveBy', nClass);
	   END IF;
    END IF;
	RETURN Result;
END;
BEGIN
	 BEGIN
	   SELECT d.CLASSIFIED INTO idDocType1
	   FROM doctype d
	   WHERE d.LABEL = 'Клиентский счет (руб)';
	 EXCEPTION
	   WHEN no_data_found THEN
	   raiseerror('Нет типа ''Клиентский счет (руб)'' в таблице doctype.');
	 END;
	 BEGIN
	   SELECT d.CLASSIFIED INTO idDocType2
	   FROM doctype d
	   WHERE d.LABEL = 'Клиентский счет (вал)';
	 EXCEPTION
	   WHEN no_data_found THEN
	   raiseerror('Нет типа ''Клиентский счет (вал)'' в таблице doctype.');
	 END;
	-- Цикл по клиентским счетам
    FOR Rec IN (SELECT A.Classified
                     ,A.Code
					 ,A.CLIENT
					 , nvl( ObjAttr.GetOneDesc( a.classified, ObjAttr.DescClass( -67)), nvl( DT1.Label, ' ')) as Dog
					 ,c.LABEL
					 ,
					 nvl( to_date( ObjAttr.GetOneDesc( a.classified, ObjAttr.DescClass( -68)),'ddmmyyyyhh24miss'), 
  					      nvl(DT1.ValidFromDate,A.OPENED)) as DogDate
					 ,A.SYSFILIAL
					 ,to_char( A.Type) as Type
					 ,od.AccRestOut(A.CLASSIFIED, dDate1, 1, 0) as Rest
					 ,od.AccRestOut(A.CLASSIFIED, dDate1, 5, 0) as RestEq
			   FROM   Account A
			         ,DocTree DT
					 ,DocTree DT1
					 ,CLIENT C
					 ,CLIENTTYPE CT
			   WHERE DT.Classified = A.Doc
			   AND DT1.Classified(+) = DT.Parent
  			   AND A.CLIENT = C.CLASSIFIED
			   AND C.TYPE = CT.CLASSIFIED
			   AND CT.ISPHYS = 1
               AND (
                 A.DOCTYPE =  idDocType1
                 OR A.DOCTYPE =  idDocType2
                 OR SubstR(A.Code,1,3) IN  ('455','457')
                 OR SubstR(A.Code,1,5) IN  ('45815', '45817')
			     OR substr(a.code,1,5) in ('47427','45914','45915','45917','91604')
				 OR substr(a.code,1,5) in ('45401','45402','45403','45404','45405','45406','45407','45408','45409','45814')
                 or (substr(a.code,1,5)='47423' and substr(a.code,14,3)='107')
			   ) AND SUBSTR(A.Code,1,5) not in (/*'45915', '45917', */'45715', '45515', '40802')
			   AND nvl(od.AccRestOut(A.CLASSIFIED, dDate1, 1, 0),0) <> 0
			   ORDER BY A.Code) LOOP
		BEGIN
			SELECT 1
			INTO nDummy
			FROM BP_ASV_FIL_LIST
			WHERE FILCODE = Rec.SYSFILIAL;
			UPDATE BP_ASV_FIL_LIST SET
			FILNAME = (SELECT LABEL
			           FROM SYSFILIAL
			           WHERE CODE = Rec.SYSFILIAL)
			WHERE FILCODE = Rec.SYSFILIAL;
		EXCEPTION
		  WHEN no_data_found THEN
		    INSERT INTO BP_ASV_FIL_LIST (FILCODE, FILNAME)
			SELECT CODE, LABEL
			FROM SYSFILIAL
			WHERE CODE = Rec.SYSFILIAL;
		END;
		sDocCode := ClientDocType(Rec.Client);
		sClientDocRecv := ClientDocRecv(Rec.Client);
		sSurname := Substr(Rec.LABEL,1,InStr(Rec.LABEL, ' ',1,1)-1);
		sName := Substr(Rec.LABEL,InStr(Rec.LABEL, ' ',1,1)+1, InStr(Rec.LABEL, ' ',InStr(Rec.LABEL, ' ',1,1)+1,1)-InStr(Rec.LABEL, ' ',1,1)-1);
		sSecondname := Substr(Rec.LABEL, InStr(Rec.LABEL, ' ',InStr(Rec.LABEL, ' ',1,1)+1) - Length(Rec.LABEL));
		sAdrrJur := ClientPlaceReg(Rec.Client,'AddressFact');
		sAddrPost := ClientPlaceReg(Rec.Client,'AddressPost');
		BEGIN
			SELECT 1
			INTO nDummy
			FROM BP_ASV_CLIENT_LIST
			WHERE client = Rec.Client;

			UPDATE BP_ASV_CLIENT_LIST SET
			SURNAME = sSurname,
			NAME = sName,
			SECONDNAME = sSecondname,
			ADDRESS = sAdrrJur,
			POSTADDRESS = sAddrPost,
			EMAILADDRESS = NULL,
			DOCTYPE = sDocCode,
			DOCTEXT = sClientDocRecv
			WHERE client = Rec.Client;
		EXCEPTION
		  WHEN no_data_found THEN
			INSERT INTO BP_ASV_CLIENT_LIST (CLIENT, SURNAME, NAME, SECONDNAME, ADDRESS, POSTADDRESS, EMAILADDRESS, DOCTYPE, DOCTEXT)
			VALUES (Rec.Client, sSurname, sName, sSecondname, sAdrrJur, sAddrPost, null, sDocCode,sClientDocRecv);
		END;
		IF (SUBSTR(Rec.Code,1,3) IN ('455','457')) OR (SUBSTR(Rec.Code,1,5) IN ('45815', '45818', '47427', '45914', '45915', '45917', '91604')
		    OR SUBSTR(Rec.code,1,5) IN ('45401','45402','45403','45404','45405','45406','45407','45408','45409','45814')) THEN
			nAccType := 2;
		ELSE
			nAccType := 1;
		END IF;
		BEGIN
			SELECT 1
			INTO nDummy
			FROM BP_ASV_ACCOUNT_LIST
			WHERE ACCOUNTCODE = Rec.Classified;

			UPDATE BP_ASV_ACCOUNT_LIST SET
			CLIENT = Rec.Client,
			FILCODE = Rec.SYSFILIAL,
			DOCNUMBER = Rec.Dog,
			DOCDATE = Rec.DogDate,
			ACCOUNT = Rec.Code,
			RECTYPE = nAccType
			WHERE ACCOUNTCODE = Rec.Classified;
		EXCEPTION
		  WHEN no_data_found THEN
			INSERT INTO BP_ASV_ACCOUNT_LIST (CLIENT, FILCODE, DOCNUMBER, DOCDATE, ACCOUNT, ACCOUNTCODE, RECTYPE)
		    VALUES (Rec.Client, Rec.SYSFILIAL, Rec.Dog, Rec.DogDate, Rec.Code, Rec.Classified, nAccType);
		END;
		BEGIN
			SELECT 1
			INTO nDummy
			FROM BP_ASV_REST_LIST
			WHERE ACCOUNTCODE = Rec.Classified AND RESTDATE = dDate;
			UPDATE BP_ASV_REST_LIST SET
			SUMMA = Rec.Rest,
			SUMMAEQ = Rec.RestEq
			WHERE ACCOUNTCODE = Rec.Classified AND RESTDATE = dDate;
		EXCEPTION
		  WHEN no_data_found THEN
		  	INSERT INTO BP_ASV_REST_LIST (ACCOUNTCODE, SUMMA, SUMMAEQ, RESTDATE)
		    VALUES (Rec.Classified, Rec.Rest, Rec.RestEq, dDate);
		END;
    END LOOP;
COMMIT;
END;
/
