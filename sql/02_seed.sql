
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE stoc';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE lucrare';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE plantare';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE utilaj';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE angajat';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE depozit';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE parcela';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE sezon';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE cultura';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE ferma';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

-- FERME
INSERT INTO ferma (nume, localitate) VALUES ('RODAGRO GREEN', 'MOVILENI');
INSERT INTO ferma (nume, localitate) VALUES ('AgroSud',  'Slatina');

-- DEPOZITE
-- RODAGRO GREEN
INSERT INTO depozit (ferma_id, nume, tip, capacitate_tone)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'Siloz Nord', 'siloz', 600);

INSERT INTO depozit (ferma_id, nume, tip, capacitate_tone)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'Magazie Nord', 'magazie', 180);

-- AgroSud
INSERT INTO depozit (ferma_id, nume, tip, capacitate_tone)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'Siloz Sud', 'siloz', 500);

INSERT INTO depozit (ferma_id, nume, tip, capacitate_tone)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'Hala Sud', 'hala', 220);

INSERT INTO depozit (ferma_id, nume, tip, capacitate_tone)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'Magazie Sud', 'magazie', 150);

-- PARCELE
-- RODAGRO GREEN
INSERT INTO parcela (ferma_id, denumire, suprafata_ha, tip_sol)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'MV-P1', 12.50, 'cernoziom');

INSERT INTO parcela (ferma_id, denumire, suprafata_ha, tip_sol)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'MV-P2', 18.20, 'lutos');

INSERT INTO parcela (ferma_id, denumire, suprafata_ha, tip_sol)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'MV-P3', 9.80, 'argilos');

INSERT INTO parcela (ferma_id, denumire, suprafata_ha, tip_sol)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'MV-P4', 15.00, 'cernoziom');

INSERT INTO parcela (ferma_id, denumire, suprafata_ha, tip_sol)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'MV-P5', 20.30, 'nisipos');

INSERT INTO parcela (ferma_id, denumire, suprafata_ha, tip_sol)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'MV-P6', 13.70, 'lutos');

INSERT INTO parcela (ferma_id, denumire, suprafata_ha, tip_sol)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'MV-P7', 17.40, 'argilos');

-- AgroSud
INSERT INTO parcela (ferma_id, denumire, suprafata_ha, tip_sol)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'SL-P1', 14.00, 'nisipos');

INSERT INTO parcela (ferma_id, denumire, suprafata_ha, tip_sol)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'SL-P2', 22.40, 'lutos');

INSERT INTO parcela (ferma_id, denumire, suprafata_ha, tip_sol)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'SL-P3', 11.60, 'cernoziom');

INSERT INTO parcela (ferma_id, denumire, suprafata_ha, tip_sol)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'SL-P4', 16.80, 'argilos');

INSERT INTO parcela (ferma_id, denumire, suprafata_ha, tip_sol)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'SL-P5', 19.50, 'lutos');

INSERT INTO parcela (ferma_id, denumire, suprafata_ha, tip_sol)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'SL-P6', 13.90, 'nisipos');

INSERT INTO parcela (ferma_id, denumire, suprafata_ha, tip_sol)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'SL-P7', 18.30, 'cernoziom');

-- CULTURI
INSERT INTO cultura (nume, categorie) VALUES ('Grau', 'cereale');
INSERT INTO cultura (nume, categorie) VALUES ('Porumb', 'cereale');
INSERT INTO cultura (nume, categorie) VALUES ('Floarea-soarelui', 'oleaginoase');
INSERT INTO cultura (nume, categorie) VALUES ('Orz', 'cereale');
INSERT INTO cultura (nume, categorie) VALUES ('Rapita', 'oleaginoase');

-- SEZOANE
INSERT INTO sezon (an, data_start, data_end) VALUES (2024, DATE '2023-09-01', DATE '2024-08-31');
INSERT INTO sezon (an, data_start, data_end) VALUES (2025, DATE '2024-09-01', DATE '2025-08-31');

-- ANGAJATI (per ferma)
-- RODAGRO GREEN
INSERT INTO angajat (ferma_id, nume, functie, salariu)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'Pop Ion', 'operator', 5200);

INSERT INTO angajat (ferma_id, nume, functie, salariu)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'Ionescu Mihai', 'muncitor agricol', 4200);

