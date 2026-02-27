-- 04_triggers.sql

-- 1) Lucrare: angajat + utilaj trebuie sa apartina aceleiasi ferme ca plantarea
CREATE OR REPLACE TRIGGER trg_lucrare_ferma_chk
BEFORE INSERT OR UPDATE ON lucrare
FOR EACH ROW
DECLARE
  v_ferma_plantare NUMBER;
  v_ferma_angajat  NUMBER;
  v_ferma_utilaj   NUMBER;
BEGIN
  -- Ferma plantarii
  SELECT pa.ferma_id
    INTO v_ferma_plantare
    FROM plantare p
    JOIN parcela pa ON pa.parcela_id = p.parcela_id
   WHERE p.plantare_id = :NEW.plantare_id;

  -- Ferma angajatului
  SELECT a.ferma_id
    INTO v_ferma_angajat
    FROM angajat a
   WHERE a.angajat_id = :NEW.angajat_id;

  IF v_ferma_angajat <> v_ferma_plantare THEN
    RAISE_APPLICATION_ERROR(-20001, 'Angajatul nu apartine fermei plantarii.');
  END IF;

  -- Ferma utilajului
  IF :NEW.utilaj_id IS NOT NULL THEN
    SELECT u.ferma_id
      INTO v_ferma_utilaj
      FROM utilaj u
     WHERE u.utilaj_id = :NEW.utilaj_id;

    IF v_ferma_utilaj <> v_ferma_plantare THEN
      RAISE_APPLICATION_ERROR(-20002, 'Utilajul nu apartine fermei plantarii.');
    END IF;
  END IF;
END;
/
SHOW ERRORS TRIGGER trg_lucrare_ferma_chk;

-- 2) STOC: depozitul trebuie sa fie in aceeasi ferma ca plantarea
CREATE OR REPLACE TRIGGER trg_stoc_ferma_chk
BEFORE INSERT OR UPDATE ON stoc
FOR EACH ROW
DECLARE
  v_ferma_plantare NUMBER;
  v_ferma_depozit  NUMBER;
BEGIN
  -- Ferma plantarii (prin parcela)
  SELECT pa.ferma_id
    INTO v_ferma_plantare
    FROM plantare p
    JOIN parcela pa ON pa.parcela_id = p.parcela_id
   WHERE p.plantare_id = :NEW.plantare_id;

  -- Ferma depozitului
  SELECT d.ferma_id
    INTO v_ferma_depozit
    FROM depozit d
   WHERE d.depozit_id = :NEW.depozit_id;

  IF v_ferma_depozit <> v_ferma_plantare THEN
    RAISE_APPLICATION_ERROR(-20003, 'Depozitul nu apartine fermei plantarii.');
  END IF;
END;
/
SHOW ERRORS TRIGGER trg_stoc_ferma_chk;

-- 3) STOC: nu permite depasirea capacitatii depozitului (tone)
--    Verifica totalul stocat pe depozit + cantitatea noua
CREATE OR REPLACE TRIGGER trg_stoc_capacitate_chk
BEFORE INSERT OR UPDATE ON stoc
FOR EACH ROW
DECLARE
  v_capacitate    depozit.capacitate_tone%TYPE;
  v_total_curent  NUMBER;
  v_total_nou     NUMBER;
BEGIN
  -- Capacitatea depozitului
  SELECT d.capacitate_tone
    INTO v_capacitate
    FROM depozit d
   WHERE d.depozit_id = :NEW.depozit_id;

  -- Total deja stocat in acel depozit
  SELECT NVL(SUM(s.cantitate_tone), 0)
    INTO v_total_curent
    FROM stoc s
   WHERE s.depozit_id = :NEW.depozit_id
     AND (:NEW.stoc_id IS NULL OR s.stoc_id <> :NEW.stoc_id);

  v_total_nou := v_total_curent + NVL(:NEW.cantitate_tone, 0);

  IF v_total_nou > v_capacitate THEN
    RAISE_APPLICATION_ERROR(
      -20004,
      'Depasire capacitate depozit. Total ar deveni ' || TO_CHAR(ROUND(v_total_nou,2)) ||
      ' tone, capacitate=' || TO_CHAR(ROUND(v_capacitate,2)) || ' tone.'
    );
  END IF;
END;
/
SHOW ERRORS TRIGGER trg_stoc_capacitate_chk;
