/* ---------------------------------------------------- */
/*  Generated by Enterprise Architect Version 12.0 		*/
/*  Created On : 12-nov-2019 16:54:21 				*/
/*  DBMS       : PostgreSQL 						*/
/* ---------------------------------------------------- */

/* Drop Sequences for Autonumber Columns */

START TRANSACTION;

/* Drop Tables */

DROP TABLE IF EXISTS Tootaja_seisundi_liik CASCADE
;

DROP TABLE IF EXISTS Riik CASCADE
;

DROP TABLE IF EXISTS Kliendi_seisundi_liik CASCADE
;

DROP TABLE IF EXISTS Isiku_seisundi_liik CASCADE
;

DROP TABLE IF EXISTS Auto_seisundi_liik CASCADE
;

DROP TABLE IF EXISTS Auto_mark CASCADE
;

DROP TABLE IF EXISTS Auto_kytuse_liik CASCADE
;

DROP TABLE IF EXISTS Auto_kategooria_tyyp CASCADE
;

DROP TABLE IF EXISTS Auto_kategooria CASCADE
;

DROP TABLE IF EXISTS Amet CASCADE
;

DROP TABLE IF EXISTS Isik CASCADE
;

DROP TABLE IF EXISTS Klient CASCADE
;

DROP TABLE IF EXISTS Tootaja CASCADE
;

DROP TABLE IF EXISTS Auto CASCADE
;

DROP TABLE IF EXISTS Auto_kategooria_omamine CASCADE
;

/* Create Tables */

CREATE TABLE Tootaja_seisundi_liik
(
	nimetus varchar(50)	 NOT NULL,
	tootaja_seisundi_liik_kood smallint NOT NULL,
	CONSTRAINT PK_Tootaja_seisundi_liik PRIMARY KEY (tootaja_seisundi_liik_kood),
	CONSTRAINT AK_Tootaja_seisundi_liik UNIQUE (nimetus),
	CONSTRAINT CHK_Tootaja_seisundi_liik_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
)
;

CREATE TABLE Riik
(
	riik_kood varchar(3)	 NOT NULL,
	nimetus varchar(50)	 NOT NULL,
	CONSTRAINT PK_Riik PRIMARY KEY (riik_kood),
	CONSTRAINT AK_Riik_nimetus UNIQUE (nimetus),
	CONSTRAINT CHK_Riik_riik_kood_kolmest_suurtahest CHECK (riik_kood ~ '^[A-Z]{3}$'),
	CONSTRAINT CHK_Riik_riik_kood_pole_tyhi CHECK (riik_kood!~'^[[:space:]]*$'),
	CONSTRAINT CHK_Riik_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
)
;

CREATE TABLE Kliendi_seisundi_liik
(
	kliendi_seisundi_liik_kood smallint NOT NULL,
	nimetus varchar(50)	 NOT NULL,
	CONSTRAINT PK_Kliendi_seisundi_liik PRIMARY KEY (kliendi_seisundi_liik_kood),
	CONSTRAINT AK_Kliendi_seisundi_liik_nimetus UNIQUE (nimetus),
	CONSTRAINT CHK_Kliendi_seisundi_liik_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
)
;

CREATE TABLE Isiku_seisundi_liik
(
	isiku_seisundi_liik_kood smallint NOT NULL,
	nimetus varchar(50)	 NOT NULL,
	CONSTRAINT PK_Isiku_seisundi_liik PRIMARY KEY (isiku_seisundi_liik_kood),
	CONSTRAINT AK_Isiku_seisundi_liik_nimetus UNIQUE (nimetus),
	CONSTRAINT CHK_Isiku_seisundi_liik_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
)
;

CREATE TABLE Auto_seisundi_liik
(
	auto_seisundi_liik_kood smallint NOT NULL,
	nimetus varchar(50)	 NOT NULL,
	CONSTRAINT PK_Auto_seisundi_liik PRIMARY KEY (auto_seisundi_liik_kood),
	CONSTRAINT AK_Auto_seisundi_liik_nimetus UNIQUE (nimetus),
	CONSTRAINT CHK_Auto_seisundi_liik_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
)
;

CREATE TABLE Auto_mark
(
	auto_mark_kood smallint NOT NULL,
	nimetus varchar(50)	 NOT NULL,
	CONSTRAINT PK_Auto_mark PRIMARY KEY (auto_mark_kood),
	CONSTRAINT AK_Auto_mark_nimetus UNIQUE (nimetus),
	CONSTRAINT CHK_Auto_mark_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
)
;

