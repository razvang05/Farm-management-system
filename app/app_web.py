import os
import base64
from io import BytesIO
from typing import Optional, Any, List, Dict, Tuple

import pandas as pd
import matplotlib
matplotlib.use('Agg')  # Backend non-interactive pentru server
import matplotlib.pyplot as plt
import oracledb
from flask import Flask, render_template, request, jsonify, send_file

# Configurare DB (aceeași ca în app.py)
DB_USER = os.getenv("DB_USER", "FERMA_APP")
DB_PASS = os.getenv("DB_PASS", "ferma123")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = int(os.getenv("DB_PORT", "1522"))
DB_SERVICE = os.getenv("DB_SERVICE", "FARMDB")

DSN = f"{DB_HOST}:{DB_PORT}/{DB_SERVICE}"
PKG = "PKG_RAPOARTE_INTERACTIVE"

# Configurație rapoarte (aceeași ca în app.py)
REPORTS: Dict[str, Tuple[str, str, List[Tuple[str, str, Any, str]]]] = {
    "1": (
        "R1: Cantitatea stocata in depozite pe sezon",
        f"{PKG}.RAPORT_OCUPARE_DEPOZITE",
        [
            ("p_prag_pct", "float_or_none", None, "Prag minim ocupare %"),
        ],
    ),
    "2": (
        "R2: Soiuri grâu - comparare profitabilitate",
        f"{PKG}.RAPORT_PROFIT_GRAU_SOI",
        [
            ("p_pret_tona", "float", None, "Preț vânzare grâu (lei/tonă)"),
            ("p_pret_samanta_kg", "float", 0.0, "Preț sămânță (lei/kg)"),
            ("p_top_n", "int", 10, "Top N soiuri"),
        ],
    ),
    "3": (
        "R3: Parcelele cele mai productive pentru o cultură",
        f"{PKG}.RAPORT_PARCele_PRODUCTIVE_CULTURA",
        [
            ("p_cultura", "string", None, "Cultură (ex: Grau, Porumb)"),
            ("p_pret_tona", "float_or_none", None, "Preț vânzare (lei/tonă) - opțional"),
            ("p_top_n", "int", 10, "Top N parcele"),
        ],
    ),
    "4": (
        "R4: Risc rotație (repetare cultură)",
        f"{PKG}.RAPORT_RISC_ROTATIE",
        [],
    ),
}

app = Flask(__name__)


def get_db_connection():
    """Creează conexiune la baza de date."""
    return oracledb.connect(user=DB_USER, password=DB_PASS, dsn=DSN)


def call_report(conn: oracledb.Connection, proc_full_name: str, args: List[Any]) -> pd.DataFrame:
    """Apelează o procedură care întoarce SYS_REFCURSOR."""
    with conn.cursor() as cur:
        out_cur = conn.cursor()
        cur.callproc(proc_full_name, [*args, out_cur])
        cols = [d[0] for d in out_cur.description]
        rows = out_cur.fetchall()
        out_cur.close()
    return pd.DataFrame(rows, columns=cols)


