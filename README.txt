                    PROIECT BD2 - SISTEM DE GESTIUNE FERMA

CONȚINUT ARHIVĂ:
- documentatie.pdf
- README.txt (acest fișier)
- docker-compose.yml
- .env.example
- .dockerignore
- sql/ (00_cleanup.sql, 01_schema.sql, 02_seed.sql, 03_pkg_rapoarte.sql, 04_triggers.sql)
- app/ (app_web.py, init_db.py, requirements.txt, Dockerfile, docker-entrypoint.sh, templates/)
- 

INSTRUCȚIUNI DE INSTALARE:

1. Dezarhivați arhiva și deschideți proiectul în VS Code (sau alt editor)

2. Copiați .env.example în .env:
   cp .env.example .env

3. Porniți serviciile cu Docker Compose:
   docker-compose up -d

   Ce se întâmplă automat:
   - Se pornește containerul Oracle (baza de date)
   - Se așteaptă ca Oracle să fie gata (max 4 minute)
   - Se pornește containerul web
   - Se rulează automat init_db.py (creează schema, pachete, date seed, trigger-e)
   - Se pornește aplicația web cu python3 app_web.py
   
   Dacă doriți să rulați manual: python3 app/init_db.py && python3 app/app_web.py

4. Accesați aplicația în browser:
   http://localhost:5001


Pentru oprire: docker-compose down
Pentru restart: docker-compose restart
Pentru loguri: docker-compose logs -f web

