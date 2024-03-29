START TRANSACTION;

REVOKE CONNECT ON DATABASE t192406 FROM t192406_autorendi_juhataja;

REVOKE USAGE ON SCHEMA public FROM t192406_autorendi_juhataja;

REVOKE EXECUTE ON FUNCTION
f_lopeta_auto(p_auto_kood Auto.auto_kood%TYPE),
f_autendi_juhataja(p_e_meil text, p_parool text)
FROM t192406_autorendi_juhataja;

REVOKE SELECT ON
Aktiivsed_ja_mitteaktiivsed_autod,
Autode_kategooriate_omamine,
Autode_detailid,
Autode_koondaruanne
FROM t192406_autorendi_juhataja;

DROP DOMAIN IF EXISTS d_nimetus CASCADE;
DROP DOMAIN IF EXISTS d_reg_aeg CASCADE;

ALTER TABLE IF EXISTS Auto_kategooria DROP CONSTRAINT IF EXISTS FK_Auto_kategooria_Auto_kategooria_tyyp;
ALTER TABLE IF EXISTS Isik DROP CONSTRAINT IF EXISTS FK_Isik_Isiku_seisundi_liik;
ALTER TABLE IF EXISTS Isik DROP CONSTRAINT IF EXISTS FK_Isik_Riik;
ALTER TABLE IF EXISTS Klient DROP CONSTRAINT IF EXISTS FK_Klient_Kliendi_seisundi_liik;
ALTER TABLE IF EXISTS Klient DROP CONSTRAINT IF EXISTS FK_Klient_Isik;
ALTER TABLE IF EXISTS Tootaja DROP CONSTRAINT IF EXISTS FK_Tootaja_Tootaja;
ALTER TABLE IF EXISTS Tootaja DROP CONSTRAINT IF EXISTS FK_Tootaja_Amet;
ALTER TABLE IF EXISTS Tootaja DROP CONSTRAINT IF EXISTS FK_Tootaja_Tootaja_seisundi_liik;
ALTER TABLE IF EXISTS Tootaja DROP CONSTRAINT IF EXISTS FK_Tootaja_Isik;
ALTER TABLE IF EXISTS Auto DROP CONSTRAINT IF EXISTS FK_Auto_Auto_mark;
ALTER TABLE IF EXISTS Auto DROP CONSTRAINT IF EXISTS FK_Auto_Auto_kytuse_liik;
ALTER TABLE IF EXISTS Auto DROP CONSTRAINT IF EXISTS FK_Auto_Auto_seisundi_liik;
ALTER TABLE IF EXISTS Auto DROP CONSTRAINT IF EXISTS FK_Auto_Tootaja;
ALTER TABLE IF EXISTS Auto_kategooria_omamine DROP CONSTRAINT IF EXISTS FK_Auto_kategooria_omamine_Auto;
ALTER TABLE IF EXISTS Auto_kategooria_omamine DROP CONSTRAINT IF EXISTS FK_Auto_kategooria_omamine_Auto_kategooria;

DROP TABLE IF EXISTS Auto_kategooria_tyyp CASCADE;
DROP TABLE IF EXISTS Auto_kategooria CASCADE;
DROP TABLE IF EXISTS Auto_mark CASCADE;
DROP TABLE IF EXISTS Auto_kytuse_liik CASCADE;
DROP TABLE IF EXISTS Auto_seisundi_liik CASCADE;
DROP TABLE IF EXISTS Isiku_seisundi_liik CASCADE;
DROP TABLE IF EXISTS Kliendi_seisundi_liik CASCADE;
DROP TABLE IF EXISTS Tootaja_seisundi_liik CASCADE;
DROP TABLE IF EXISTS Riik CASCADE;
DROP TABLE IF EXISTS Amet CASCADE;
DROP TABLE IF EXISTS Isik CASCADE;
DROP TABLE IF EXISTS Klient CASCADE;
DROP TABLE IF EXISTS Tootaja CASCADE;
DROP TABLE IF EXISTS Auto CASCADE;
DROP TABLE IF EXISTS Auto_kategooria_omamine CASCADE;

DROP FOREIGN TABLE IF EXISTS Riik_jsonb CASCADE;
DROP FOREIGN TABLE IF EXISTS Isik_jsonb CASCADE;
DROP USER MAPPING FOR t192406 SERVER minu_testandmete_server_apex;
DROP SERVER IF EXISTS minu_testandmete_server_apex CASCADE;

DROP VIEW IF EXISTS Aktiivsed_ja_mitteaktiivsed_autod CASCADE;
DROP VIEW IF EXISTS Autode_kategooriate_omamine CASCADE;
DROP VIEW IF EXISTS Autode_detailid CASCADE;
DROP VIEW IF EXISTS Autode_koondaruanne CASCADE;

DROP INDEX IF EXISTS IXFK_Isik_Isiku_seisundi_liik;
DROP INDEX IF EXISTS IXFK_Isik_Riik;
DROP INDEX IF EXISTS IXFK_Klient_Kliendi_seisundi_liik;
DROP INDEX IF EXISTS IXFK_Tootaja_Amet;
DROP INDEX IF EXISTS IXFK_Tootaja_Tootaja;
DROP INDEX IF EXISTS IXFK_Tootaja_Tootaja_seisundi_liik;
DROP INDEX IF EXISTS IXFK_Auto_Auto_kytuse_liik;
DROP INDEX IF EXISTS IXFK_Auto_Auto_mark;
DROP INDEX IF EXISTS IXFK_Auto_Auto_seisundi_liik;
DROP INDEX IF EXISTS IXFK_Auto_Tootaja;
DROP INDEX IF EXISTS IXFK_Auto_kategooria_omamine_Auto_kategooria;

DROP INDEX IF EXISTS AK_Isik_e_meil_tostutundetud;
DROP INDEX IF EXISTS AK_Auto_reg_number_aktiivne;

DROP FUNCTION IF EXISTS f_aktiveeri_auto(p_auto_kood Auto.auto_kood%TYPE) CASCADE;
DROP FUNCTION IF EXISTS f_muuda_auto_mitteaktiivseks(p_auto_kood Auto.auto_kood%TYPE) CASCADE;
DROP FUNCTION IF EXISTS f_lopeta_auto(p_auto_kood Auto.auto_kood%TYPE) CASCADE;
DROP FUNCTION IF EXISTS f_autendi_juhataja(p_e_meil text, p_parool text) CASCADE;
DROP FUNCTION IF EXISTS TGF_auto_i() CASCADE;
DROP FUNCTION IF EXISTS TGF_auto_u() CASCADE;

DROP TRIGGER IF EXISTS TG_auto_i ON Auto CASCADE;
DROP TRIGGER IF EXISTS TG_auto_u ON Auto CASCADE;

DROP USER IF EXISTS t192406_autorendi_juhataja;

DROP EXTENSION IF EXISTS pgcrypto CASCADE;
DROP EXTENSION IF EXISTS postgres_fdw CASCADE;










SET client_encoding=LATIN9;

CREATE DOMAIN d_nimetus VARCHAR(50) NOT NULL
CONSTRAINT chk_nimetus_pole_tyhi CHECK (VALUE!~'^[[:space:]]*$');