def generate_chart_base64(report_key: str, df: pd.DataFrame, an: int, ferma: Optional[str]) -> Optional[str]:
    """Generează grafic și returnează ca base64 string."""
    if df.empty:
        return None

    farm_label = ferma if ferma is not None else "toate fermele"
    plt.figure(figsize=(10, 6))

    # R1: ocupare depozite
    if report_key == "1" and {"DEPOZIT", "GRAD_OCUPARE_PCT"}.issubset(df.columns):
        top = df.sort_values("GRAD_OCUPARE_PCT", ascending=False).head(15)
        plt.bar(range(len(top)), top["GRAD_OCUPARE_PCT"], color='steelblue')
        plt.xticks(range(len(top)), top["DEPOZIT"].astype(str), rotation=45, ha='right')
        plt.title(f"Ocupare depozite (%) - {farm_label}, sezon {an}")
        plt.xlabel("Depozit")
        plt.ylabel("% ocupare")
        plt.grid(axis='y', alpha=0.3)

    # R2: profitabilitate soiuri grâu
    elif report_key == "2":
        soi_col = "SOI_GRAU" if "SOI_GRAU" in df.columns else ("SOI" if "SOI" in df.columns else None)
        if soi_col and "RAPORT_PROFIT_COST" in df.columns:
            top = df.sort_values("RAPORT_PROFIT_COST", ascending=False).head(10)
            colors = ['green' if x >= 0 else 'red' for x in top["RAPORT_PROFIT_COST"]]
            plt.bar(range(len(top)), top["RAPORT_PROFIT_COST"], color=colors)
            plt.xticks(range(len(top)), top[soi_col].astype(str), rotation=45, ha='right')
            plt.title(f"Top 10 soiuri grâu - raport profit/cost ({farm_label}, sezon {an})")
            plt.xlabel("Soi")
            plt.ylabel("Raport profit/cost")
            plt.axhline(y=0, color='black', linestyle='-', linewidth=0.5)
            plt.grid(axis='y', alpha=0.3)
        elif soi_col and "PROFIT_PE_HA" in df.columns:
            top = df.sort_values("PROFIT_PE_HA", ascending=False).head(10)
            colors = ['green' if x >= 0 else 'red' for x in top["PROFIT_PE_HA"]]
            plt.bar(range(len(top)), top["PROFIT_PE_HA"], color=colors)
            plt.xticks(range(len(top)), top[soi_col].astype(str), rotation=45, ha='right')
            plt.title(f"Top 10 soiuri grâu - profit/ha ({farm_label}, sezon {an})")
            plt.xlabel("Soi")
            plt.ylabel("Profit/ha (lei)")
            plt.axhline(y=0, color='black', linestyle='-', linewidth=0.5)
            plt.grid(axis='y', alpha=0.3)
        elif soi_col and "COST_PE_TONA" in df.columns:
            top = df.sort_values("COST_PE_TONA", ascending=True).head(10)
            plt.barh(range(len(top)), top["COST_PE_TONA"], color='green')
            plt.yticks(range(len(top)), top[soi_col].astype(str))
            plt.title(f"Top 10 soiuri grâu - cost/tonă ({farm_label}, sezon {an})")
            plt.xlabel("Cost/tonă")
            plt.ylabel("Soi")
            plt.grid(axis='x', alpha=0.3)

    # R3: Parcele productive pe cultură
    elif report_key == "3" and {"PARCELA", "TONE_PE_HA"}.issubset(df.columns):
        df_sorted = df.sort_values("TONE_PE_HA", ascending=False)
        plt.bar(range(len(df_sorted)), df_sorted["TONE_PE_HA"], color='green')
        labels = [f"{row['PARCELA']}\n{row.get('TIP_SOL', '')}" for _, row in df_sorted.iterrows()]
        plt.xticks(range(len(df_sorted)), labels, rotation=45, ha='right', fontsize=8)
        cultura_label = df["CULTURA"].iloc[0] if "CULTURA" in df.columns and len(df) > 0 else ""
        plt.title(f"Top parcele productive - {cultura_label} (sezon {an})")
        plt.xlabel("Parcelă / Tip sol")
        plt.ylabel("Producție (tone/ha)")
        plt.grid(axis='y', alpha=0.3)
    elif report_key == "3" and {"PARCELA", "PROFIT_PE_HA"}.issubset(df.columns):
        df_sorted = df.sort_values("PROFIT_PE_HA", ascending=False)
        df_sorted = df_sorted[df_sorted["PROFIT_PE_HA"].notna()]
        if not df_sorted.empty:
            plt.bar(range(len(df_sorted)), df_sorted["PROFIT_PE_HA"], color='blue')
            labels = [f"{row['PARCELA']}\n{row.get('TIP_SOL', '')}" for _, row in df_sorted.iterrows()]
            plt.xticks(range(len(df_sorted)), labels, rotation=45, ha='right', fontsize=8)
            cultura_label = df["CULTURA"].iloc[0] if "CULTURA" in df.columns and len(df) > 0 else ""
            plt.title(f"Top parcele profitabile - {cultura_label} (sezon {an})")
            plt.xlabel("Parcelă / Tip sol")
            plt.ylabel("Profit pe hectar (lei)")
            plt.axhline(y=0, color='black', linestyle='-', linewidth=0.5)
            plt.grid(axis='y', alpha=0.3)

    # R4: rotație
    elif report_key == "4" and {"PARCELA", "ESTE_REPETARE"}.issubset(df.columns):
        agg = df.groupby("PARCELA", as_index=False)["ESTE_REPETARE"].sum()
        agg = agg[agg["ESTE_REPETARE"] > 0].sort_values("ESTE_REPETARE", ascending=False).head(15)
        if not agg.empty:
            plt.bar(range(len(agg)), agg["ESTE_REPETARE"], color='red')
            plt.xticks(range(len(agg)), agg["PARCELA"].astype(str), rotation=45, ha='right')
            plt.title(f"Parcele cu repetări cultură ({farm_label}, sezon {an})")
            plt.xlabel("Parcelă")
            plt.ylabel("Nr repetări")
            plt.grid(axis='y', alpha=0.3)
        else:
            plt.close()
            return None
    else:
        plt.close()
        return None

    plt.tight_layout()
    
    # Convertim graficul în base64
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', dpi=100, bbox_inches='tight')
    img_buffer.seek(0)
    img_base64 = base64.b64encode(img_buffer.getvalue()).decode('utf-8')
    plt.close()
    
    return img_base64


def get_culturi(conn: oracledb.Connection) -> List[str]:
    """Obține lista de culturi din baza de date."""
    with conn.cursor() as cur:
        cur.execute("SELECT DISTINCT nume FROM cultura ORDER BY nume")
        return [row[0] for row in cur.fetchall()]


@app.route('/')
def index():
    """Pagina principală cu meniul rapoartelor."""
    return render_template('index.html', reports=REPORTS)