INSERT INTO angajat (ferma_id, nume, functie, salariu)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'Vasilescu Ana', 'inginer agronom', 6800);

INSERT INTO angajat (ferma_id, nume, functie, salariu)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'Georgescu Elena', 'sef echipa', 6000);

INSERT INTO angajat (ferma_id, nume, functie, salariu)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'Dumitru Alina', 'contabil', 5500);

INSERT INTO angajat (ferma_id, nume, functie, salariu)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'Stan Paul', 'operator', 4800);

-- AgroSud
INSERT INTO angajat (ferma_id, nume, functie, salariu)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'Radu Stefan', 'operator', 5100);

INSERT INTO angajat (ferma_id, nume, functie, salariu)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'Dima Andrei', 'muncitor agricol', 4100);

INSERT INTO angajat (ferma_id, nume, functie, salariu)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'Marin George', 'sef echipa', 6100);

INSERT INTO angajat (ferma_id, nume, functie, salariu)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'Stan Florin', 'inginer agronom', 6700);

INSERT INTO angajat (ferma_id, nume, functie, salariu)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'Popescu Ioana', 'contabil', 5400);

INSERT INTO angajat (ferma_id, nume, functie, salariu)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'Vasilescu Mihai', 'operator', 4700);

-- UTILAJE (per ferma)
-- RODAGRO GREEN
INSERT INTO utilaj (ferma_id, denumire, tip, data_achizitie)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'Tractor JD 6155', 'tractor', DATE '2021-04-10');

INSERT INTO utilaj (ferma_id, denumire, tip, data_achizitie)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'Semanatoare Amazone', 'semanatoare', DATE '2022-03-18');

INSERT INTO utilaj (ferma_id, denumire, tip, data_achizitie)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'Pulverizator Berthoud', 'pulverizator', DATE '2020-06-01');

INSERT INTO utilaj (ferma_id, denumire, tip, data_achizitie)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'), 'Combine Claas Lexion', 'combine', DATE '2018-11-15');

INSERT INTO utilaj (ferma_id, denumire, tip, data_achizitie)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='RODAGRO GREEN'),'Disc Lemken', 'disc', DATE '2019-08-22');

-- AgroSud
INSERT INTO utilaj (ferma_id, denumire, tip, data_achizitie)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'Tractor JD 6190R', 'tractor', DATE '2019-09-20');

INSERT INTO utilaj (ferma_id, denumire, tip, data_achizitie)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'Disc Kuhn', 'disc', DATE '2020-10-05');

INSERT INTO utilaj (ferma_id, denumire, tip, data_achizitie)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'Combine New Holland', 'combine', DATE '2017-07-30');

INSERT INTO utilaj (ferma_id, denumire, tip, data_achizitie)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'Semanatoare Kuhn', 'semanatoare', DATE '2021-12-12');

INSERT INTO utilaj (ferma_id, denumire, tip, data_achizitie)
VALUES ((SELECT ferma_id FROM ferma WHERE nume='AgroSud'), 'Pulverizator Hardi', 'pulverizator', DATE '2022-05-25');



-- PLANTARI
-- RODAGRO GREEN - sezon 2024
INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='MV-P1'),
  (SELECT cultura_id FROM cultura WHERE nume='Grau'),
  (SELECT sezon_id FROM sezon WHERE an=2024),
  DATE '2023-09-10',
  320,
  'Glosa'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='MV-P2'),
  (SELECT cultura_id FROM cultura WHERE nume='Porumb'),
  (SELECT sezon_id FROM sezon WHERE an=2024),
  DATE '2024-04-05',
  6,
  'Pioneer P9241'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='MV-P3'),
  (SELECT cultura_id FROM cultura WHERE nume='Floarea-soarelui'),
  (SELECT sezon_id FROM sezon WHERE an=2024),
  DATE '2024-04-12',
  5,
  'SY Bacardi'
);
INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='MV-P4'),
  (SELECT cultura_id FROM cultura WHERE nume='Rapita'),
  (SELECT sezon_id FROM sezon WHERE an=2024),
  DATE '2023-09-18',
  5,
  'DK Exception'
);
INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='MV-P5'),
  (SELECT cultura_id FROM cultura WHERE nume='Orz'),
  (SELECT sezon_id FROM sezon WHERE an=2024),
  DATE '2023-09-15',
  280,
  'JUP'
);
INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='MV-P6'),
  (SELECT cultura_id FROM cultura WHERE nume='Grau'),
  (SELECT sezon_id FROM sezon WHERE an=2024),
  DATE '2023-09-12',
  315,
  'Pitar'
);
INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='MV-P7'),
  (SELECT cultura_id FROM cultura WHERE nume='Porumb'),
  (SELECT sezon_id FROM sezon WHERE an=2024),
  DATE '2024-04-08',
  5,
  'Dekalb DKC4590'
);

