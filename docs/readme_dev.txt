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

ÜLESANNE 4:

CODE GENERATION STEPS:
	* Genereeri kood:
		* klikki DDL_PostgreSQL paketi peale
		* vali Package -> Database engineering -> Generate package dll...
		* tiki Include all child packages
		* paiguta õigesse järjekorda (ülesanne 4 lk 8)
		* genereeri (pigem tekita uue faili)
	* Genereeritud failis:
		* eemalda "
		* faili alguses kirjuta: START TRASACTION;
		* faili lõpus kirjuta: COMMIT;
		* lisa fillfactor laused peale vastava tabeli CREATE lause:
		
			esimene meetod:
ALTER TABLE public.amet SET (FILLFACTOR=90)
;
ALTER TABLE public.isik SET (FILLFACTOR=90)
;
ALTER TABLE public.klient SET (FILLFACTOR=90)
;
ALTER TABLE public.tootaja SET (FILLFACTOR=90)
;
ALTER TABLE public.auto SET (FILLFACTOR=90)
;
			teine meetod:
CREATE TABLE Ruum (
...
) WITH (fillfactor=90);

		* lisa unique indexid Auto ja Isiku tabelite loomise alla:
CREATE UNIQUE INDEX AK_Isik_e_meil_tostutundetud ON Isik (Lower(e_meil))
;
CREATE UNIQUE INDEX AK_Auto_reg_number_aktiivne ON Auto (reg_number) WHERE auto_seisundi_liik_kood = 2
;

upload db: apex.ttu.ee/phppgadmin -> postgre -> oma matrikkel -> SQL -> linnuke maha -> execute
check here: apex.ttu.ee/queries2 -> matrikkel -> select test -> suur nupp
	Test name : errors : seconds
	* Classroom
		Quick test : 25 : 40
		Databases II (fall 2019) : 71 : 50
	* Home1
		Quick test : 12 : 40
		Databases II (fall 2019) : 62 : 50
	* Home3
		Quick test: 12 : 30
		Databases II (fall 2019) : 66 : 38
	* Home4 (yl4 parandused sisse viidud)
		Quick test: 10 : 10
		Databases II (fall 2019) : 74 : 18

MS ACCESS

yl9 - http://apex.ttu.ee/pgapex2/public/index.php/app/8/22 lucile.burgess@frolix.net laborum 
query: create -> Query design -> close -> pass through -> property sheet -> odbc määrata (kolm punkti) -> korras

PGADMIN LOCAL PROGRAM
	* how to add remote apex server with local pgadmin:
		* name: PostgreSQL
		* host: apex.ttu.ee
		* port: 5432
		* db: t192406
		* use SSH and all of the settings there
	* how to backup:
		* right click on db -> Backup...
		* Format: Plain
		* Encoding UTF8
		* Dump options:
			* Deselect:
				* Blobs
			* Select:
				* Use column inserts
				* Use insert commands
		* Execute
		* Replace "public." with ""
		* Find your INSERT statements
				
remote backup (puuduvad insert laused):
pg_dump -C -f t192406_kuupaev.sql t192406

AUTO seisundid:
1 - ootel
2 - aktiivne
3 - mitteaktiivne
4 - lõpetatud

ÜL6 notes:
	important stuff pages:
		* 6, näited
		* 10, alter domain, add constraints
		
ÜL7 notes, vaated:
vaja commentida
vaja luua väh 3 vaadet
vaja kasutada virtuaalsete andmete kihi
lk 10 kuidas luua

create view what to replace if taking select clauses from ms access prototype db Queries section:
check that query names are not the same (table names are cut off on execution)
auto.isik_id -> registreerija_id
auto_kytuse_liik.kytuse_liik_id -> auto_kytuse_liik_kood
auto.auto_kytuse_liik -> auto_kytuse_liik_kood
auto.auto_seisundi_liik -> auto_seisundi_liik_kood
valjalaskeaasta -> valjalaske_aasta

ÜL8 notes
* vähemalt kolm
funktsiooni/protseduuri (rutiini), mis pole seotud trigeriga.
* Töövihiku järgi projekti tegijad peavad juhataja töökoha jaoks realiseerima
ainult ühe seisundimuudatuse protseduuri/funktsiooni.
* funktsiooni muutuja algab "p_"-ga

ÜL10 notes, triggers:
* vähemalt 2
* lähtuda projekti töövihikust "registri põhiobjekti seisundidiagramm"
peameeles:
	* Rakenduse võimaldatavad seisundimuudatused ei lange üks-ühele kokku projektis ettenähtuga
	* Rakendus lubab teha seisundimuudatusi, mida projekt ette ei näe.
page 3: juhul kui lihtne (ülimalt 2 seisundit), teha veel, konsulteerida Erki-ga

* Järgnevalt esitan veel ühe trigerite idee. X andmete hulgas on selliseid,
mida peale X eksemplari registreerimist ei peaks saama muuta. Mõtlen siin
andmeid, kes oli X eksemplari registreerija ning milline oli registreerimise
aeg. Tabeli X veergudele reg_aeg ja registreerija_id (võibolla on Teie tabelis
teistusugune nimi) saab luua BEFORE UPDATE reataseme trigeri, mis
andmete muutmisel nendes veergudes asendab uue väärtuse automaatsel
vana väärtusega (nt NEW.reg_aeg:=OLD.reg_aeg).

Ootel => Aktiivne
Aktiivne => Mitteaktiivne
Aktiivne => Lõpetatud
Mitteaktiivne => Aktiivne
Mitteaktiivne => Lõpetatud


* refreshing
* kuidas viidata kui muudad midagi vt materjale

* 4.19.3, kas tuleb alguses kõik foreign key'id eemaldada, või ainult need, mis on arvujada genereerimisega seotud (e serialid)?
	(meil eemaldatakse kõik) timmis
	
	ei ole vaja
* õiguste jagamise osas, kas tuleb anda õigused kasutajale otseselt tabelite jaoks?
ehk:
	GRANT SELECT, UPDATE ON TABLE
	Vastuvott
	TO oppejoud_vastuvotud;
	GRANT SELECT, INSERT, UPDATE ON TABLE
	Vastuvotuaeg
	TO oppejoud_vastuvotud;

* joonis 14

KÜSIDA:
-

TO CHANGE:
v amet zamenitj text type na 
kirjeldus varchar(1000),