@app.route('/raport/<report_key>', methods=['GET', 'POST'])
def raport(report_key: str):
    """Generează și afișează un raport."""
    if report_key not in REPORTS:
        return jsonify({"error": "Raport invalid"}), 404

    title, proc, schema = REPORTS[report_key]

    if request.method == 'GET':
        # Afișează formularul pentru parametri
        # Pentru raportul R3, obține lista de culturi (pentru dropdown opțional)
        culturi = []
        if report_key == "3":
            conn = get_db_connection()
            try:
                culturi = get_culturi(conn)
            finally:
                conn.close()
        
        return render_template('raport_form.html', 
                               report_key=report_key, 
                               title=title, 
                               schema=schema,
                               culturi=culturi)

    # POST: procesează formularul
    try:
        an = int(request.form.get('an', 2024))
        ferma_raw = request.form.get('ferma', '').strip()
        ferma = None if ferma_raw.lower() in ('', 'ambele', 'toate') else ferma_raw

        # Parametrii comuni: p_an, p_ferma
        args: List[Any] = [an, ferma]

        # Parametrii specifici raportului
        for idx, (pname, ptype, default, _) in enumerate(schema):
            val_raw = request.form.get(pname, '').strip()
            
            if val_raw == '':
                if default is not None:
                    val = default
                elif ptype == "float" or ptype == "int":
                    # Pentru float/int obligatoriu, aruncă eroare
                    return render_template('error.html', 
                                         error=f"Parametrul '{pname}' este obligatoriu!"), 400
                else:
                    val = default
            elif ptype == "int":
                val = int(val_raw)
            elif ptype == "int_or_none":
                if val_raw.lower() in {"none", "null", ""}:
                    val = None
                else:
                    val = int(val_raw)
            elif ptype == "float":
                val = float(val_raw)
            elif ptype == "float_or_none":
                if val_raw.lower() in {"none", "null", ""}:
                    val = None
                else:
                    val = float(val_raw)
            elif ptype == "string":
                if not val_raw:
                    return render_template('error.html', 
                                         error=f"Parametrul '{pname}' este obligatoriu!"), 400
                val = val_raw
            elif ptype == "string_or_none":
                if not val_raw or val_raw.lower() in {"none", "null", ""}:
                    val = None
                else:
                    val = val_raw
            elif ptype == "preturi_culturi":
                # Construiește string-ul cu prețuri: "CULTURA1:PRET_VANZARE1:PRET_SAMANTA1;CULTURA2:PRET_VANZARE2:PRET_SAMANTA2;..."
                preturi_list = []
                conn = get_db_connection()
                try:
                    culturi = get_culturi(conn)
                    for cultura in culturi:
                        pret_vanzare = request.form.get(f'pret_vanzare_{cultura}', '').strip()
                        pret_samanta = request.form.get(f'pret_samanta_{cultura}', '').strip()
                        if pret_vanzare and pret_samanta:
                            try:
                                pv = float(pret_vanzare)
                                ps = float(pret_samanta)
                                # Adaugă doar dacă ambele prețuri sunt > 0
                                if pv > 0 and ps > 0:
                                    preturi_list.append(f"{cultura}:{pv}:{ps}")
                            except ValueError:
                                pass  # Ignoră valori invalide
                finally:
                    conn.close()
                val = ';'.join(preturi_list)
                if not val:
                    return render_template('error.html', 
                                         error="Trebuie să introduci prețuri pentru cel puțin o cultură!"), 400
            else:
                val = default
            
            args.append(val)

        # Apelează raportul
        conn = get_db_connection()
        try:
            df = call_report(conn, proc, args)
            chart_base64 = generate_chart_base64(report_key, df, an, ferma)
            
            # Convertim DataFrame în HTML
            df_html = df.to_html(classes='table table-striped table-hover table-sm', 
                                 table_id='raport-table',
                                 index=False,
                                 escape=False)
            
            farm_label = ferma if ferma is not None else "toate fermele"
            
            return render_template('raport_result.html',
                                 title=title,
                                 an=an,
                                 ferma=farm_label,
                                 df_html=df_html,
                                 row_count=len(df),
                                 chart_base64=chart_base64,
                                 report_key=report_key)
        finally:
            conn.close()

    except Exception as e:
        return render_template('error.html', error=str(e)), 500


@app.route('/export/<report_key>', methods=['POST'])
def export_csv(report_key: str):
    """Exportă raportul în CSV."""
    # Reconstruim parametrii din form
    # (simplificat - în producție ar trebui să salvezi parametrii în session)
    return jsonify({"error": "Funcționalitate în dezvoltare"}), 501


if __name__ == '__main__':
    print(f"[WEB] Starting Flask app...")
    print(f"[WEB] Connecting to: {DSN} user={DB_USER}")
    # Debug mode doar dacă nu suntem în Docker (detectăm prin env var)
    debug_mode = os.getenv('FLASK_DEBUG', 'False').lower() == 'true'
    port = int(os.getenv("FLASK_PORT", "5001"))
    print(f"[WEB] Open http://localhost:{port} in your browser")
    app.run(debug=debug_mode, host='0.0.0.0', port=port)