-- AgroSud - sezon 2024
INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='SL-P1'),
  (SELECT cultura_id FROM cultura WHERE nume='Orz'),
  (SELECT sezon_id FROM sezon WHERE an=2024),
  DATE '2023-09-08',
  300,
  'JUP'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='SL-P2'),
  (SELECT cultura_id FROM cultura WHERE nume='Rapita'),
  (SELECT sezon_id FROM sezon WHERE an=2024),
  DATE '2023-09-20',
  4,
  'DK Exbury'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='SL-P3'),
  (SELECT cultura_id FROM cultura WHERE nume='Porumb'),
  (SELECT sezon_id FROM sezon WHERE an=2024),
  DATE '2024-04-02',
  5,
  'Dekalb DKC4670'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='SL-P4'),
  (SELECT cultura_id FROM cultura WHERE nume='Grau'),
  (SELECT sezon_id FROM sezon WHERE an=2024),
  DATE '2023-09-15',
  320,
  'Glosa'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='SL-P5'),
  (SELECT cultura_id FROM cultura WHERE nume='Floarea-soarelui'),
  (SELECT sezon_id FROM sezon WHERE an=2024),
  DATE '2024-04-15',
  8,
  'LG 50.797'
);
INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='SL-P6'),
  (SELECT cultura_id FROM cultura WHERE nume='Grau'),
  (SELECT sezon_id FROM sezon WHERE an=2024),
  DATE '2023-09-11',
  330,
  'GENESIS'
);
INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='SL-P7'),
  (SELECT cultura_id FROM cultura WHERE nume='Grau'),
  (SELECT sezon_id FROM sezon WHERE an=2024),
  DATE '2023-09-11',
  330,
  'Avenue'
);

-- RODAGRO GREEN - sezon 2025
INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='MV-P1'),
  (SELECT cultura_id FROM cultura WHERE nume='Porumb'),
  (SELECT sezon_id FROM sezon WHERE an=2025),
  DATE '2025-04-03',
  5,
  'Pioneer P9911'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='MV-P2'),
  (SELECT cultura_id FROM cultura WHERE nume='Rapita'),
  (SELECT sezon_id FROM sezon WHERE an=2025),
  DATE '2024-09-22',
  5,
  'DK Exception'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='MV-P3'),
  (SELECT cultura_id FROM cultura WHERE nume='Grau'),
  (SELECT sezon_id FROM sezon WHERE an=2025),
  DATE '2024-09-12',
  310,
  'Pitar'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='MV-P4'),
  (SELECT cultura_id FROM cultura WHERE nume='Orz'),
  (SELECT sezon_id FROM sezon WHERE an=2025),
  DATE '2024-09-10',
  300,
  'JUP'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='MV-P5'),
  (SELECT cultura_id FROM cultura WHERE nume='Orz'),
  (SELECT sezon_id FROM sezon WHERE an=2025),
  DATE '2024-09-10',
  300,
  'JUP'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='MV-P6'),
  (SELECT cultura_id FROM cultura WHERE nume='Grau'),
  (SELECT sezon_id FROM sezon WHERE an=2025),
  DATE '2024-09-29',
  300,
  'Glosa'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='MV-P7'),
  (SELECT cultura_id FROM cultura WHERE nume='Floarea-soarelui'),
  (SELECT sezon_id FROM sezon WHERE an=2025),
  DATE '2025-04-29',
  5,
  'SY Bacardi'
);

