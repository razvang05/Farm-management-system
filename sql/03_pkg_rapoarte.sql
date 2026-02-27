CREATE OR REPLACE PACKAGE pkg_rapoarte_interactive AS

  PROCEDURE raport_ocupare_depozite (
    p_an        IN  NUMBER,
    p_ferma     IN  VARCHAR2 DEFAULT NULL,
    p_prag_pct  IN  NUMBER   DEFAULT NULL,
    p_cursor    OUT SYS_REFCURSOR
  );


  PROCEDURE raport_profit_grau_soi (
    p_an               IN  NUMBER,
    p_ferma            IN  VARCHAR2 DEFAULT NULL,
    p_pret_tona        IN  NUMBER,   -- Preț vânzare grâu (lei/tonă)
    p_pret_samanta_kg  IN  NUMBER   DEFAULT 0,     -- lei / kg
    p_top_n            IN  NUMBER   DEFAULT 10,
    p_cursor           OUT SYS_REFCURSOR
  );

 
  PROCEDURE raport_parcele_productive_cultura (
    p_an        IN  NUMBER,
    p_ferma     IN  VARCHAR2 DEFAULT NULL,
    p_cultura   IN  VARCHAR2,
    p_pret_tona IN  NUMBER   DEFAULT NULL,
    p_top_n     IN  NUMBER   DEFAULT 10,
    p_cursor    OUT SYS_REFCURSOR
  );

  PROCEDURE raport_risc_rotatie (
    p_an             IN  NUMBER,
    p_ferma          IN  VARCHAR2 DEFAULT NULL,
    p_cursor         OUT SYS_REFCURSOR
  );

END pkg_rapoarte_interactive;
/