CREATE DOMAIN d_reg_aeg timestamp NOT NULL DEFAULT LOCALTIMESTAMP(0)
CONSTRAINT chk_reg_aeg_on_vahemikus
CHECK ((VALUE >= '2010-01-01') AND (VALUE < '2101-01-01'));

CREATE TABLE Auto_kategooria_tyyp(
auto_kategooria_tyyp_kood smallint NOT NULL,
nimetus varchar(50) NOT NULL,
CONSTRAINT PK_Auto_kategooria_tyyp PRIMARY KEY (auto_kategooria_tyyp_kood),
CONSTRAINT AK_Auto_kategooria_tyyp_nimetus UNIQUE (nimetus),
CONSTRAINT CHK_Auto_kategooria_tyyp_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
);

CREATE TABLE Auto_kategooria(
auto_kategooria_kood smallint NOT NULL,
nimetus varchar(50) NOT NULL,
auto_kategooria_tyyp_kood smallint NOT NULL,
CONSTRAINT PK_Auto_kategooria PRIMARY KEY (auto_kategooria_kood),
CONSTRAINT AK_Auto_kategooria_auto_kategooria_tyyp_ja_nimetus UNIQUE (auto_kategooria_tyyp_kood,nimetus),
CONSTRAINT CHK_Auto_kategooria_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$'),
CONSTRAINT FK_Auto_kategooria_Auto_kategooria_tyyp FOREIGN KEY (auto_kategooria_tyyp_kood) REFERENCES Auto_kategooria_tyyp (auto_kategooria_tyyp_kood) ON DELETE No Action ON UPDATE Cascade
);

CREATE TABLE Auto_mark(
auto_mark_kood smallint NOT NULL,
nimetus varchar(50) NOT NULL,
CONSTRAINT PK_Auto_mark PRIMARY KEY (auto_mark_kood),
CONSTRAINT AK_Auto_mark_nimetus UNIQUE (nimetus),
CONSTRAINT CHK_Auto_mark_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
);

CREATE TABLE Auto_kytuse_liik(
auto_kytuse_liik_kood smallint NOT NULL,
nimetus varchar(50) NOT NULL,
CONSTRAINT PK_Auto_kytuse_liik PRIMARY KEY (auto_kytuse_liik_kood),
CONSTRAINT AK_Auto_kytuse_liik_nimetus UNIQUE (nimetus),
CONSTRAINT CHK_Auto_kytuse_liik_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
);

CREATE TABLE Auto_seisundi_liik(
auto_seisundi_liik_kood smallint NOT NULL,
nimetus varchar(50) NOT NULL,
CONSTRAINT PK_Auto_seisundi_liik PRIMARY KEY (auto_seisundi_liik_kood),
CONSTRAINT AK_Auto_seisundi_liik_nimetus UNIQUE (nimetus),
CONSTRAINT CHK_Auto_seisundi_liik_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
);
CREATE TABLE Isiku_seisundi_liik(
isiku_seisundi_liik_kood smallint NOT NULL,
nimetus varchar(50) NOT NULL,
CONSTRAINT PK_Isiku_seisundi_liik PRIMARY KEY (isiku_seisundi_liik_kood),
CONSTRAINT AK_Isiku_seisundi_liik_nimetus UNIQUE (nimetus),
CONSTRAINT CHK_Isiku_seisundi_liik_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
);

CREATE TABLE Kliendi_seisundi_liik(
kliendi_seisundi_liik_kood smallint NOT NULL,
nimetus varchar(50) NOT NULL,
CONSTRAINT PK_Kliendi_seisundi_liik PRIMARY KEY (kliendi_seisundi_liik_kood),
CONSTRAINT AK_Kliendi_seisundi_liik_nimetus UNIQUE (nimetus),
CONSTRAINT CHK_Kliendi_seisundi_liik_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
);

CREATE TABLE Tootaja_seisundi_liik(
tootaja_seisundi_liik_kood smallint NOT NULL,
nimetus varchar(50) NOT NULL,
CONSTRAINT PK_Tootaja_seisundi_liik PRIMARY KEY (tootaja_seisundi_liik_kood),
CONSTRAINT AK_Tootaja_seisundi_liik_nimetus UNIQUE (nimetus),
CONSTRAINT CHK_Tootaja_seisundi_liik_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
);

CREATE TABLE Riik(
riik_kood varchar(3) NOT NULL,
nimetus varchar(90) NOT NULL,
CONSTRAINT PK_Riik PRIMARY KEY (riik_kood),
CONSTRAINT AK_Riik_nimetus UNIQUE (nimetus),
CONSTRAINT CHK_Riik_riik_kood_kolmest_suurtahest CHECK (riik_kood ~ '^[A-Z]{3}$'),
CONSTRAINT CHK_Riik_riik_kood_pole_tyhi CHECK (riik_kood!~'^[[:space:]]*$'),
CONSTRAINT CHK_Riik_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
);

CREATE TABLE Amet(
amet_kood smallint NOT NULL,
nimetus varchar(50) NOT NULL,
kirjeldus varchar(1000),
CONSTRAINT PK_Amet PRIMARY KEY (amet_kood),
CONSTRAINT AK_Amet_nimetus UNIQUE (nimetus),
CONSTRAINT CHK_Amet_kirjeldus_pole_tyhi CHECK (kirjeldus!~'^[[:space:]]*$'),
CONSTRAINT CHK_Amet_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
)WITH (FILLFACTOR=90);

CREATE TABLE Isik(
isik_id serial NOT NULL,
isikukood varchar(50) NOT NULL,
riik_kood varchar(3) NOT NULL,
e_meil varchar(254) NOT NULL,
isiku_seisundi_liik_kood smallint NOT NULL   DEFAULT 1,
synni_kp date NOT NULL,
parool varchar(60) NOT NULL,
reg_aeg timestamp NOT NULL   DEFAULT LOCALTIMESTAMP(0),
eesnimi varchar(1500),
perenimi varchar(1000),
elukoht varchar(120),
CONSTRAINT PK_Isik PRIMARY KEY (isik_id),
CONSTRAINT AK_Isik_isikukood_ja_riik_kood UNIQUE (isikukood,riik_kood),
CONSTRAINT CHK_Isik_isikukood_pole_tyhi CHECK (isikukood!~'^[[:space:]]*$'),
CONSTRAINT CHK_Isik_isikukood_ainult_lubatud_symbolid CHECK (isikukood ~ '^([[:alpha:]]|[[:digit:]]|[[:space:]]|-|\+|=|\\|\/)*$'),
CONSTRAINT CHK_Isik_eesnimi_voi_perenimi_olemas CHECK ((eesnimi IS NOT NULL) OR (perenimi IS NOT NULL)),
CONSTRAINT CHK_Isik_eesnimi_pole_tyhi CHECK (eesnimi!~'^[[:space:]]*$'),
CONSTRAINT CHK_Isik_perenimi_pole_tyhi CHECK (perenimi!~'^[[:space:]]*$'),
CONSTRAINT CHK_Isik_synni_kp_on_vahemikus CHECK ((synni_kp >= '1900-01-01') AND (synni_kp < '2101-01-01')),
CONSTRAINT CHK_Isik_synni_kp_pole_suurem_reg_ajast CHECK (synni_kp <= reg_aeg),
CONSTRAINT CHK_Isik_elukoht_pole_tyhi CHECK (elukoht!~'^[[:space:]]*$'),
CONSTRAINT CHK_Isik_elukoht_pole_ainult_numbritest CHECK (elukoht!~'^[[:digit:]]*$'),
CONSTRAINT CHK_Isik_e_meil_sisaldab_tapselt_uhe_at_marki CHECK (e_meil ~ '^[^@]*@[^@]*$'),
CONSTRAINT CHK_Isik_reg_aeg_on_vahemikus CHECK ((reg_aeg >= '2010-01-01') AND (reg_aeg < '2101-01-01')),
CONSTRAINT FK_Isik_Isiku_seisundi_liik FOREIGN KEY (isiku_seisundi_liik_kood) REFERENCES Isiku_seisundi_liik (isiku_seisundi_liik_kood) ON DELETE No Action ON UPDATE Cascade,
CONSTRAINT FK_Isik_Riik FOREIGN KEY (riik_kood) REFERENCES Riik (riik_kood) ON DELETE No Action ON UPDATE Cascade
)WITH (FILLFACTOR=90);

