#!/bin/sh
set -eu

echo "[WEB] DB target: ${DB_HOST:-oracle}:${DB_PORT:-1521}/${DB_SERVICE:-FARMDB} user=${DB_USER:-FERMA_APP}"

# Wait for Oracle to accept connections
python3 - <<'PY'
import os, time
import oracledb

user = os.getenv('DB_USER', 'FERMA_APP')
pw = os.getenv('DB_PASS', 'ferma123')
host = os.getenv('DB_HOST', 'oracle')
port = int(os.getenv('DB_PORT', '1521'))
service = os.getenv('DB_SERVICE', 'FARMDB')
dsn = f"{host}:{port}/{service}"

for i in range(1, 121):
    try:
        conn = oracledb.connect(user=user, password=pw, dsn=dsn)
        conn.close()
        print(f"[WEB] Oracle is up ({dsn})")
        break
    except Exception as e:
        if i == 120:
            raise
        time.sleep(2)
        if i % 10 == 0:
            print(f"[WEB] waiting for Oracle... ({i*2}s)")
PY

# Initialize schema/packages/seed/triggers (idempotent thanks to cleanup)
echo "[WEB] Initializing DB (init_db.py)..."
python3 /srv/app/app/init_db.py

echo "[WEB] Starting Flask server on 0.0.0.0:5000"
exec python3 /srv/app/app/app_web.py
