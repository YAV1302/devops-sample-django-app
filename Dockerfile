FROM python:3.8-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y gcc python3-dev libpcre3-dev build-essential && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir uwsgi

COPY --chmod=544 . /app/

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["uwsgi", "--http", "0.0.0.0:8000", "--module", "parrotsite.wsgi:application", "--master", "--processes", "4", "--threads", "2"]