CREATE TABLE Klient(
isik_id integer NOT NULL,
kliendi_seisundi_liik_kood smallint NOT NULL   DEFAULT 1,
on_nous_tylitamisega boolean NOT NULL   DEFAULT FALSE,
CONSTRAINT PK_Klient PRIMARY KEY (isik_id),
CONSTRAINT FK_Klient_Kliendi_seisundi_liik FOREIGN KEY (kliendi_seisundi_liik_kood) REFERENCES Kliendi_seisundi_liik (kliendi_seisundi_liik_kood) ON DELETE No Action ON UPDATE Cascade,
CONSTRAINT FK_Klient_Isik FOREIGN KEY (isik_id) REFERENCES Isik (isik_id) ON DELETE Cascade ON UPDATE No Action
)WITH (FILLFACTOR=90);

CREATE TABLE Tootaja(
isik_id integer NOT NULL,
amet_kood smallint NOT NULL,
tootaja_seisundi_liik_kood smallint NOT NULL   DEFAULT 1,
mentor integer,
CONSTRAINT PK_Tootaja PRIMARY KEY (isik_id),
CONSTRAINT CHK_Tootaja_pole_enda_mentor CHECK (mentor <> isik_id),
CONSTRAINT FK_Tootaja_Tootaja FOREIGN KEY (mentor) REFERENCES Tootaja (isik_id) ON DELETE Set Null ON UPDATE No Action,
CONSTRAINT FK_Tootaja_Amet FOREIGN KEY (amet_kood) REFERENCES Amet (amet_kood) ON DELETE No Action ON UPDATE Cascade,
CONSTRAINT FK_Tootaja_Tootaja_seisundi_liik FOREIGN KEY (tootaja_seisundi_liik_kood) REFERENCES Tootaja_seisundi_liik (tootaja_seisundi_liik_kood) ON DELETE No Action ON UPDATE Cascade,
CONSTRAINT FK_Tootaja_Isik FOREIGN KEY (isik_id) REFERENCES Isik (isik_id) ON DELETE Cascade ON UPDATE No Action
)WITH (FILLFACTOR=90);

CREATE TABLE Auto(
auto_kood integer NOT NULL,
nimetus varchar(50) NOT NULL,
mudel varchar(100) NOT NULL,
valjalaske_aasta smallint NOT NULL,
reg_number varchar(9) NOT NULL,
istekohtade_arv smallint NOT NULL,
mootori_maht decimal(3,1) NOT NULL,
vin_kood varchar(17) NOT NULL,
reg_aeg timestamp NOT NULL   DEFAULT LOCALTIMESTAMP(0),
registreerija_id integer NOT NULL,
auto_kytuse_liik_kood smallint NOT NULL,
auto_seisundi_liik_kood smallint NOT NULL   DEFAULT 1,
auto_mark_kood smallint NOT NULL,
CONSTRAINT PK_Auto PRIMARY KEY (auto_kood),
CONSTRAINT AK_Auto_vin_kood UNIQUE (vin_kood),
CONSTRAINT AK_Auto_nimetus UNIQUE (nimetus),
CONSTRAINT CHK_Auto_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$'),
CONSTRAINT CHK_Auto_reg_aeg_on_vahemikus CHECK ((reg_aeg >= '2010-01-01') AND (reg_aeg < '2101-01-01')),
CONSTRAINT CHK_Auto_valjalaske_aasta_on_vahemikus CHECK (valjalaske_aasta >= 2000 AND
valjalaske_aasta <= 2100),
CONSTRAINT CHK_Auto_istekohtade_arv_on_vahemikus CHECK (istekohtade_arv >= 2 AND
istekohtade_arv <= 11),
CONSTRAINT CHK_Auto_mudel_pole_tyhi CHECK (mudel!~'^[[:space:]]*$'),
CONSTRAINT CHK_Auto_mootori_maht_on_positiivne CHECK (mootori_maht >= 0),
CONSTRAINT CHK_Auto_reg_number_pole_tyhi CHECK (reg_number!~'^[[:space:]]*$'),
CONSTRAINT CHK_Auto_reg_number_min_pikkus CHECK (LENGTH(reg_number) >= 2),
CONSTRAINT CHK_Auto_reg_number_ainult_suurtahed_ja_numbrid CHECK (reg_number ~ '^([[:upper:]]|[[:digit:]])*$'),
CONSTRAINT CHK_Auto_reg_number_muster CHECK (reg_number ~ '^([[:digit:]]{2}|[[:digit:]]{3})[[:upper:]]{3}$' OR reg_number ~ '^[[:upper:]]+[[:digit:]]+$'),
CONSTRAINT CHK_Auto_vin_kood_min_pikkus CHECK (LENGTH(vin_kood) >= 11),
CONSTRAINT CHK_Auto_vin_kood_ainult_suurtahed_ja_numbrid CHECK (vin_kood ~ '^([[:upper:]]|[[:digit:]])*$'),
CONSTRAINT FK_Auto_Auto_mark FOREIGN KEY (auto_mark_kood) REFERENCES Auto_mark (auto_mark_kood) ON DELETE No Action ON UPDATE Cascade,
CONSTRAINT FK_Auto_Auto_kytuse_liik FOREIGN KEY (auto_kytuse_liik_kood) REFERENCES Auto_kytuse_liik (auto_kytuse_liik_kood) ON DELETE No Action ON UPDATE Cascade,
CONSTRAINT FK_Auto_Auto_seisundi_liik FOREIGN KEY (auto_seisundi_liik_kood) REFERENCES Auto_seisundi_liik (auto_seisundi_liik_kood) ON DELETE No Action ON UPDATE Cascade,
CONSTRAINT FK_Auto_Tootaja FOREIGN KEY (registreerija_id) REFERENCES Tootaja (isik_id) ON DELETE No Action ON UPDATE No Action
)WITH (FILLFACTOR=90);

