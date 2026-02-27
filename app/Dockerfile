FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Minimal libs for matplotlib rendering + basic SSL
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libfreetype6 \
    libpng16-16 \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/app/app

# Copy requirements first for better Docker layer caching
COPY app/requirements.txt ./requirements.txt
RUN python -m pip install --upgrade pip \
  && python -m pip install --no-cache-dir -r requirements.txt

# Copy app + sql (init_db.py references ../sql)
COPY app/ /srv/app/app/
COPY sql/ /srv/app/sql/

COPY app/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 5000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
