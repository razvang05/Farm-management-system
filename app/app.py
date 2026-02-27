import os
from typing import Optional, Any, List, Dict, Tuple

import pandas as pd
import matplotlib.pyplot as plt
import oracledb

DB_USER = os.getenv("DB_USER", "FERMA_APP")
DB_PASS = os.getenv("DB_PASS", "ferma123")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = int(os.getenv("DB_PORT", "1522"))
DB_SERVICE = os.getenv("DB_SERVICE", "FARMDB")

DSN = f"{DB_HOST}:{DB_PORT}/{DB_SERVICE}"

PKG = "PKG_RAPOARTE_INTERACTIVE"

# key: (title, proc_name, param_schema)
# param_schema: list of tuples (param_name, type, default, prompt)
REPORTS: Dict[str, Tuple[str, str, List[Tuple[str, str, Any, str]]]] = {
    "1": (
        "R1: Ocupare depozite (%) pe sezon (cu prag)",
        f"{PKG}.RAPORT_OCUPARE_DEPOZITE",
        [
            ("p_prag_pct", "float_or_none", None, "Prag minim ocupare % (Enter = toate): "),
        ],
    ),
    "2": (
        "R2: Soiuri grâu - comparare profitabilitate",
        f"{PKG}.RAPORT_PROFIT_GRAU_SOI",
        [
            ("p_pret_tona", "float", None, "Preț vânzare grâu (lei/tonă): "),
            ("p_pret_samanta_kg", "float", 0.0, "Preț sămânță (lei/kg) (Enter = 0): "),
            ("p_top_n", "int", 10, "Top N soiuri (Enter = 10): "),
        ],
    ),
    "3": (
        "R3: Parcelele cele mai productive pentru o cultură",
        f"{PKG}.RAPORT_PARCele_PRODUCTIVE_CULTURA",
        [
            ("p_cultura", "string", None, "Cultură (ex: Grau, Porumb): "),
            ("p_pret_tona", "float_or_none", None, "Preț vânzare (lei/tonă) - opțional (Enter = fără profit): "),
            ("p_top_n", "int", 10, "Top N parcele (Enter = 10): "),
        ],
    ),
    "4": (
        "R4: Risc rotație (repetare cultură pe parcelă)",
        f"{PKG}.RAPORT_RISC_ROTATIE",
        [],
    ),
}


def call_report(conn: oracledb.Connection, proc_full_name: str, args: List[Any]) -> pd.DataFrame:
    """
    Apelează o procedură care întoarce SYS_REFCURSOR pe ultimul parametru.
    args = lista parametrilor IN (fără cursor). Cursorul OUT e adăugat automat.
    """
    with conn.cursor() as cur:
        out_cur = conn.cursor()
        cur.callproc(proc_full_name, [*args, out_cur])

        cols = [d[0] for d in out_cur.description]
        rows = out_cur.fetchall()
        out_cur.close()

    return pd.DataFrame(rows, columns=cols)


def show_table(title: str, df: pd.DataFrame, max_rows: int = 30):
    print("\n" + "=" * 110)
    print(title)
    print("=" * 110)
    if df.empty:
        print("(no rows)")
        return

    if len(df) > max_rows:
        print(df.head(max_rows).to_string(index=False))
        print(f"\n... afișate {max_rows} din {len(df)} rânduri")
    else:
        print(df.to_string(index=False))


def bar_chart(x, y, title: str, xlabel: str = "", ylabel: str = ""):
    plt.figure()
    plt.bar(x, y)
    plt.xticks(rotation=45, ha="right")
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.tight_layout()
    plt.show()