CREATE TABLE Auto_kytuse_liik
(
	auto_kytuse_liik_kood smallint NOT NULL,
	nimetus varchar(50)	 NOT NULL,
	CONSTRAINT PK_Auto_kytuse_liik PRIMARY KEY (auto_kytuse_liik_kood),
	CONSTRAINT AK_Auto_kytuse_liik UNIQUE (nimetus),
	CONSTRAINT CHK_Auto_kytuse_liik_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
)
;

CREATE TABLE Auto_kategooria_tyyp
(
	auto_kategooria_tyyp_kood smallint NOT NULL,
	nimetus varchar(50)	 NOT NULL,
	CONSTRAINT PK_Auto_kategooria_tyyp PRIMARY KEY (auto_kategooria_tyyp_kood),
	CONSTRAINT AK_Auto_kategooria_nimetus UNIQUE (nimetus),
	CONSTRAINT CHK_Auto_kategooria_tyyp_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
)
;

CREATE TABLE Auto_kategooria
(
	auto_kategooria_kood smallint NOT NULL,
	nimetus varchar(50)	 NOT NULL,
	auto_kategooria_tyyp_kood smallint NOT NULL,
	CONSTRAINT PK_Auto_kategooria PRIMARY KEY (auto_kategooria_kood),
	CONSTRAINT AK_Auto_kategooria UNIQUE (auto_kategooria_tyyp_kood,nimetus),
	CONSTRAINT CHK_Auto_kategooria_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$'),
	CONSTRAINT FK_Auto_kategooria_Auto_kategooria_tyyp FOREIGN KEY (auto_kategooria_tyyp_kood) REFERENCES Auto_kategooria_tyyp (auto_kategooria_tyyp_kood) ON DELETE No Action ON UPDATE Cascade
)
;

CREATE TABLE Amet
(
	amet_kood smallint NOT NULL,
	nimetus varchar(50)	 NOT NULL,
	kirjeldus text NULL,
	CONSTRAINT PK_Amet PRIMARY KEY (amet_kood),
	CONSTRAINT AK_Amet_nimetus UNIQUE (nimetus),
	CONSTRAINT CHK_Amet_kirjeldus_pole_tyhi CHECK (kirjeldus!~'^[[:space:]]*$'),
	CONSTRAINT CHK_Amet_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$')
)
;

CREATE TABLE Isik
(
	isik_id serial NOT NULL,
	isikukood varchar(50)	 NOT NULL,
	riik_kood varchar(3)	 NOT NULL,
	e_meil varchar(254)	 NOT NULL,
	isiku_seisundi_liik_kood smallint NOT NULL DEFAULT 1,
	synni_kp timestamp NOT NULL,
	parool varchar(60)	 NOT NULL,
	reg_aeg timestamp NOT NULL DEFAULT LOCALTIMESTAMP(0),
	eesnimi varchar(1500)	 NULL,
	perenimi varchar(1000)	 NULL,
	elukoht varchar(120)	 NULL,
	CONSTRAINT PK_Isik PRIMARY KEY (isik_id),
	CONSTRAINT AK_Isik_e_meil UNIQUE (e_meil),
	CONSTRAINT AK_isik_isikukood_riik UNIQUE (isikukood,riik_kood),
	CONSTRAINT CHK_Isik_isikukood_pole_tyhi CHECK (isikukood!~'^[[:space:]]*$'),
	CONSTRAINT CHK_Isik_isikukood_ainult_lubatud_symbolid CHECK (isikukood ~ '^([[:upper:]]|[[:lower:]]|[[:digit:]]|[[:space:]]|-|\+|=|\\|\/)*$'),
	CONSTRAINT CHK_Isik_eesnimi_voi_perenimi_olemas CHECK ((eesnimi IS NOT NULL) OR (perenimi IS NOT NULL)),
	CONSTRAINT CHK_Isik_eesnimi_pole_tyhi CHECK (eesnimi!~'^[[:space:]]*$'),
	CONSTRAINT CHK_Isik_perenimi_pole_tyhi CHECK (perenimi!~'^[[:space:]]*$'),
	CONSTRAINT CHK_Isik_synni_kp_on_vahemikus CHECK ((synni_kp >= '1900-01-01') AND (synni_kp < '2101-01-01')),
	CONSTRAINT CHK_Isik_synni_kp_pole_suurem_reg_ajast CHECK (synni_kp <= reg_aeg),
	CONSTRAINT CHK_Isik_elukoht_pole_tyhi CHECK (perenimi!~'^[[:space:]]*$'),
	CONSTRAINT CHK_Isik_elukoht_pole_ainult_numbritest CHECK (perenimi!~'^[[:digit:]]*$'),
	CONSTRAINT CHK_Isik_e_meil_sisaldab_tapselt_uhe_at_marki CHECK (e_meil ~ '^[^@]*@[^@]*$'),
	CONSTRAINT CHK_Isik_reg_aeg_on_vahemikus CHECK ((reg_aeg >= '2010-01-01') AND (reg_aeg < '2101-01-01')),
	CONSTRAINT FK_Isik_Isiku_seisundi_liik FOREIGN KEY (isiku_seisundi_liik_kood) REFERENCES Isiku_seisundi_liik (isiku_seisundi_liik_kood) ON DELETE No Action ON UPDATE Cascade,
	CONSTRAINT FK_isikukoodi_riik FOREIGN KEY (riik_kood) REFERENCES Riik (riik_kood) ON DELETE No Action ON UPDATE Cascade
)
;