CREATE TABLE Auto_kategooria_omamine(
auto_kood integer NOT NULL,
auto_kategooria_kood smallint NOT NULL,
CONSTRAINT PK_Auto_kategooria_omamine PRIMARY KEY (auto_kood,auto_kategooria_kood),
CONSTRAINT FK_Auto_kategooria_omamine_Auto FOREIGN KEY (auto_kood) REFERENCES Auto (auto_kood) ON DELETE Cascade ON UPDATE Cascade,
CONSTRAINT FK_Auto_kategooria_omamine_Auto_kategooria FOREIGN KEY (auto_kategooria_kood) REFERENCES Auto_kategooria (auto_kategooria_kood) ON DELETE No Action ON UPDATE Cascade
);

/*Kustutan veeruga seotud CHECK kitsendused, sest need
määratakse edaspidi domeeni kaudu*/
ALTER TABLE Auto_kategooria_tyyp DROP CONSTRAINT IF EXISTS CHK_Auto_kategooria_tyyp_nimetus_pole_tyhi;
ALTER TABLE Auto_kategooria DROP CONSTRAINT IF EXISTS CHK_Auto_kategooria_nimetus_pole_tyhi;
ALTER TABLE Auto_mark DROP CONSTRAINT IF EXISTS CHK_Auto_mark_nimetus_pole_tyhi;
ALTER TABLE Auto_kytuse_liik DROP CONSTRAINT IF EXISTS CHK_Auto_kytuse_liik_nimetus_pole_tyhi;
ALTER TABLE Auto_seisundi_liik DROP CONSTRAINT IF EXISTS CHK_Auto_seisundi_liik_nimetus_pole_tyhi;
ALTER TABLE Isiku_seisundi_liik DROP CONSTRAINT IF EXISTS CHK_Isiku_seisundi_liik_nimetus_pole_tyhi;
ALTER TABLE Kliendi_seisundi_liik DROP CONSTRAINT IF EXISTS CHK_Kliendi_seisundi_liik_nimetus_pole_tyhi;
ALTER TABLE Tootaja_seisundi_liik DROP CONSTRAINT IF EXISTS CHK_Tootaja_seisundi_liik_nimetus_pole_tyhi;
ALTER TABLE Amet DROP CONSTRAINT IF EXISTS CHK_Amet_nimetus_pole_tyhi;
ALTER TABLE Auto DROP CONSTRAINT IF EXISTS CHK_Auto_nimetus_pole_tyhi;
/*Kustutan veeruga seotud NOT NULL kitsenduse, sest see
määratakse edaspidi domeeni kaudu*/
ALTER TABLE Auto_kategooria_tyyp ALTER COLUMN nimetus DROP NOT NULL;
ALTER TABLE Auto_kategooria ALTER COLUMN nimetus DROP NOT NULL;
ALTER TABLE Auto_mark ALTER COLUMN nimetus DROP NOT NULL;
ALTER TABLE Auto_kytuse_liik ALTER COLUMN nimetus DROP NOT NULL;
ALTER TABLE Auto_seisundi_liik ALTER COLUMN nimetus DROP NOT NULL;
ALTER TABLE Isiku_seisundi_liik ALTER COLUMN nimetus DROP NOT NULL;
ALTER TABLE Kliendi_seisundi_liik ALTER COLUMN nimetus DROP NOT NULL;
ALTER TABLE Tootaja_seisundi_liik ALTER COLUMN nimetus DROP NOT NULL;
ALTER TABLE Amet ALTER COLUMN nimetus DROP NOT NULL;
ALTER TABLE Auto ALTER COLUMN nimetus DROP NOT NULL;
/*Määran, et veeru omadused on määratud domeeniga*/
ALTER TABLE Auto_kategooria_tyyp ALTER COLUMN nimetus TYPE d_nimetus;
ALTER TABLE Auto_kategooria ALTER COLUMN nimetus TYPE d_nimetus;
ALTER TABLE Auto_mark ALTER COLUMN nimetus TYPE d_nimetus;
ALTER TABLE Auto_kytuse_liik ALTER COLUMN nimetus TYPE d_nimetus;
ALTER TABLE Auto_seisundi_liik ALTER COLUMN nimetus TYPE d_nimetus;
ALTER TABLE Isiku_seisundi_liik ALTER COLUMN nimetus TYPE d_nimetus;
ALTER TABLE Kliendi_seisundi_liik ALTER COLUMN nimetus TYPE d_nimetus;
ALTER TABLE Tootaja_seisundi_liik ALTER COLUMN nimetus TYPE d_nimetus;
ALTER TABLE Amet ALTER COLUMN nimetus TYPE d_nimetus;
ALTER TABLE Auto ALTER COLUMN nimetus TYPE d_nimetus;


/*Kustutan veeruga seotud CHECK kitsendused, sest need
määratakse edaspidi domeeni kaudu*/
ALTER TABLE Isik DROP CONSTRAINT IF EXISTS CHK_Isik_reg_aeg_on_vahemikus;
ALTER TABLE Auto DROP CONSTRAINT IF EXISTS CHK_Auto_reg_aeg_on_vahemikus;
/*Kustutan veeruga seotud NOT NULL kitsenduse, sest see
määratakse edaspidi domeeni kaudu*/
ALTER TABLE Isik ALTER COLUMN reg_aeg DROP NOT NULL;
ALTER TABLE Auto ALTER COLUMN reg_aeg DROP NOT NULL;
/*Kustutan veeruga seotud vaikimisi väärtuse, sest see
määratakse edaspidi domeeni kaudu*/
ALTER TABLE Isik ALTER COLUMN reg_aeg DROP DEFAULT;
ALTER TABLE Auto ALTER COLUMN reg_aeg DROP DEFAULT;
/*Määran, et veeru omadused on määratud domeeniga*/
ALTER TABLE Isik ALTER COLUMN reg_aeg TYPE d_reg_aeg;
ALTER TABLE Auto ALTER COLUMN reg_aeg TYPE d_reg_aeg;


CREATE OR REPLACE VIEW Aktiivsed_ja_mitteaktiivsed_autod WITH (security_barrier) AS
SELECT Auto.auto_kood, Auto.nimetus AS auto_nimetus, Auto_seisundi_liik.nimetus AS hetke_seisund, Auto_mark.nimetus AS mark, Auto.mudel, Auto.valjalaske_aasta, Auto.reg_number, Auto.vin_kood
FROM Auto
INNER JOIN Auto_mark ON Auto_mark.auto_mark_kood = Auto.auto_mark_kood
INNER JOIN Auto_seisundi_liik ON Auto_seisundi_liik.auto_seisundi_liik_kood = Auto.auto_seisundi_liik_kood
WHERE ((Auto.auto_seisundi_liik_kood) IN (2,3))
ORDER BY hetke_seisund, Auto.auto_kood;

COMMENT ON VIEW Aktiivsed_ja_mitteaktiivsed_autod IS 'Vaade, mis kuvab aktiivsete või mitteaktiivsete autode nimekirja, kus on kood, nimetus, hetkeseisundi nimetus, mark, mudel, valjalaske_aasta, reg_number, vin_kood. Vaade on mõeldud kasutamiseks juhatajale, kes soovib auto kasutamist lõpetada. Vaade realiseerib operatsiooni OP9.1.';