def plot_for_report(report_key: str, df: pd.DataFrame, an: int, ferma: Optional[str]):
    """Grafice simple pe baza coloanelor întoarse de proceduri."""
    if df.empty:
        return

    farm_label = ferma if ferma is not None else "toate fermele"

    # R1: ocupare depozite
    if report_key == "1" and {"DEPOZIT", "GRAD_OCUPARE_PCT"}.issubset(df.columns):
        top = df.sort_values("GRAD_OCUPARE_PCT", ascending=False)
        bar_chart(
            top["DEPOZIT"].astype(str),
            top["GRAD_OCUPARE_PCT"],
            f"Ocupare depozite (%) ({farm_label}, sezon {an})",
            xlabel="Depozit",
            ylabel="% ocupare",
        )

    # R2: profitabilitate soiuri grâu
    elif report_key == "2":
        soi_col = "SOI_GRAU" if "SOI_GRAU" in df.columns else ("SOI" if "SOI" in df.columns else None)
        if soi_col and "RAPORT_PROFIT_COST" in df.columns:
            top = df.sort_values("RAPORT_PROFIT_COST", ascending=False).head(10)
            bar_chart(
                top[soi_col].astype(str),
                top["RAPORT_PROFIT_COST"],
                f"Top 10 soiuri grâu - raport profit/cost ({farm_label}, sezon {an})",
                xlabel="Soi",
                ylabel="Raport profit/cost",
            )
        elif soi_col and "PROFIT_PE_HA" in df.columns:
            top = df.sort_values("PROFIT_PE_HA", ascending=False).head(10)
            bar_chart(
                top[soi_col].astype(str),
                top["PROFIT_PE_HA"],
                f"Top 10 soiuri grâu - profit/ha ({farm_label}, sezon {an})",
                xlabel="Soi",
                ylabel="Profit/ha (lei)",
            )
        elif soi_col and "COST_PE_TONA" in df.columns:
            top = df.sort_values("COST_PE_TONA", ascending=True).head(10)
            bar_chart(
                top[soi_col].astype(str),
                top["COST_PE_TONA"],
                f"Top 10 soiuri grâu - cost/tonă (mai mic=mai bine) ({farm_label}, sezon {an})",
                xlabel="Soi",
                ylabel="Cost/tonă",
            )

    # R3: Parcele productive pe cultură
    elif report_key == "3" and {"PARCELA", "TONE_PE_HA"}.issubset(df.columns):
        df_sorted = df.sort_values("TONE_PE_HA", ascending=False)
        cultura_label = df["CULTURA"].iloc[0] if "CULTURA" in df.columns and len(df) > 0 else ""
        labels = [f"{row['PARCELA']}\n{row.get('TIP_SOL', '')}" for _, row in df_sorted.iterrows()]
        bar_chart(
            labels,
            df_sorted["TONE_PE_HA"],
            f"Top parcele productive - {cultura_label} (sezon {an})",
            xlabel="Parcelă / Tip sol",
            ylabel="Producție (tone/ha)",
        )
    elif report_key == "3" and {"PARCELA", "PROFIT_PE_HA"}.issubset(df.columns):
        df_sorted = df.sort_values("PROFIT_PE_HA", ascending=False)
        df_sorted = df_sorted[df_sorted["PROFIT_PE_HA"].notna()]
        if not df_sorted.empty:
            cultura_label = df["CULTURA"].iloc[0] if "CULTURA" in df.columns and len(df) > 0 else ""
            labels = [f"{row['PARCELA']}\n{row.get('TIP_SOL', '')}" for _, row in df_sorted.iterrows()]
            bar_chart(
                labels,
                df_sorted["PROFIT_PE_HA"],
                f"Top parcele profitabile - {cultura_label} (sezon {an})",
                xlabel="Parcelă / Tip sol",
                ylabel="Profit pe hectar (lei)",
            )

    # R4: rotație (număr repetări)
    elif report_key == "4" and {"PARCELA", "ESTE_REPETARE"}.issubset(df.columns):
        agg = df.groupby("PARCELA", as_index=False)["ESTE_REPETARE"].sum()
        agg = agg.sort_values("ESTE_REPETARE", ascending=False)
        # arată doar parcelele cu repetări
        agg = agg[agg["ESTE_REPETARE"] > 0].head(15)
        if not agg.empty:
            bar_chart(
                agg["PARCELA"].astype(str),
                agg["ESTE_REPETARE"],
                f"Parcele cu repetări cultură ({farm_label}, sezon {an})",
                xlabel="Parcelă",
                ylabel="Nr repetări (față de anul anterior)",
            )


def choose_year() -> int:
    while True:
        raw = input("Alege anul sezonului (2024 sau 2025): ").strip()
        try:
            return int(raw)
        except ValueError:
            print("Te rog introdu un număr valid (ex: 2024).")