CREATE OR REPLACE PACKAGE BODY pkg_rapoarte_interactive AS

  -- R1: Grad de ocupare depozite
  PROCEDURE raport_ocupare_depozite (
    p_an        IN  NUMBER,
    p_ferma     IN  VARCHAR2 DEFAULT NULL,
    p_prag_pct  IN  NUMBER   DEFAULT NULL,
    p_cursor    OUT SYS_REFCURSOR
  ) IS
  BEGIN
    OPEN p_cursor FOR
      WITH stoc_sezon AS (
        SELECT
          d.depozit_id,
          SUM(st.cantitate_tone) AS tone_total
        FROM depozit d
        LEFT JOIN stoc st     ON st.depozit_id = d.depozit_id
        LEFT JOIN plantare p  ON p.plantare_id = st.plantare_id
        LEFT JOIN sezon s     ON s.sezon_id = p.sezon_id
                            AND s.an = p_an
        GROUP BY d.depozit_id
      )
      SELECT
        f.nume AS ferma,
        p_an   AS sezon,
        d.nume AS depozit,
        d.tip  AS tip_depozit,
        d.capacitate_tone,
        NVL(ss.tone_total,0) AS tone_stocate,
        ROUND(
          (NVL(ss.tone_total,0) / NULLIF(d.capacitate_tone,0)) * 100,
          2
        ) AS grad_ocupare_pct,
        ROUND(d.capacitate_tone - NVL(ss.tone_total,0), 2) AS tone_libere
      FROM depozit d
      JOIN ferma f ON f.ferma_id = d.ferma_id
      LEFT JOIN stoc_sezon ss ON ss.depozit_id = d.depozit_id
      WHERE (p_ferma IS NULL OR f.nume = p_ferma)
        AND (p_prag_pct IS NULL OR
              ROUND(
               (NVL(ss.tone_total,0) / NULLIF(d.capacitate_tone,0)) * 100,
                2
              ) >= p_prag_pct)
      ORDER BY f.nume, grad_ocupare_pct DESC, d.nume;
  END raport_ocupare_depozite;


  -- R2: Grau pe soi - eficienta / profitabilitate
  PROCEDURE raport_profit_grau_soi (
    p_an               IN  NUMBER,
    p_ferma            IN  VARCHAR2 DEFAULT NULL,
    p_pret_tona        IN  NUMBER,
    p_pret_samanta_kg  IN  NUMBER   DEFAULT 0,
    p_top_n            IN  NUMBER   DEFAULT 10,
    p_cursor           OUT SYS_REFCURSOR
  ) IS
  BEGIN
    OPEN p_cursor FOR
      WITH prod AS (
        SELECT
          f.ferma_id,
          NVL(p.hibrid,'(nespecificat)') AS soi,
          SUM(st.cantitate_tone) AS tone_total
        FROM stoc st
        JOIN plantare p ON p.plantare_id = st.plantare_id
        JOIN cultura c  ON c.cultura_id = p.cultura_id
        JOIN parcela pa ON pa.parcela_id = p.parcela_id
        JOIN ferma f    ON f.ferma_id = pa.ferma_id
        JOIN sezon s    ON s.sezon_id = p.sezon_id
        WHERE s.an = p_an
          AND c.nume = 'Grau'
          AND (p_ferma IS NULL OR f.nume = p_ferma)
        GROUP BY f.ferma_id, NVL(p.hibrid,'(nespecificat)')
      ),
      sup_sam AS (
        SELECT
          f.ferma_id,
          NVL(p.hibrid,'(nespecificat)') AS soi,
          SUM(pa.suprafata_ha) AS suprafata_ha,
          SUM(NVL(p.cant_samanta_kg,0)) AS samanta_kg
        FROM plantare p
        JOIN cultura c  ON c.cultura_id = p.cultura_id
        JOIN parcela pa ON pa.parcela_id = p.parcela_id
        JOIN ferma f    ON f.ferma_id = pa.ferma_id
        JOIN sezon s    ON s.sezon_id = p.sezon_id
        WHERE s.an = p_an
          AND c.nume = 'Grau'
          AND (p_ferma IS NULL OR f.nume = p_ferma)
        GROUP BY f.ferma_id, NVL(p.hibrid,'(nespecificat)')
      ),
      costuri AS (
        SELECT
          f.ferma_id,
          NVL(p.hibrid,'(nespecificat)') AS soi,
          SUM(l.cost) AS cost_lucrari
        FROM lucrare l
        JOIN plantare p ON p.plantare_id = l.plantare_id
        JOIN cultura c  ON c.cultura_id = p.cultura_id
        JOIN parcela pa ON pa.parcela_id = p.parcela_id
        JOIN ferma f    ON f.ferma_id = pa.ferma_id
        JOIN sezon s    ON s.sezon_id = p.sezon_id
        WHERE s.an = p_an
          AND c.nume = 'Grau'
          AND (p_ferma IS NULL OR f.nume = p_ferma)
        GROUP BY f.ferma_id, NVL(p.hibrid,'(nespecificat)')
      )
      SELECT *
      FROM (
        SELECT
          f.nume AS ferma,
          p_an   AS sezon,
          ss.soi AS soi_grau,
          ROUND(NVL(pr.tone_total,0),2) AS productie_tone,
          ROUND(NVL(ss.suprafata_ha,0),2) AS suprafata_ha,
          ROUND(NVL(cs.cost_lucrari,0),2) AS cost_lucrari,
          ROUND(NVL(ss.samanta_kg,0) * p_pret_samanta_kg,2) AS cost_samanta,
          ROUND(
            (NVL(cs.cost_lucrari,0) + NVL(ss.samanta_kg,0) * p_pret_samanta_kg)
            / NULLIF(NVL(ss.suprafata_ha,0),0),
            2
          ) AS cost_pe_ha,
          ROUND(
            (NVL(pr.tone_total,0) * p_pret_tona)
            - (NVL(cs.cost_lucrari,0) + NVL(ss.samanta_kg,0) * p_pret_samanta_kg),
            2
          ) AS profit_total,
          ROUND(
            ((NVL(pr.tone_total,0) * p_pret_tona)
            - (NVL(cs.cost_lucrari,0) + NVL(ss.samanta_kg,0) * p_pret_samanta_kg))
            / NULLIF(NVL(ss.suprafata_ha,0),0),
            2
          ) AS profit_pe_ha,
          ROUND(
            ((NVL(pr.tone_total,0) * p_pret_tona)
            - (NVL(cs.cost_lucrari,0) + NVL(ss.samanta_kg,0) * p_pret_samanta_kg))
            / NULLIF((NVL(cs.cost_lucrari,0) + NVL(ss.samanta_kg,0) * p_pret_samanta_kg),0),
            2
          ) AS raport_profit_cost

        FROM sup_sam ss
        JOIN ferma f ON f.ferma_id = ss.ferma_id
        LEFT JOIN prod pr ON pr.ferma_id = ss.ferma_id AND pr.soi = ss.soi
        LEFT JOIN costuri cs ON cs.ferma_id = ss.ferma_id AND cs.soi = ss.soi
        WHERE NVL(pr.tone_total,0) > 0
        ORDER BY raport_profit_cost DESC NULLS LAST
      )
      FETCH FIRST NVL(p_top_n,10) ROWS ONLY;
  END raport_profit_grau_soi;


  -- R3: Parcelele cele mai productive pentru o cultură
  PROCEDURE raport_parcele_productive_cultura (
    p_an        IN  NUMBER,
    p_ferma     IN  VARCHAR2 DEFAULT NULL,
    p_cultura   IN  VARCHAR2,
    p_pret_tona IN  NUMBER   DEFAULT NULL,
    p_top_n     IN  NUMBER   DEFAULT 10,
    p_cursor    OUT SYS_REFCURSOR
  ) IS
  BEGIN
    OPEN p_cursor FOR
      WITH baza AS (
        SELECT
          f.ferma_id,
          f.nume AS ferma,
          pa.parcela_id,
          pa.denumire AS parcela,
          NVL(pa.tip_sol,'(nespecificat)') AS tip_sol,
          pa.suprafata_ha,
          c.cultura_id,
          c.nume AS cultura,
          p.plantare_id
        FROM plantare p
        JOIN parcela pa ON pa.parcela_id = p.parcela_id
        JOIN ferma   f  ON f.ferma_id = pa.ferma_id
        JOIN cultura c  ON c.cultura_id = p.cultura_id
        JOIN sezon   s  ON s.sezon_id = p.sezon_id
        WHERE s.an = p_an
          AND (p_ferma IS NULL OR f.nume = p_ferma)
          AND UPPER(TRIM(c.nume)) = UPPER(TRIM(p_cultura))
      ),
      prod AS (
        SELECT
          b.ferma_id,
          b.parcela_id,
          b.cultura_id,
          SUM(NVL(st.cantitate_tone,0)) AS tone_total
        FROM baza b
        LEFT JOIN stoc st ON st.plantare_id = b.plantare_id
        GROUP BY b.ferma_id, b.parcela_id, b.cultura_id
      ),
      costuri AS (
        SELECT
          b.ferma_id,
          b.parcela_id,
          b.cultura_id,
          SUM(NVL(l.cost,0)) AS cost_total,
          SUM(NVL(l.ore_lucrate,0)) AS ore_total
        FROM baza b
        LEFT JOIN lucrare l ON l.plantare_id = b.plantare_id
        GROUP BY b.ferma_id, b.parcela_id, b.cultura_id
      )
      SELECT *
      FROM (
        SELECT
          b.ferma,
          p_an AS sezon,
          b.cultura,
          b.parcela,
          b.tip_sol,
          ROUND(b.suprafata_ha,2) AS suprafata_ha,

          ROUND(NVL(p2.tone_total,0),2) AS productie_tone,
          ROUND(NVL(p2.tone_total,0) / NULLIF(b.suprafata_ha,0), 2) AS tone_pe_ha,

          ROUND(NVL(c2.cost_total,0),2) AS cost_total,
          ROUND(NVL(c2.cost_total,0) / NULLIF(b.suprafata_ha,0), 2) AS cost_pe_ha,
          ROUND(NVL(c2.ore_total,0),2)  AS ore_total,

          -- venit/profit doar daca exista pret
          CASE WHEN p_pret_tona IS NULL THEN NULL
               ELSE ROUND(NVL(p2.tone_total,0) * p_pret_tona, 2)
          END AS venit_total,

          CASE WHEN p_pret_tona IS NULL THEN NULL
               ELSE ROUND((NVL(p2.tone_total,0) * p_pret_tona) / NULLIF(b.suprafata_ha,0), 2)
          END AS venit_pe_ha,

          CASE WHEN p_pret_tona IS NULL THEN NULL
               ELSE ROUND((NVL(p2.tone_total,0) * p_pret_tona) - NVL(c2.cost_total,0), 2)
          END AS profit_total,

          CASE WHEN p_pret_tona IS NULL THEN NULL
               ELSE ROUND(((NVL(p2.tone_total,0) * p_pret_tona) - NVL(c2.cost_total,0)) / NULLIF(b.suprafata_ha,0), 2)
          END AS profit_pe_ha

        FROM (
          SELECT DISTINCT ferma_id, ferma, parcela_id, parcela, tip_sol, suprafata_ha, cultura_id, cultura
          FROM baza
        ) b
        LEFT JOIN prod   p2 ON p2.ferma_id=b.ferma_id AND p2.parcela_id=b.parcela_id AND p2.cultura_id=b.cultura_id
        LEFT JOIN costuri c2 ON c2.ferma_id=b.ferma_id AND c2.parcela_id=b.parcela_id AND c2.cultura_id=b.cultura_id

        WHERE NVL(p2.tone_total,0) > 0

        ORDER BY tone_pe_ha DESC, profit_pe_ha DESC NULLS LAST, b.parcela
      )
      FETCH FIRST NVL(p_top_n,10) ROWS ONLY;
  END raport_parcele_productive_cultura;




  -- R4: Risc de rotatie necorespunzatoare a culturilor
  PROCEDURE raport_risc_rotatie (
    p_an             IN  NUMBER,
    p_ferma          IN  VARCHAR2 DEFAULT NULL,
    p_cursor         OUT SYS_REFCURSOR
  ) IS
  BEGIN
    OPEN p_cursor FOR
      WITH istoric AS (
        SELECT
          f.nume AS ferma,
          pa.denumire AS parcela,
          s.an AS sezon,
          c.nume AS cultura,
          LAG(c.nume) OVER (
            PARTITION BY f.ferma_id, pa.parcela_id
            ORDER BY s.an
          ) AS cultura_anterior,
          LAG(s.an) OVER (
            PARTITION BY f.ferma_id, pa.parcela_id
            ORDER BY s.an
          ) AS sezon_anterior
        FROM plantare p
        JOIN parcela pa ON pa.parcela_id = p.parcela_id
        JOIN ferma f    ON f.ferma_id = pa.ferma_id
        JOIN cultura c  ON c.cultura_id = p.cultura_id
        JOIN sezon s    ON s.sezon_id = p.sezon_id
        WHERE s.an <= p_an
          AND (p_ferma IS NULL OR f.nume = p_ferma)
      ),
      evaluare AS (
        SELECT
          ferma,
          parcela,
          sezon,
          cultura,
          sezon_anterior,
          cultura_anterior,
          CASE
            WHEN cultura_anterior IS NULL THEN 0
            WHEN cultura = cultura_anterior THEN 1
            ELSE 0
          END AS este_repetare
        FROM istoric
      )
      SELECT
        ferma,
        parcela,
        sezon,
        cultura,
        sezon_anterior,
        cultura_anterior,
        este_repetare
      FROM evaluare
      WHERE este_repetare = 1
      GROUP BY
        ferma, parcela, sezon, cultura, sezon_anterior, cultura_anterior, este_repetare
      HAVING sezon = p_an
      ORDER BY ferma, parcela, sezon;
  END raport_risc_rotatie;


END pkg_rapoarte_interactive;
/