CREATE OR REPLACE VIEW Autode_kategooriate_omamine WITH (security_barrier) AS
SELECT Auto_kategooria_omamine.auto_kood, CONCAT(Auto_kategooria.nimetus, ' (', Auto_kategooria_tyyp.nimetus, ')') AS kategooria
FROM Auto_kategooria_omamine
INNER JOIN Auto_kategooria ON Auto_kategooria_omamine.auto_kategooria_kood = Auto_kategooria.auto_kategooria_kood
INNER JOIN Auto_kategooria_tyyp ON Auto_kategooria.auto_kategooria_tyyp_kood = Auto_kategooria_tyyp.auto_kategooria_tyyp_kood
ORDER BY kategooria;

COMMENT ON VIEW Autode_kategooriate_omamine IS 'Vaade, mis kuvab autode kategooriate ja kategooriate tüüpide nimetused (auto_kood, kategooria_nimetus(kategooria_tyyp_nimetus)). Vaade on mõeldud kasutamiseks juhatajale või autode haldurile, kes tahab mingil põhjusel vaadata autode detailseid andmeid. Vaade realiseerib operatsiooni OP2.2.';

CREATE OR REPLACE VIEW Autode_detailid WITH (security_barrier) AS
SELECT Auto.auto_kood, Auto.nimetus AS auto_nimetus, Auto_mark.nimetus AS mark, Auto.mudel, Auto.valjalaske_aasta, Auto.mootori_maht, Auto_kytuse_liik.nimetus AS kytuse_liik, Auto.istekohtade_arv, Auto.reg_number, Auto.vin_kood, Auto.reg_aeg, CONCAT_WS(' ' ,Isik.eesnimi, Isik.perenimi, Isik.e_meil) AS registreerija, Auto_seisundi_liik.nimetus AS hetke_seisund
FROM Auto
INNER JOIN Auto_mark ON Auto_mark.auto_mark_kood = Auto.auto_mark_kood
INNER JOIN Auto_kytuse_liik ON Auto_kytuse_liik.auto_kytuse_liik_kood = Auto.auto_kytuse_liik_kood
INNER JOIN Auto_seisundi_liik ON Auto_seisundi_liik.auto_seisundi_liik_kood = Auto.auto_seisundi_liik_kood
INNER JOIN Isik ON Isik.isik_id = Auto.registreerija_id
ORDER BY Auto.auto_kood;

COMMENT ON VIEW Autode_detailid IS 'Vaade, mis kuvab vaatamiseks mõeldud väljades auto põhiandmed (auto_kood, nimetus, mark, mudel, valjalaske_aasta, mootori_maht, auto_kütuse_liik, istekohtade_arv, reg_number, vin_kood, registreerimise aeg, registreerinud töötaja eesnimi, perenimi ja e-meili aadress, hetke_seisund). Vaade on mõeldud kasutamiseks juhatajale või autode haldurile, kes tahab mingil põhjusel vaadata autode detailseid andmeid. Kasutatakse ka kõikide autode nimekirja kuvamiseks. Vaade realiseerib operatsioone OP8.1 ja OP8.2.';

CREATE OR REPLACE VIEW Autode_koondaruanne WITH (security_barrier) AS
SELECT Auto_seisundi_liik.auto_seisundi_liik_kood, UPPER(Auto_seisundi_liik.nimetus) AS auto_seisundi_liik_nimetus, Count(Auto.auto_kood) AS autode_arv_seisundis
FROM Auto_seisundi_liik
LEFT JOIN Auto ON Auto_seisundi_liik.auto_seisundi_liik_kood = Auto.auto_seisundi_liik_kood
GROUP BY Auto_seisundi_liik.auto_seisundi_liik_kood, auto_seisundi_liik_nimetus
ORDER BY autode_arv_seisundis DESC , auto_seisundi_liik_nimetus;

COMMENT ON VIEW Autode_koondaruanne IS 'Vaade, mis kuvab iga auto elutsükli seisundi kohta selle seisundi koodi, nimetuse (suurtähtedega) ja hetkel selles seisundis olevate autode arvu. Vaade on mõeldud kasutamiseks juhatajale, kes soovib sisendit juhtimisotsuste tegemiseks. Vaade realiseerib operatsiooni OP10.1.';

CREATE OR REPLACE FUNCTION f_aktiveeri_auto
(p_auto_kood Auto.auto_kood%TYPE)
RETURNS BOOLEAN AS $$
WITH muudatus AS
(UPDATE Auto SET auto_seisundi_liik_kood=2
WHERE
auto_kood=p_auto_kood AND
(auto_seisundi_liik_kood=1 OR auto_seisundi_liik_kood=3) AND
EXISTS(
SELECT 1 FROM Auto_kategooria_omamine
WHERE p_auto_kood = auto_kood FOR UPDATE) RETURNING auto_kood)
SELECT Count(*)>0 AS tulemus FROM muudatus;
$$ LANGUAGE SQL SECURITY DEFINER
SET search_path=public, pg_temp;

COMMENT ON FUNCTION f_aktiveeri_auto(p_auto_kood Auto.auto_kood%TYPE) IS 'Selle funktsiooni abil aktiveeritakse autot, mis:
* on registreeritud,
* on seisundis "Ootel" või "Mitteaktiivne",
* on määratud vähemalt ühte auto kategooriasse.
Parameetri p_auto_kood oodatav väärtus on aktiveeritava auto kood. Funktsioon realiseerib operatsiooni OP3.';

CREATE OR REPLACE FUNCTION f_muuda_auto_mitteaktiivseks
(p_auto_kood Auto.auto_kood%TYPE)
RETURNS BOOLEAN AS $$
WITH muudatus AS
(UPDATE Auto SET auto_seisundi_liik_kood=3
WHERE auto_kood=p_auto_kood AND auto_seisundi_liik_kood=2 RETURNING auto_kood)
SELECT Count(*)>0 AS tulemus FROM muudatus;
$$ LANGUAGE SQL SECURITY DEFINER
SET search_path=public, pg_temp;

COMMENT ON FUNCTION f_muuda_auto_mitteaktiivseks(p_auto_kood Auto.auto_kood%TYPE) IS 'Selle funktsiooni abil deaktiveeritakse autot, mis on seisundis "Aktiivne". Parameetri p_auto_kood oodatav väärtus on aktiveeritava auto kood. Funktsioon realiseerib operatsiooni OP4.';

CREATE OR REPLACE FUNCTION f_lopeta_auto
(p_auto_kood Auto.auto_kood%TYPE)
RETURNS Auto.auto_kood%TYPE AS $$
UPDATE Auto SET auto_seisundi_liik_kood=4 WHERE
auto_kood=p_auto_kood AND auto_seisundi_liik_kood IN (2,3)
RETURNING auto_kood;
$$ LANGUAGE SQL SECURITY DEFINER
SET search_path=public, pg_temp;

