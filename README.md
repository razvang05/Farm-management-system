# Farm-management-system

BD2 PROJECT - FARM MANAGEMENT SYSTEM

PROJECT STRUCTURE

documentation.pdf
docker-compose.yml
.env.example
.dockerignore

sql folder contains:
00_cleanup.sql
01_schema.sql
02_seed.sql
03_pkg_reports.sql
04_triggers.sql

app folder contains:
app_web.py
init_db.py
requirements.txt
Dockerfile
docker-entrypoint.sh
templates folder

INSTALLATION INSTRUCTIONS

Extract the archive and open the project in VS Code (or any other editor).

Copy .env.example to .env using the command:

cp .env.example .env

Start the services using Docker Compose:

docker-compose up -d

What happens automatically:

The Oracle database container starts.
The system waits until Oracle is fully ready (up to 4 minutes).
The web container starts.
init_db.py runs automatically (creates schema, packages, seed data, and triggers).
The web application starts using python3 app_web.py.

If you want to run everything manually:

python3 app/init_db.py && python3 app/app_web.py

Access the application in your browser:

http://localhost:5001

Docker commands:

Stop containers:
docker-compose down

Restart containers:
docker-compose restart

View logs:
docker-compose logs -f web