def choose_farm() -> Optional[str]:
    while True:
        raw = input("Alege ferma (rodagro / agrosud / ambele): ").strip().lower()
        if raw == "ambele":
            return None
        if raw == "rodagro":
            return "RODAGRO GREEN"
        if raw == "agrosud":
            return "AgroSud"
        print("Opțiune invalidă. Scrie: rodagro / agrosud / ambele")


def _read_param(param_type: str, default: Any, prompt: str) -> Any:
    if param_type == "string":
        val = input(prompt).strip()
        if not val:
            if default is not None:
                return default
            raise ValueError(f"Parametrul este obligatoriu!")
        return val
    elif param_type == "string_or_none":
        val = input(prompt).strip()
        if not val or val.lower() in {"none", "null", ""}:
            return None
        return val
    elif param_type == "preturi_culturi":
        print("\nIntrodu prețurile pentru fiecare cultură.")
        print("Format: CULTURA:PRET_VANZARE:PRET_SAMANTA")
        print("Exemplu: Porumb:1500:25;Grau:2000:30;Orz:1200:20")
        print("(Separe mai multe culturi cu ';')")
        raw = input(prompt).strip()
        if not raw:
            print("Eroare: Trebuie să introduci prețuri pentru cel puțin o cultură!")
            return _read_param(param_type, default, prompt)
        return raw
    
    raw = input(prompt).strip()
    if raw == "":
        return default

    try:
        if param_type == "int":
            return int(raw)
        if param_type == "int_or_none":
            if raw.lower() in {"none", "null", ""}:
                return None
            return int(raw)
        if param_type == "float":
            return float(raw)
        if param_type == "float_or_none":
            # permite "none"/"null"
            if raw.lower() in {"none", "null"}:
                return None
            return float(raw)
        if param_type == "str_or_none":
            if raw.lower() in {"none", "null"}:
                return None
            return raw
    except ValueError:
        print("Valoare invalidă. Se folosește default.")
        return default

    return default


def print_menu(an: int, ferma: Optional[str]):
    farm_label = ferma if ferma is not None else "toate fermele"
    print("\n" + "-" * 110)
    print(f"Meniu rapoarte (INTERACTIVE) | sezon: {an} | ferma: {farm_label}")
    print("-" * 110)
    for key, (title, _, _) in REPORTS.items():
        print(f"[{key}] {title}")
    print("[toate] Rulează toate rapoartele")
    print("[an] Schimbă anul")
    print("[ferma] Schimbă ferma")
    print("[exit] Ieșire")
    print("-" * 110)


def run_one(conn: oracledb.Connection, report_key: str, an: int, ferma: Optional[str]):
    title, proc, schema = REPORTS[report_key]

    # parametrii comuni: p_an, p_ferma
    args: List[Any] = [an, ferma]

    # parametri specifici raportului
    for (pname, ptype, default, prompt) in schema:
        val = _read_param(ptype, default, prompt)
        args.append(val)

    df = call_report(conn, proc, args)
    
    farm_label = ferma if ferma is not None else "toate fermele"
    show_table(f"{title} | Sezon {an} | Ferma: {farm_label}", df)
    plot_for_report(report_key, df, an, ferma)


def main():
    print(f"Connecting: {DSN} user={DB_USER}")
    conn = oracledb.connect(user=DB_USER, password=DB_PASS, dsn=DSN)

    try:
        an = choose_year()
        ferma = choose_farm()

        while True:
            print_menu(an, ferma)
            opt = input("Alege raportul/opțiunea: ").strip().lower()

            if opt == "exit":
                print("La revedere!")
                break

            if opt == "an":
                an = choose_year()
                continue

            if opt == "ferma":
                ferma = choose_farm()
                continue

            if opt == "toate":
                for key in REPORTS:
                    print("\n" + "=" * 40 + f" RULEZ RAPORTUL {key} " + "=" * 40)
                    run_one(conn, key, an, ferma)
                continue

            if opt in REPORTS:
                run_one(conn, opt, an, ferma)
            else:
                print("Opțiune invalidă. Alege un număr (1..5), sau: toate / an / ferma / exit")

    finally:
        conn.close()


if __name__ == "__main__":
    main()
