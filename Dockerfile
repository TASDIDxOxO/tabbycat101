 Docker file lists all the commands needed to setup a fresh linux 
instance to
# run the application specified. docker-compose does not use this.

# Grab a python image
FROM python:3.11
SHELL ["/bin/bash", "--login", "-c"]

# Just needed for all things python (note this is setting an env variable)
ENV PYTHONUNBUFFERED 1

FROM python:3.11

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV IN_DOCKER=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libpq-dev

COPY requirements.txt /app/

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . /app/

RUN python manage.py migrate || true
RUN python manage.py collectstatic --noinput || true

CMD ["gunicorn", "tabbycat.wsgi:application", "--bind", "0.0.0.0:8000"]