-- AgroSud - sezon 2025
INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='SL-P1'),
  (SELECT cultura_id FROM cultura WHERE nume='Floarea-soarelui'),
  (SELECT sezon_id FROM sezon WHERE an=2025),
  DATE '2025-04-10',
  8,
  'LG 50.797'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='SL-P2'),
  (SELECT cultura_id FROM cultura WHERE nume='Grau'),
  (SELECT sezon_id FROM sezon WHERE an=2025),
  DATE '2024-09-11',
  330,
  'Glosa'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='SL-P3'),
  (SELECT cultura_id FROM cultura WHERE nume='Porumb'),
  (SELECT sezon_id FROM sezon WHERE an=2025),
  DATE '2025-04-06',
  5,
  'Dekalb DKC5092'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='SL-P4'),
  (SELECT cultura_id FROM cultura WHERE nume='Porumb'),
  (SELECT sezon_id FROM sezon WHERE an=2025),
  DATE '2025-04-06',
  5,
  'Dekalb DKC5092'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='SL-P5'),
  (SELECT cultura_id FROM cultura WHERE nume='Orz'),
  (SELECT sezon_id FROM sezon WHERE an=2025),
  DATE '2024-09-06',
  150,
  'JUP'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='SL-P6'),
  (SELECT cultura_id FROM cultura WHERE nume='Rapita'),
  (SELECT sezon_id FROM sezon WHERE an=2025),
  DATE '2024-09-06',
  5,
  'KWS GRANOS'
);

INSERT INTO plantare (parcela_id, cultura_id, sezon_id, data_plantare, cant_samanta_kg, hibrid)
VALUES (
  (SELECT parcela_id FROM parcela WHERE denumire='SL-P7'),
  (SELECT cultura_id FROM cultura WHERE nume='Floarea-soarelui'),
  (SELECT sezon_id FROM sezon WHERE an=2025),
  DATE '2025-04-12',
  8,
  'LG 50.797'
);

-- LUCRARI (costuri + ore)
-- RODAGRO GREEN: MV-P1 sezon 2024 (grau)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P1' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Tractor JD 6155'),
  'Arat',
  DATE '2023-09-1',
  5.0,
  1200
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P1' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Stan Paul'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Amazone'),
  'Semanat',
  DATE '2023-09-10',
  4.0,
  900
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P1' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Vasilescu Ana'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Pulverizator Berthoud'),
  'Erbicidat',
  DATE '2024-05-05',
  3.0,
  750
);

INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P1' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Georgescu Elena'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine Claas Lexion'),
  'Recoltat',
  DATE '2024-07-30',
  6.0,
  1500
);

--MV-P2 sezon 2024 (porumb)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P2' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Ionescu Mihai'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Tractor JD 6155'),
  'Arat',
  DATE '2024-03-15',
  4.5,
  1100
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P2' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Stan Paul'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Amazone'),
  'Semanat',
  DATE '2024-04-05',
  4.0,
  950
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P2' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Vasilescu Ana'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine Claas Lexion'),
  'Recoltat',
  DATE '2024-08-31',
  3.5,
  800
);

--MV-P3 sezon 2024 (floarea-soarelui)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P3' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Amazone'),
  'Semanat',
  DATE '2024-04-12',
  3.5,
  850
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P3' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Vasilescu Ana'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine Claas Lexion'),
  'Recoltat',
  DATE '2024-08-28',
  4.0,
  900
);

--MV-P4 sezon 2024 (rapita)

INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P4' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Amazone'),
  'Semanat',
  DATE '2023-09-18',
  4.0,
  900
);

--MV-P4 sezon 2024 (rapita)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P4' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Georgescu Elena'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine Claas Lexion'),
  'Recoltat',
  DATE '2024-07-15',
  4.0,
  900
);

--MV-P5 sezon 2024 (orz)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P5' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Amazone'),
  'Semanat',
  DATE '2023-09-15',
  4.0,
  900
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P5' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Ionescu Mihai'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine Claas Lexion'),
  'Recoltat',
  DATE '2024-07-20',
  3.5,
  800
);

--MV-P6 sezon 2024 (grau)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P6' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Amazone'),
  'Semanat',
  DATE '2023-09-12',
  7.0,
  950
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P6' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Stan Paul'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine Claas Lexion'),
  'Recoltat',
  DATE '2024-08-05',
  4.5,
  1100
);
--MV-P7 sezon 2024 (porumb)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P7' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Amazone'),
  'Semanat',
  DATE '2024-04-08',
  3.0,
  1200
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P7' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Stan Paul'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine Claas Lexion'),
  'Recoltat',
  DATE '2024-08-25',
  5.0,
  1200
);

