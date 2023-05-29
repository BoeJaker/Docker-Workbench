FROM python:3.9-alpine

RUN apk update
RUN apk add postgresql-dev gcc python3-dev musl-dev
RUN pip install psycopg2 beautifulsoup4 requests

COPY /services/cve_database/update_cve_db.py /update_cve_db.py
RUN chmod +x /update_cve_db.py