COMMENT ON FUNCTION f_lopeta_auto(p_auto_kood Auto.auto_kood%TYPE) IS 'Selle funktsiooni abil lõpetatakse autot, mis on seisundis "Aktiivne" või "Mitteaktiivne". Parameetri p_auto_kood oodatav väärtus on aktiveeritava auto kood. Funktsioon realiseerib operatsiooni OP5.';

CREATE OR REPLACE FUNCTION f_autendi_juhataja(p_e_meil text, p_parool text)
RETURNS boolean AS $$
DECLARE rslt boolean;
BEGIN
SELECT INTO rslt (parool = public.crypt(p_parool, parool))
FROM Isik
INNER JOIN Tootaja ON Isik.isik_id = Tootaja.isik_id
WHERE
Lower(Isik.e_meil)=Lower(p_e_meil) AND
Isik.isiku_seisundi_liik_kood = 1 AND Tootaja.amet_kood=1 AND 
Tootaja.tootaja_seisundi_liik_kood IN (1, 2, 3, 6);
RETURN coalesce(rslt, FALSE);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE
SET search_path = public, pg_temp;

COMMENT ON FUNCTION f_autendi_juhataja(p_e_meil text, p_parool text) IS 'Selle funktsiooni abil autenditakse juhataja. Parameetri p_e_meil oodatav väärtus on tõstutundetu kasutajanimi (e-meil) ja p_parool oodatav väärtus on tõstutundlik avatekstiline parool. Juhatajal on õigus süsteemi siseneda vaid siis, kui tema seisundiks on "Tööl", "Puhkusel", "Haiguslehel" või "Katseajal".';


CREATE INDEX IXFK_Isik_Isiku_seisundi_liik ON Isik (isiku_seisundi_liik_kood ASC);
CREATE INDEX IXFK_Isik_Riik ON Isik (riik_kood ASC);
CREATE INDEX IXFK_Klient_Kliendi_seisundi_liik ON Klient (kliendi_seisundi_liik_kood ASC);
CREATE INDEX IXFK_Tootaja_Amet ON Tootaja (amet_kood ASC);
CREATE INDEX IXFK_Tootaja_Tootaja ON Tootaja (mentor ASC);
CREATE INDEX IXFK_Tootaja_Tootaja_seisundi_liik ON Tootaja (tootaja_seisundi_liik_kood ASC);
CREATE INDEX IXFK_Auto_Auto_kytuse_liik ON Auto (auto_kytuse_liik_kood ASC);
CREATE INDEX IXFK_Auto_Auto_mark ON Auto (auto_mark_kood ASC);
CREATE INDEX IXFK_Auto_Auto_seisundi_liik ON Auto (auto_seisundi_liik_kood ASC);
CREATE INDEX IXFK_Auto_Tootaja ON Auto (registreerija_id ASC);
CREATE INDEX IXFK_Auto_kategooria_omamine_Auto_kategooria ON Auto_kategooria_omamine (auto_kategooria_kood ASC);

CREATE UNIQUE INDEX AK_Isik_e_meil_tostutundetud ON Isik (Lower(e_meil));
CREATE UNIQUE INDEX AK_Auto_reg_number_aktiivne ON Auto (reg_number) WHERE auto_seisundi_liik_kood = 2;

INSERT INTO amet (amet_kood, nimetus, kirjeldus) VALUES (1, 'Juhataja', 'Organisatsiooni juhtimine ja põhiliste otsuste tegemine ettevõtte eesmärkide saavutamiseks.');
INSERT INTO amet (amet_kood, nimetus, kirjeldus) VALUES (2, 'Klienditeenindaja', NULL);
INSERT INTO amet (amet_kood, nimetus, kirjeldus) VALUES (3, 'Süsteemihaldur', NULL);

INSERT INTO auto_kategooria_tyyp (auto_kategooria_tyyp_kood, nimetus) VALUES (1, 'Ruumikus');
INSERT INTO auto_kategooria_tyyp (auto_kategooria_tyyp_kood, nimetus) VALUES (2, 'Sihtgrupp');

INSERT INTO auto_kategooria (auto_kategooria_kood, nimetus, auto_kategooria_tyyp_kood) VALUES (1, 'Pereauto', 1);
INSERT INTO auto_kategooria (auto_kategooria_kood, nimetus, auto_kategooria_tyyp_kood) VALUES (2, 'Väikeauto', 1);
INSERT INTO auto_kategooria (auto_kategooria_kood, nimetus, auto_kategooria_tyyp_kood) VALUES (3, 'Luksusauto', 2);
INSERT INTO auto_kategooria (auto_kategooria_kood, nimetus, auto_kategooria_tyyp_kood) VALUES (4, 'Minibuss', 1);
INSERT INTO auto_kategooria (auto_kategooria_kood, nimetus, auto_kategooria_tyyp_kood) VALUES (5, 'Kaubik', 1);
INSERT INTO auto_kategooria (auto_kategooria_kood, nimetus, auto_kategooria_tyyp_kood) VALUES (6, 'Džiip', 1);

INSERT INTO auto_kytuse_liik (auto_kytuse_liik_kood, nimetus) VALUES (1, 'Bensiin');
INSERT INTO auto_kytuse_liik (auto_kytuse_liik_kood, nimetus) VALUES (2, 'Diisel');
INSERT INTO auto_kytuse_liik (auto_kytuse_liik_kood, nimetus) VALUES (3, 'Gaas');
INSERT INTO auto_kytuse_liik (auto_kytuse_liik_kood, nimetus) VALUES (4, 'Pistikhübriid');
INSERT INTO auto_kytuse_liik (auto_kytuse_liik_kood, nimetus) VALUES (5, 'Elektriauto');

INSERT INTO auto_mark (auto_mark_kood, nimetus) VALUES (1, 'Volkswagen');
INSERT INTO auto_mark (auto_mark_kood, nimetus) VALUES (2, 'Opel');
INSERT INTO auto_mark (auto_mark_kood, nimetus) VALUES (3, 'Nissan');
INSERT INTO auto_mark (auto_mark_kood, nimetus) VALUES (4, 'Tesla');

INSERT INTO auto_seisundi_liik (auto_seisundi_liik_kood, nimetus) VALUES (1, 'Ootel');
INSERT INTO auto_seisundi_liik (auto_seisundi_liik_kood, nimetus) VALUES (2, 'Aktiivne');
INSERT INTO auto_seisundi_liik (auto_seisundi_liik_kood, nimetus) VALUES (3, 'Mitteaktiivne');
INSERT INTO auto_seisundi_liik (auto_seisundi_liik_kood, nimetus) VALUES (4, 'Lõpetatud');

INSERT INTO isiku_seisundi_liik (isiku_seisundi_liik_kood, nimetus) VALUES (1, 'Elus');
INSERT INTO isiku_seisundi_liik (isiku_seisundi_liik_kood, nimetus) VALUES (2, 'Surnud');

INSERT INTO kliendi_seisundi_liik (kliendi_seisundi_liik_kood, nimetus) VALUES (1, 'Aktiivne');
INSERT INTO kliendi_seisundi_liik (kliendi_seisundi_liik_kood, nimetus) VALUES (2, 'Mustas nimekirjas');