--MV-P1 sezon 2025 (porumb)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P1' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Amazone'),
  'Semanat',
  DATE '2025-04-03',
  4.0,
  1000
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P1' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine Claas Lexion'),
  'Recoltat',
  DATE '2025-08-30',
  5.0,
  1250
);

--MV-P2 sezon 2025 (rapita)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P2' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Amazone'),
  'Semanat',
  DATE '2024-09-22',
  4.5,
  1300
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P2' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Ionescu Mihai'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Pulverizator Berthoud'),
  'Erbicidat',
  DATE '2025-04-30',
  4.5,
  1100
);

--MV-P3 sezon 2025 (grau)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P3' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Amazone'),
  'Semanat',
  DATE '2024-09-12',
  5.0,
  1000
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P3' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Stan Paul'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine Claas Lexion'),
  'Recoltat',
  DATE '2025-08-20',
  4.0,
  950
);

--MV-P4 sezon 2025 (orz)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P4' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Amazone'),
  'Semanat',
  DATE '2024-09-10',
  4.0,
  700
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P4' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine Claas Lexion'),
  'Recoltat',
  DATE '2025-08-25',
  3.5,
  850
);

--MV-P5 sezon 2025 (orz)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P5' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Amazone'),
  'Semanat',
  DATE '2024-09-10',
  6.0,
  1000
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P5' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine Claas Lexion'),
  'Recoltat',
  DATE '2025-08-28',
  4.0,
  900
);

--MV-P6 sezon 2025 (grau)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P6' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Amazone'),
  'Semanat',
  DATE '2024-09-29',
  4.0,
  1000
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P6' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Stan Paul'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine Claas Lexion'),
  'Recoltat',
  DATE '2025-07-05',
  5.0,
  1200
);

--MV-P7 sezon 2025 (floarea-soarelui)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P7' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Amazone'),
  'Semanat',
  DATE '2024-04-29',
  4.0,
  1000
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='MV-P7' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Pop Ion'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine Claas Lexion'),
  'Recoltat',
  DATE '2025-07-10',
  4.5,
  1100
);

--SL-P1 sezon 2024 (orz)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P1' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Kuhn'),
  'Semanat', 
  DATE '2023-09-08',
  6.0,
  1500
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P1' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Vasilescu Mihai'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine New Holland'),
  'Recoltat',
  DATE '2024-08-15',
  5.0,
  1250
);

--SL-P2 sezon 2024 (rapita)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P2' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Kuhn'),
  'Semanat', 
  DATE '2023-09-20',
  6.0,
  1500
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P2' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine New Holland'),
  'Recoltat',
  DATE '2024-07-25',
  4.0,
  950
);
--SL-P3 sezon 2024 (porumb)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P3' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Kuhn'),
  'Semanat', 
  DATE '2024-04-02',
  6.0,
  1500
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P3' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Vasilescu Mihai'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine New Holland'),
  'Recoltat',
  DATE '2024-08-31',
  6.0,
  1400
);
--SL-P4 sezon 2024 (grau)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P4' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Kuhn'),
  'Semanat', 
  DATE '2023-09-15',
  6.0,
  1500
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P4' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine New Holland'),
  'Recoltat',
  DATE '2024-08-20',
  5.0,
  1200
);
--SL-P5 sezon 2024 (floarea-soarelui)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P5' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Kuhn'),
  'Semanat', 
  DATE '2024-04-15',
  6.0,
  1500
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P5' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Vasilescu Mihai'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine New Holland'),
  'Recoltat',
  DATE '2024-08-31',
  4.5,
  1100
);

--SL-P6 sezon 2024 (grau)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P6' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Kuhn'),
  'Semanat', 
  DATE '2023-09-11',
  6.0,
  1500
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P6' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine New Holland'),
  'Recoltat',
  DATE '2024-08-18',
  5.0,
  1250  
);

--SL-P7 sezon 2024 (grau)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P7' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Kuhn'),
  'Semanat', 
  DATE '2023-09-11',
  6.0,
  1500
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P7' AND s.an=2024),
  (SELECT angajat_id FROM angajat WHERE nume='Vasilescu Mihai'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine New Holland'),
  'Recoltat',
  DATE '2024-08-22',
  4.0,
  1000
);

--SL-P1 sezon 2025 (floarea-soarelui)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P1' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Kuhn'),
  'Semanat', 
  DATE '2024-04-10',
  5.0,
  1200
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P1' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine New Holland'),
  'Recoltat',
  DATE '2025-08-31',
  5.0,
  1300
);

