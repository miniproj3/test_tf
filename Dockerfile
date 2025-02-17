FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt /app/
RUN pip install -r requirements.txt

COPY app.py /app/

RUN apt-get update && apt-get install -y \
    libmariadb-dev gcc default-mysql-client && \
    rm -rf /var/lib/apt/lists/*

CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "app:app"]