INSERT INTO tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (1, 'Tööl');
INSERT INTO tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (2, 'Puhkusel');
INSERT INTO tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (3, 'Haiguslehel');
INSERT INTO tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (4, 'Töösuhe peatatud');
INSERT INTO tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (5, 'Vallandatud');
INSERT INTO tootaja_seisundi_liik (tootaja_seisundi_liik_kood, nimetus) VALUES (6, 'Katseajal');

CREATE EXTENSION IF NOT EXISTS postgres_fdw WITH SCHEMA public;

CREATE SERVER minu_testandmete_server_apex FOREIGN DATA WRAPPER
postgres_fdw OPTIONS (host 'apex.ttu.ee', dbname 'testandmed',
port '5432');

--Lauseid käivitab kasutaja t192406
CREATE USER MAPPING FOR t192406 SERVER
minu_testandmete_server_apex OPTIONS (user 't192406', password
'Erkionparim');

CREATE FOREIGN TABLE Riik_jsonb (riik JSONB)
SERVER minu_testandmete_server_apex;

CREATE FOREIGN TABLE Isik_jsonb (isik JSONB)
SERVER minu_testandmete_server_apex;

INSERT INTO Riik (riik_kood, nimetus)
SELECT riik->>'Alpha-3 code' AS riik_kood,
riik->>'English short name lower case' AS nimetus
FROM Riik_jsonb;

INSERT INTO Isik(riik_kood, isikukood, eesnimi, perenimi,
e_meil, synni_kp, isiku_seisundi_liik_kood, parool, elukoht)
SELECT riik_kood, isikukood, eesnimi, perenimi, e_meil,
synni_kp::date, isiku_seisundi_liik_kood::smallint, parool,
elukoht
FROM (SELECT isik->>'riik' AS riik_kood,
jsonb_array_elements(isik->'isikud')->>'isikukood' AS isikukood,
jsonb_array_elements(isik->'isikud')->>'eesnimi' AS eesnimi,
jsonb_array_elements(isik->'isikud')->>'perekonnanimi' AS
perenimi,
jsonb_array_elements(isik->'isikud')->>'email' AS e_meil,
jsonb_array_elements(isik->'isikud')->>'synni_aeg' AS synni_kp,
jsonb_array_elements(isik->'isikud')->>'seisund' AS
isiku_seisundi_liik_kood,
jsonb_array_elements(isik->'isikud')->>'parool' AS parool,
jsonb_array_elements(isik->'isikud')->>'aadress' AS elukoht
FROM isik_jsonb) AS lahteandmed
WHERE isiku_seisundi_liik_kood::smallint=1;

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

UPDATE Isik
SET parool = public.crypt(parool, public.gen_salt('bf', 11));

INSERT INTO public.klient (isik_id, kliendi_seisundi_liik_kood, on_nous_tylitamisega) VALUES (8, 1, true);
INSERT INTO public.klient (isik_id, kliendi_seisundi_liik_kood, on_nous_tylitamisega) VALUES (9, 2, true);
INSERT INTO public.klient (isik_id, kliendi_seisundi_liik_kood, on_nous_tylitamisega) VALUES (10, 1, false);
INSERT INTO public.klient (isik_id, kliendi_seisundi_liik_kood, on_nous_tylitamisega) VALUES (11, 1, false);

INSERT INTO public.tootaja (isik_id, amet_kood, tootaja_seisundi_liik_kood, mentor) VALUES (6, 1, 1, NULL);
INSERT INTO public.tootaja (isik_id, amet_kood, tootaja_seisundi_liik_kood, mentor) VALUES (12, 3, 4, NULL);
INSERT INTO public.tootaja (isik_id, amet_kood, tootaja_seisundi_liik_kood, mentor) VALUES (7, 2, 1, 6);
INSERT INTO public.tootaja (isik_id, amet_kood, tootaja_seisundi_liik_kood, mentor) VALUES (11, 2, 2, 7);

INSERT INTO public.auto (auto_kood, nimetus, mudel, valjalaske_aasta, reg_number, istekohtade_arv, mootori_maht, vin_kood, reg_aeg, registreerija_id, auto_kytuse_liik_kood, auto_seisundi_liik_kood, auto_mark_kood) VALUES (14, 'Phaeton1', 'Phaeton', 2011, '121YYY', 5, 3.0, 'WVWZZZ3CZEE075353', '2019-12-05 22:25:11', 7, 2, 1, 1);
INSERT INTO public.auto (auto_kood, nimetus, mudel, valjalaske_aasta, reg_number, istekohtade_arv, mootori_maht, vin_kood, reg_aeg, registreerija_id, auto_kytuse_liik_kood, auto_seisundi_liik_kood, auto_mark_kood) VALUES (15, 'Passat1', 'Passat', 2014, '955TTR', 4, 2.0, 'WVWZZZ3CZEE075372', '2019-12-05 22:27:25', 7, 2, 4, 1);
INSERT INTO public.auto (auto_kood, nimetus, mudel, valjalaske_aasta, reg_number, istekohtade_arv, mootori_maht, vin_kood, reg_aeg, registreerija_id, auto_kytuse_liik_kood, auto_seisundi_liik_kood, auto_mark_kood) VALUES (16, 'Passat2', 'Passat', 2014, '777HHG', 4, 1.6, 'WVWZZZ3CZEE075354', '2019-12-05 22:30:08', 7, 2, 4, 1);
INSERT INTO public.auto (auto_kood, nimetus, mudel, valjalaske_aasta, reg_number, istekohtade_arv, mootori_maht, vin_kood, reg_aeg, registreerija_id, auto_kytuse_liik_kood, auto_seisundi_liik_kood, auto_mark_kood) VALUES (17, 'Passat3', 'Passat', 2014, '879TRY', 4, 1.4, 'WVWZZZ3CZEE116550', '2019-12-05 22:35:45', 7, 1, 3, 1);
INSERT INTO public.auto (auto_kood, nimetus, mudel, valjalaske_aasta, reg_number, istekohtade_arv, mootori_maht, vin_kood, reg_aeg, registreerija_id, auto_kytuse_liik_kood, auto_seisundi_liik_kood, auto_mark_kood) VALUES (18, 'Touareg1', 'Touareg', 2010, '669UHJ', 5, 3.0, 'WVGZZZ7PZCD026979', '2019-12-05 22:38:51', 12, 2, 2, 1);
INSERT INTO public.auto (auto_kood, nimetus, mudel, valjalaske_aasta, reg_number, istekohtade_arv, mootori_maht, vin_kood, reg_aeg, registreerija_id, auto_kytuse_liik_kood, auto_seisundi_liik_kood, auto_mark_kood) VALUES (100, 'Astra1', 'Astra', 2012, '666ABV', 5, 1.6, 'W0L0AHL69CG047752', '2019-12-05 22:40:13', 11, 1, 2, 2);
INSERT INTO public.auto (auto_kood, nimetus, mudel, valjalaske_aasta, reg_number, istekohtade_arv, mootori_maht, vin_kood, reg_aeg, registreerija_id, auto_kytuse_liik_kood, auto_seisundi_liik_kood, auto_mark_kood) VALUES (200, 'Tesla1', 'Model S', 2015, 'TES001', 5, 0.0, '5YJSA3H16EFP29293', '2019-12-05 22:42:51', 7, 5, 2, 3);
INSERT INTO public.auto (auto_kood, nimetus, mudel, valjalaske_aasta, reg_number, istekohtade_arv, mootori_maht, vin_kood, reg_aeg, registreerija_id, auto_kytuse_liik_kood, auto_seisundi_liik_kood, auto_mark_kood) VALUES (11, 'Golf1', 'Golf', 2013, '123ABC', 5, 1.4, 'WVWZZZAUZGP120820', '2019-12-05 22:42:51', 7, 1, 3, 1);
INSERT INTO public.auto (auto_kood, nimetus, mudel, valjalaske_aasta, reg_number, istekohtade_arv, mootori_maht, vin_kood, reg_aeg, registreerija_id, auto_kytuse_liik_kood, auto_seisundi_liik_kood, auto_mark_kood) VALUES (300, 'Leaf1', 'Leaf', 2014, '849GJR', 5, 0.0, 'SJNFAAZE0U6014007', '2019-12-05 22:54:07', 11, 5, 1, 4);
INSERT INTO public.auto (auto_kood, nimetus, mudel, valjalaske_aasta, reg_number, istekohtade_arv, mootori_maht, vin_kood, reg_aeg, registreerija_id, auto_kytuse_liik_kood, auto_seisundi_liik_kood, auto_mark_kood) VALUES (12, 'Golf2', 'Golf', 2016, '223BBC', 5, 1.4, 'WVWZZZAUZGP120828', '2019-12-05 22:21:51', 7, 1, 2, 1);
INSERT INTO public.auto (auto_kood, nimetus, mudel, valjalaske_aasta, reg_number, istekohtade_arv, mootori_maht, vin_kood, reg_aeg, registreerija_id, auto_kytuse_liik_kood, auto_seisundi_liik_kood, auto_mark_kood) VALUES (13, 'Golf3', 'Golf', 2013, '332XXA', 5, 1.6, 'WVWZZZ1KZDM649841', '2019-12-05 22:23:44', 7, 2, 3, 1);