--SL-P2 sezon 2025 (grau)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P2' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Kuhn'),
  'Semanat', 
  DATE '2024-09-11',
  5.0,
  1200
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P2' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Vasilescu Mihai'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine New Holland'),
  'Recoltat',
  DATE '2025-07-22',
  4.5,
  1150
);

--SL-P3 sezon 2025 (porumb)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P3' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Kuhn'),
  'Semanat', 
  DATE '2025-04-06',
  7.0,
  800
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (    
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P3' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine New Holland'),
  'Recoltat',
  DATE '2025-08-25',
  6.0,
  1400
);
--SL-P4 sezon 2025 (porumb)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P4' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Kuhn'),
  'Semanat', 
  DATE '2025-04-06',
  5.0,
  1200
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P4' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Vasilescu Mihai'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine New Holland'),
  'Recoltat',
  DATE '2025-08-31',
  5.5,
  1300
);

--SL-P5 sezon 2025 (orz)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P5' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Kuhn'),
  'Semanat', 
  DATE '2024-09-06',
  5.0,
  1200
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P5' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine New Holland'),
  'Recoltat',
  DATE '2025-08-30',
  4.0,
  950
);
--SL-P6 sezon 2025 (rapita)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P6' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Kuhn'),
  'Semanat', 
  DATE '2024-09-06',
  5.0,
  1200
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P6' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Vasilescu Mihai'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine New Holland'),
  'Recoltat',
  DATE '2025-07-28',
  5.0,
  1200
);
--SL-P7 sezon 2025 (floarea-soarelui)
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P7' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Semanatoare Kuhn'),
  'Semanat', 
  DATE '2025-04-12',
  5.0,
  1200
);
INSERT INTO lucrare (plantare_id, angajat_id, utilaj_id, tip_lucrare, data_lucrare, ore_lucrate, cost)
VALUES (
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   WHERE pa.denumire='SL-P7' AND s.an=2025),
  (SELECT angajat_id FROM angajat WHERE nume='Radu Stefan'),
  (SELECT utilaj_id FROM utilaj WHERE denumire='Combine New Holland'),
  'Recoltat',
  DATE '2025-07-30',
  4.5,
  1100
);


-- STOC (intrari in depozit dupa "recoltare")

-- RODAGRO GREEN: MV-P1 sezon 2024 (grau) intra in Siloz Nord + Magazie Nord
INSERT INTO stoc (depozit_id, plantare_id, data_intrare, cantitate_tone)
VALUES (
  (SELECT depozit_id FROM depozit d JOIN ferma f ON f.ferma_id=d.ferma_id WHERE f.nume='RODAGRO GREEN' AND d.nume='Siloz Nord'),
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   JOIN cultura c ON c.cultura_id=p.cultura_id
   WHERE pa.denumire='MV-P1' AND s.an=2024 AND c.nume='Grau'),
  DATE '2024-08-01',
  45.20
);

INSERT INTO stoc (depozit_id, plantare_id, data_intrare, cantitate_tone)
VALUES (
  (SELECT depozit_id FROM depozit d JOIN ferma f ON f.ferma_id=d.ferma_id WHERE f.nume='RODAGRO GREEN' AND d.nume='Magazie Nord'),
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   JOIN cultura c ON c.cultura_id=p.cultura_id
   WHERE pa.denumire='MV-P1' AND s.an=2024 AND c.nume='Grau'),
  DATE '2024-08-01',
  8.30
);

INSERT INTO stoc (depozit_id, plantare_id, data_intrare, cantitate_tone)
VALUES (
  (SELECT depozit_id FROM depozit d JOIN ferma f ON f.ferma_id=d.ferma_id WHERE f.nume='RODAGRO GREEN' AND d.nume='Siloz Nord'),
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   JOIN cultura c ON c.cultura_id=p.cultura_id
   WHERE pa.denumire='MV-P6' AND s.an=2024 AND c.nume='Grau'),
  DATE '2024-08-31',
  45.20
);