CREATE TABLE Klient
(
	isik_id integer NOT NULL,
	kliendi_seisundi_liik_kood smallint NOT NULL DEFAULT 1,
	on_nous_tylitamisega boolean NOT NULL DEFAULT FALSE,
	CONSTRAINT PK_Klient PRIMARY KEY (isik_id),
	CONSTRAINT FK_Klient_Kliendi_seisundi_liik FOREIGN KEY (kliendi_seisundi_liik_kood) REFERENCES Kliendi_seisundi_liik (kliendi_seisundi_liik_kood) ON DELETE No Action ON UPDATE Cascade,
	CONSTRAINT FK_Klient_Isik FOREIGN KEY (isik_id) REFERENCES Isik (isik_id) ON DELETE Cascade ON UPDATE No Action
)
;

CREATE TABLE Tootaja
(
	isik_id integer NOT NULL,
	amet_kood smallint NOT NULL,
	tootaja_seisundi_liik_kood smallint NOT NULL DEFAULT 1,
	mentor integer NULL,
	CONSTRAINT PK_Tootaja PRIMARY KEY (isik_id),
	CONSTRAINT CHK_Tootaja_mentor_pole_ise CHECK (mentor <> isik_id),
	CONSTRAINT FK_Tootaja_Tootaja FOREIGN KEY (mentor) REFERENCES Tootaja (isik_id) ON DELETE Set Null ON UPDATE No Action,
	CONSTRAINT FK_Tootaja_Amet FOREIGN KEY (amet_kood) REFERENCES Amet (amet_kood) ON DELETE No Action ON UPDATE Cascade,
	CONSTRAINT FK_Tootaja_Tootaja_seisundi_liik FOREIGN KEY (tootaja_seisundi_liik_kood) REFERENCES Tootaja_seisundi_liik (tootaja_seisundi_liik_kood) ON DELETE No Action ON UPDATE Cascade,
	CONSTRAINT FK_Tootaja_Isik FOREIGN KEY (isik_id) REFERENCES Isik (isik_id) ON DELETE Cascade ON UPDATE No Action
)
;

CREATE TABLE Auto
(
	auto_kood integer NOT NULL,
	nimetus varchar(50)	 NOT NULL,
	mudel varchar(100)	 NOT NULL,
	valjalaske_aasta smallint NOT NULL,
	reg_number varchar(9)	 NOT NULL,
	istekohtade_arv smallint NOT NULL,
	mootori_maht decimal(3,1) NOT NULL,
	vin_kood varchar(17)	 NOT NULL,
	reg_aeg timestamp NOT NULL DEFAULT LOCALTIMESTAMP(0),
	registreerija_id integer NOT NULL,
	auto_kytuse_liik_kood smallint NOT NULL,
	auto_seisundi_liik_kood smallint NOT NULL DEFAULT 1,
	auto_mark_kood smallint NOT NULL,
	CONSTRAINT PK_Auto PRIMARY KEY (auto_kood),
	CONSTRAINT AK_Auto_vin_kood UNIQUE (vin_kood),
	CONSTRAINT AK_Auto_nimetus UNIQUE (nimetus),
	CONSTRAINT CHK_Auto_nimetus_pole_tyhi CHECK (nimetus!~'^[[:space:]]*$'),
	CONSTRAINT CHK_Auto_reg_aeg_on_vahemikus CHECK (reg_aeg >= '2010-01-01' AND
	reg_aeg < '2101-01-01'),
	CONSTRAINT CHK_Auto_valjalaske_aasta_on_vahemikus CHECK (valjalaske_aasta >= 2000 AND
	valjalaske_aasta <= 2100),
	CONSTRAINT CHK_Auto_istekohtade_arv_on_vahemikus CHECK (istekohtade_arv >= 2000 AND
	istekohtade_arv <= 2100),
	CONSTRAINT CHK_Auto_mudel_pole_tyhi CHECK (mudel!~'^[[:space:]]*$'),
	CONSTRAINT CHK_Auto_mootori_maht_on_positiivne CHECK (mootori_maht >= 0),
	CONSTRAINT CHK_Auto_reg_number_pole_tyhi CHECK (reg_number!~'^[[:space:]]*$'),
	CONSTRAINT CHK_Auto_reg_number_min_pikkus CHECK (LENGTH(reg_number) >= 2),
	CONSTRAINT CHK_Auto_reg_number_ainult_suurtahed_ja_numbrid CHECK (reg_number ~ '^([[:upper:]]|[[:digit:]])*$'),
	CONSTRAINT CHK_Auto_reg_number_muster_1 CHECK (reg_number ~ '^[[:upper:]]+[[:digit:]]+$'),
	CONSTRAINT CHK_Auto_reg_number_muster_2 CHECK (reg_number ~ '^([[:digit:]]{2}|[[:digit:]]{3})[[:upper:]]{3}$'),
	CONSTRAINT CHK_Auto_vin_kood_min_pikkus CHECK (LENGTH(vin_kood) >= 11),
	CONSTRAINT CHK_Auto_vin_kood_ainult_suurtahed_ja_numbrid CHECK (vin_kood ~ '^([[:upper:]]|[[:digit:]])*$'),
	CONSTRAINT FK_Auto_Auto_mark FOREIGN KEY (auto_mark_kood) REFERENCES Auto_mark (auto_mark_kood) ON DELETE No Action ON UPDATE Cascade,
	CONSTRAINT FK_Auto_auto_kytuse_liik FOREIGN KEY (auto_kytuse_liik_kood) REFERENCES Auto_kytuse_liik (auto_kytuse_liik_kood) ON DELETE No Action ON UPDATE Cascade,
	CONSTRAINT FK_Auto_Auto_seisundi_liik FOREIGN KEY (auto_seisundi_liik_kood) REFERENCES Auto_seisundi_liik (auto_seisundi_liik_kood) ON DELETE No Action ON UPDATE Cascade,
	CONSTRAINT FK_Auto_T��taja FOREIGN KEY (registreerija_id) REFERENCES Tootaja (isik_id) ON DELETE No Action ON UPDATE Cascade
)
;

