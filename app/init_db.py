import os
from typing import List

import oracledb

DB_USER = os.getenv("DB_USER", "FERMA_APP")
DB_PASS = os.getenv("DB_PASS", "ferma123")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = int(os.getenv("DB_PORT", "1522"))
DB_SERVICE = os.getenv("DB_SERVICE", "FARMDB")

DSN = f"{DB_HOST}:{DB_PORT}/{DB_SERVICE}"
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SQL_DIR = os.path.join(BASE_DIR, "..", "sql")

SQL_BOOTSTRAP_FILES = [
    "00_cleanup.sql",
    "01_schema.sql",
    "03_pkg_rapoarte.sql",
    "02_seed.sql",
    "04_triggers.sql",
]


def split_sqlplus_style(script: str) -> List[str]:
    """
    Suport:
    - '/' pe linie separată = terminator pentru PL/SQL (PACKAGE/TRIGGER/BEGIN..END)
    - pentru restul, separă statement-urile pe ';'
    Ignoră comenzi SQL*Plus gen SET/PROMPT/WHENEVER/EXIT.
    """
    lines = script.splitlines()
    chunks: List[str] = []
    buf: List[str] = []

    def flush_buf():
        text = "\n".join(buf).strip()
        if text:
            chunks.append(text)
        buf.clear()

    for ln in lines:
        stripped = ln.strip()

        if stripped.upper().startswith(
            ("SET ", "PROMPT ", "WHENEVER ", "SPOOL ", "EXIT", "SHOW ")
        ):
            continue

        if stripped == "/":
            flush_buf()
            continue

        buf.append(ln)

    flush_buf()

    final: List[str] = []
    for ch in chunks:
        # Important: a chunk may start with comments (e.g. "-- 00_cleanup.sql")
        # but still be a PL/SQL block. Detect PL/SQL by looking at the first
        # meaningful (non-empty, non-comment) line.
        first_meaningful = ""
        for ln in ch.splitlines():
            s = ln.strip()
            if not s:
                continue
            if s.startswith("--"):
                continue
            first_meaningful = s
            break

        upper = first_meaningful.upper()
        is_plsql_like = (
            upper.startswith("CREATE OR REPLACE PACKAGE")
            or upper.startswith("CREATE OR REPLACE PACKAGE BODY")
            or upper.startswith("CREATE OR REPLACE PROCEDURE")
            or upper.startswith("CREATE OR REPLACE TRIGGER")
            or upper.startswith("BEGIN")
            or upper.startswith("DECLARE")
        )
        if is_plsql_like:
            final.append(ch)
        else:
            final.extend([p.strip() for p in ch.split(";") if p.strip()])

    return final


def run_sql_file(conn: oracledb.Connection, path: str):
    print(f"\n[INIT] Running: {path}")
    with open(path, "r", encoding="utf-8") as f:
        script = f.read()

    stmts = split_sqlplus_style(script)

    with conn.cursor() as cur:
        for i, stmt in enumerate(stmts, start=1):
            try:
                cur.execute(stmt)
            except Exception as e:
                print(f"\n[INIT] ERROR in {path} at statement #{i}")
                print(stmt[:1200] + ("..." if len(stmt) > 1200 else ""))
                raise


def main():
    print(f"[INIT] Connecting: {DSN} user={DB_USER}")
    conn = oracledb.connect(user=DB_USER, password=DB_PASS, dsn=DSN)

    try:
        for fname in SQL_BOOTSTRAP_FILES:
            fpath = os.path.join(SQL_DIR, fname)
            if not os.path.exists(fpath):
                print(f"[INIT] Missing file, skipped: {fpath}")
                continue
            run_sql_file(conn, fpath)

        conn.commit()
        print("\n[INIT] DONE OK. Schema + packages + seed + triggers loaded.")
    finally:
        conn.close()


if __name__ == "__main__":
    main()
