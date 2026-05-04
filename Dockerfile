FROM python:3.11

ENV PYTHONUNBUFFERED=1
ENV IN_DOCKER=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

RUN pip install --upgrade pip
RUN pip install -r /app/requirements.txt