-- AgroSud: SL-P3 sezon 2024 (porumb) intra in Siloz Sud
INSERT INTO stoc (depozit_id, plantare_id, data_intrare, cantitate_tone)
VALUES (
  (SELECT depozit_id FROM depozit d JOIN ferma f ON f.ferma_id=d.ferma_id WHERE f.nume='AgroSud' AND d.nume='Siloz Sud'),
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   JOIN cultura c ON c.cultura_id=p.cultura_id
   WHERE pa.denumire='SL-P3' AND s.an=2024 AND c.nume='Porumb'),
  DATE '2024-08-31',
  72.50
);

INSERT INTO stoc (depozit_id, plantare_id, data_intrare, cantitate_tone)
VALUES (
  (SELECT depozit_id FROM depozit d JOIN ferma f ON f.ferma_id=d.ferma_id WHERE f.nume='AgroSud' AND d.nume='Siloz Sud'),
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   JOIN cultura c ON c.cultura_id=p.cultura_id
   WHERE pa.denumire='SL-P4' AND s.an=2024 AND c.nume='Grau'),
  DATE '2024-08-20',
  60.10
);

INSERT INTO stoc (depozit_id, plantare_id, data_intrare, cantitate_tone)
VALUES (
  (SELECT depozit_id FROM depozit d JOIN ferma f ON f.ferma_id=d.ferma_id WHERE f.nume='AgroSud' AND d.nume='Siloz Sud'),
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   JOIN cultura c ON c.cultura_id=p.cultura_id
   WHERE pa.denumire='SL-P6' AND s.an=2024 AND c.nume='Grau'),
  DATE '2024-08-18',
  55.75
);

INSERT INTO stoc (depozit_id, plantare_id, data_intrare, cantitate_tone)
VALUES (
  (SELECT depozit_id FROM depozit d JOIN ferma f ON f.ferma_id=d.ferma_id WHERE f.nume='AgroSud' AND d.nume='Siloz Sud'),
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   JOIN cultura c ON c.cultura_id=p.cultura_id
   WHERE pa.denumire='SL-P7' AND s.an=2024 AND c.nume='Grau'),
  DATE '2024-08-22',
  48.60
);

-- AgroSud: SL-P2 sezon 2025 (grau) intra in Magazie Sud
INSERT INTO stoc (depozit_id, plantare_id, data_intrare, cantitate_tone)
VALUES (
  (SELECT depozit_id FROM depozit d JOIN ferma f ON f.ferma_id=d.ferma_id WHERE f.nume='AgroSud' AND d.nume='Magazie Sud'),
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   JOIN cultura c ON c.cultura_id=p.cultura_id
   WHERE pa.denumire='SL-P2' AND s.an=2025 AND c.nume='Grau'),
  DATE '2025-07-25',
  60.10
);

INSERT INTO stoc (depozit_id, plantare_id, data_intrare, cantitate_tone)
VALUES (
  (SELECT depozit_id FROM depozit d JOIN ferma f ON f.ferma_id=d.ferma_id WHERE f.nume='AgroSud' AND d.nume='Siloz Sud'),
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   JOIN cultura c ON c.cultura_id=p.cultura_id
   WHERE pa.denumire='SL-P3' AND s.an=2025 AND c.nume='Porumb'),
  DATE '2025-08-25',
  72.50
);

INSERT INTO stoc (depozit_id, plantare_id, data_intrare, cantitate_tone)
VALUES (
  (SELECT depozit_id FROM depozit d JOIN ferma f ON f.ferma_id=d.ferma_id WHERE f.nume='RODAGRO GREEN' AND d.nume='Siloz Nord'),
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   JOIN cultura c ON c.cultura_id=p.cultura_id
   WHERE pa.denumire='MV-P3' AND s.an=2025 AND c.nume='Grau'),
  DATE '2025-08-20',
  72.50
);

INSERT INTO stoc (depozit_id, plantare_id, data_intrare, cantitate_tone)
VALUES (
  (SELECT depozit_id FROM depozit d JOIN ferma f ON f.ferma_id=d.ferma_id WHERE f.nume='RODAGRO GREEN' AND d.nume='Siloz Nord'),
  (SELECT p.plantare_id FROM plantare p JOIN parcela pa ON pa.parcela_id=p.parcela_id JOIN sezon s ON s.sezon_id=p.sezon_id
   JOIN cultura c ON c.cultura_id=p.cultura_id
   WHERE pa.denumire='MV-P6' AND s.an=2025 AND c.nume='Grau'),
  DATE '2025-07-05',
  60.00
);

COMMIT;