INSERT INTO public.auto_kategooria_omamine (auto_kood, auto_kategooria_kood) VALUES (12, 1);
INSERT INTO public.auto_kategooria_omamine (auto_kood, auto_kategooria_kood) VALUES (13, 1);
INSERT INTO public.auto_kategooria_omamine (auto_kood, auto_kategooria_kood) VALUES (15, 1);
INSERT INTO public.auto_kategooria_omamine (auto_kood, auto_kategooria_kood) VALUES (17, 1);
INSERT INTO public.auto_kategooria_omamine (auto_kood, auto_kategooria_kood) VALUES (100, 1);
INSERT INTO public.auto_kategooria_omamine (auto_kood, auto_kategooria_kood) VALUES (11, 1);
INSERT INTO public.auto_kategooria_omamine (auto_kood, auto_kategooria_kood) VALUES (300, 2);
INSERT INTO public.auto_kategooria_omamine (auto_kood, auto_kategooria_kood) VALUES (200, 3);
INSERT INTO public.auto_kategooria_omamine (auto_kood, auto_kategooria_kood) VALUES (14, 3);
INSERT INTO public.auto_kategooria_omamine (auto_kood, auto_kategooria_kood) VALUES (18, 6);
INSERT INTO public.auto_kategooria_omamine (auto_kood, auto_kategooria_kood) VALUES (16, 2);

CREATE OR REPLACE FUNCTION TGF_auto_i() RETURNS TRIGGER AS $$
BEGIN
	RAISE EXCEPTION 'Uus auto saab lisada ainult algseisundiga "Ootel"';
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION TGF_auto_i() IS 'Trigeri funktsioon, mis kontrollib auto lisamisel selle algseisundi korrektsust';

CREATE TRIGGER TG_auto_i BEFORE INSERT ON Auto
FOR EACH ROW WHEN (NEW.auto_seisundi_liik_kood != 1) EXECUTE PROCEDURE TGF_auto_i();

CREATE OR REPLACE FUNCTION TGF_auto_u() RETURNS TRIGGER AS $$
BEGIN
	RAISE EXCEPTION
'Seisundimuudatus pole lubatud.
Lubatud seisundimuudatused on:
	Ootel => Aktiivne
	Aktiivne => Mitteaktiivne
	Aktiivne => Lõpetatud
	Mitteaktiivne => Aktiivne
	Mitteaktiivne => Lõpetatud';
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION TGF_auto_u() IS 'Trigeri funktsioon, mis kontrollib autode seisundimuudatuste korrektsust';

CREATE TRIGGER TG_auto_u BEFORE UPDATE OF auto_seisundi_liik_kood ON Auto
FOR EACH ROW
WHEN (NOT(
	(OLD.auto_seisundi_liik_kood = NEW.auto_seisundi_liik_kood) OR
	(OLD.auto_seisundi_liik_kood = 1 AND NEW.auto_seisundi_liik_kood = 2) OR
	(OLD.auto_seisundi_liik_kood = 2 AND NEW.auto_seisundi_liik_kood = 3) OR 
	(OLD.auto_seisundi_liik_kood = 2 AND NEW.auto_seisundi_liik_kood = 4) OR
	(OLD.auto_seisundi_liik_kood = 3 AND NEW.auto_seisundi_liik_kood = 2) OR 
	(OLD.auto_seisundi_liik_kood = 3 AND NEW.auto_seisundi_liik_kood = 4)))
EXECUTE PROCEDURE TGF_auto_u();

CREATE USER t192406_autorendi_juhataja WITH PASSWORD 'liimatainen';

REVOKE ALL ON DATABASE t192406 FROM PUBLIC;

REVOKE ALL ON SCHEMA public FROM PUBLIC;

REVOKE USAGE ON LANGUAGE plpgsql FROM PUBLIC;

REVOKE USAGE ON DOMAIN d_nimetus FROM PUBLIC;
REVOKE USAGE ON DOMAIN d_reg_aeg FROM PUBLIC;

REVOKE EXECUTE ON FUNCTION
f_aktiveeri_auto(p_auto_kood Auto.auto_kood%TYPE),
f_autendi_juhataja(p_e_meil text, p_parool text),
f_lopeta_auto(p_auto_kood Auto.auto_kood%TYPE),
f_muuda_auto_mitteaktiivseks(p_auto_kood Auto.auto_kood%TYPE),
tgf_auto_i(),
tgf_auto_u()
FROM PUBLIC;

REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC;

GRANT CONNECT ON DATABASE t192406 TO t192406_autorendi_juhataja;

GRANT USAGE ON SCHEMA public TO t192406_autorendi_juhataja;

GRANT EXECUTE ON FUNCTION
f_lopeta_auto(p_auto_kood Auto.auto_kood%TYPE),
f_autendi_juhataja(p_e_meil text, p_parool text)
TO t192406_autorendi_juhataja;

GRANT SELECT ON
Aktiivsed_ja_mitteaktiivsed_autod,
Autode_kategooriate_omamine,
Autode_detailid,
Autode_koondaruanne
TO t192406_autorendi_juhataja;

ALTER DEFAULT PRIVILEGES REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;

COMMIT;
--ROLLBACK;