CREATE TABLE Auto_kategooria_omamine
(
	auto_kood integer NOT NULL,
	auto_kategooria_kood smallint NOT NULL,
	CONSTRAINT PK_Auto_kategooria_omamine PRIMARY KEY (auto_kood,auto_kategooria_kood),
	CONSTRAINT FK_Auto_kategooria_omamine_Auto FOREIGN KEY (auto_kood) REFERENCES Auto (auto_kood) ON DELETE Cascade ON UPDATE Cascade,
	CONSTRAINT FK_Auto_kategooria_omamine_Auto_kategooria FOREIGN KEY (auto_kategooria_kood) REFERENCES Auto_kategooria (auto_kategooria_kood) ON DELETE No Action ON UPDATE Cascade
)
;

/* Create Table Comments, Sequences for Autonumber Columns */

/* Create Primary Keys, Indexes, Uniques, Checks */

CREATE INDEX IXFK_Auto_kategooria_Auto_kategooria_tyyp ON Auto_kategooria (auto_kategooria_tyyp_kood ASC)
;

CREATE INDEX IXFK_Isik_Isiku_seisundi_liik ON Isik (isiku_seisundi_liik_kood ASC)
;

CREATE INDEX IXFK_isikukoodi_riik ON Isik (riik_kood ASC)
;

CREATE INDEX IXFK_Klient_Isik ON Klient (isik_id ASC)
;

CREATE INDEX IXFK_Klient_Kliendi_seisundi_liik ON Klient (kliendi_seisundi_liik_kood ASC)
;

CREATE INDEX IXFK_Tootaja_Amet ON Tootaja (amet_kood ASC)
;

CREATE INDEX IXFK_Tootaja_Isik ON Tootaja (isik_id ASC)
;

CREATE INDEX IXFK_Tootaja_Tootaja ON Tootaja (mentor ASC)
;

CREATE INDEX IXFK_Tootaja_Tootaja_seisundi_liik ON Tootaja (tootaja_seisundi_liik_kood ASC)
;

CREATE INDEX IXFK_Auto_auto_kytuse_liik ON Auto (auto_kytuse_liik_kood ASC)
;

CREATE INDEX IXFK_Auto_Auto_mark ON Auto (auto_mark_kood ASC)
;

CREATE INDEX IXFK_Auto_Auto_seisundi_liik ON Auto (auto_seisundi_liik_kood ASC)
;

CREATE INDEX IXFK_Auto_T��taja ON Auto (registreerija_id ASC)
;

CREATE INDEX IXFK_Auto_kategooria_omamine_Auto ON Auto_kategooria_omamine (auto_kood ASC)
;

CREATE INDEX IXFK_Auto_kategooria_omamine_Auto_kategooria ON Auto_kategooria_omamine (auto_kategooria_kood ASC)
;

COMMIT;
