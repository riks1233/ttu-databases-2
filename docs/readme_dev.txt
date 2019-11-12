Teha:
* (ül2 page 16) Kui registreerite eesnime ja perenime, siis peaks olema kasutatud ühte
järgnevatest lahendustest. Veenduge, et kontseptuaalses andmemudelis olev
atribuutide kirjeldus on tehtud valikuga kooskõlas (nii atribuutide kirjelduse
tabel, kui ka olemi-suhte diagrammil olevad atribuutide võimsustikud).
 Nii veerg eesnimi kui perenimi on mittekohustuslikud. Lisaks on
jõustatud andmebaasis kitsendus, et vähemalt üks nendest peab olema
registreeritud.
 Veerg eesnimi on kohustuslik ja perenimi mittekohustuslik. (Arvatavasti see variant on parem)

* seal kus _kp kasutame DATE ja _aeg - TIMESTAMP andmetüüpe
* (ül2 page 17 keskel) Kasutajanimede asmele kasutame emaili, ning parooli on vaja krüpteeritud kujul hoida, millega väljapakutavalt tegeleme ülesandes 10
* kasuta TEXT kui tekstipikkused pole ennustatavad. Vajadusel saab veerule hiljem defineerida CHECK kitsenduse, et väärtus selles veerus ei tohi olla pikem kui n märki. Kui seda pikkust on vaja muuta, siis see on palju lihtsam kui VARCHAR(n) puhul n muutmine.
* rahasummad DECIMAL(19,4)
* erinevate nimedega ja aadressi pikkustega arvestaga. Peab võimaldama nimi "Null"
* meiliaadress 254 märki
* Tekstivälja puhul, mille pikkus on üks märk, on loogilisem CHAR(1) kui
	VARCHAR(1). Lisaks peab olema CHECK kitsendus (vt ülesanne 3), et
	veerus ei tohi olla tühikutest koosnev string. Tühi string asendatakse
	CHAR tüübi korral tühiku(te)ga.
* Kui Teie andmebaasis on vaja hoida pilte, siis mõelge veelkord läbi kuidas
	seda teha (ning vajadusel parandage ka kotseptuaalset andmemudelit).
	Võimalused on hoida andmebaasis järgnevat.
	◦ Pildifaili (andmebaas suurem, kuid pilte käsitletakse kui ülejäänud
	andmeid – saab kasutada andmebaasisüsteemi pakutavaid turvalisuse,
	transaktsioonide ning varundamise/taastamise mehhanisme).
	▪ PostgreSQL korral veeru andmetüüp BYTEA või OID;
* NOT NULL (kohustuslikud) veerud läbimõelda
* (ül2 page 24) _id vs _kood: id on surrogaatvõti, mis ei oma sisulist tähendust; kood omab sisulist tähendust ning seda sisestab inimkasutaja
* Primary key tüübi muutmisel tuleb Foreign key sõltuvas tabelis ka muuta
	Kui määrate EAs veeru "tüübiks" SERIAL / SMALLSERIAL / BIGSERIAL, siis
	määrab CASE vahend selle "tüübi" automaatselt ka sellele veerule viitavatele
	välisvõtme veergudele. Välisvõtme veergude tüübid tuleb käsitis asendada
	vastavalt tüüpidega INTEGER / SMALLINT / BIGINT.
*  Ärge unustage, et võti võib olla liitvõti. Liitvõtme kirjeldamise kohta vaadake
	videot "Mitut veergu hõlmava UNIQUE kitsenduse kirjeldamine andmebaasi
	diagrammis".
*  Ärge kirjeldage üksteist dubleerivaid võtmeid. Primaarvõti tähendab juba
	unikaalsust. Primaarvõtme veergudele lisaks UNIQUE kitsenduse
	deklareerimine oleks viga. Järgnevalt on illustreeritud vea esinemist EA
	andmebaasi disaini mudelis. PK veeru nime ees näitab, et veerg kuulub
	primaarvõtmesse. Veeru allajoonimine näitab, et see veerg kuulub UNIQUE
	kitsendusse
* Välisvõtmete puhul tuleb määrata sobivad kompenseerivad tegevused.
	* Kui välisvõti viitab sisulise tähendusega võtmele (klassifikaatori kood,
		isikukood, auto registrikood, dokumendi number, üliõpilaskood, ...), siis
		ON UPDATE CASCADE.
	◦ Kui välisvõtme poolt realiseeritava seosetüübi korral on püstitatud
		reegel, et vanema andmete kustutamisel peavad selle laste andmed
		säilima, siis on sobiv määrang ON DELETE SET NULL.
	◦ Kõigil ülejäänud juhtudel sobib vaikimisi määrang ON UPDATE/DELETE NO ACTION.
* Tüüpide ümbernimetamisest veel ül2 page 25
* Vaikimsväärtused 26 - 28

ÜLESANNE 3 notes
* EA ei kontrolli CHECK kitsenduste avaldisi

* kui Teie andmebaasis on näiteks veerg hind,
kuhu saab lisada negatiivseid väärtuseid, siis miinuspunktide eest
ei saa kõrvale põigata väitega, et "Kontseptuaalses
andmemudelis polnud seda piiravat kitsendust kirja pandud". See
kitsendus peab olema seal ja peab olema Teie andmebaasis.
* Kui veerus peab olema alati väärtus, siis selle tagamiseks tuleb
veerule defineerida NOT NULL kitsendus. Eraldi CHECK
kitsendust selleks vaja ei ole.
* Ärge defineerige ühte ja sama kitsendust mitu korda
* Ärge jõustage üksteisega vastuolus olevaid kitsendusi
* Välisvõtme veergudes pole vaja korrata viidatud kandidaatvõtme
veergudele jõustatud kitsendusi. Välisvõti tähendab, et selle väärtus
peab olema üks kandidaatvõtme väärtustest.

kitsendused dokumendis:
* riik kood - lk 5
* e-meil - lk 6
* isikukood - lk 7
* parool, reg_aeg - lk 10
* reg_avaldised - lk 14

kontseptuaalne andmemudel - MAIN DOCUMENT
Registreerimine on kohustuslik == NOT NULL
PK must be unique

!!!!!!auto reg_number "ei tohi leiduda" Pole check kitsendusega realiseeritav. Siis kui tuleb ÜL4, määrata unikaalne indeks vms, küsida Erki käest
* isik e_meil punane? ül10 kustutada veerule e-mail unique kitsenduse, ja luua unique indexi 
<> is more correct version of !=

http://apex.ttu.ee/phppgadmin/ regex kontroll (PostgreSQL -> t<matriklinumber>, parool (Mis oli Erki-le saadetud) -> random DB -> SQL tab -> remove checkmark Paginate results)

* Klassifikaator nimetus - V


* Riik kas on "pole tyhi" checki vaja, kui on chk kolmest suurtahest? -??

ÜLESANNE 4