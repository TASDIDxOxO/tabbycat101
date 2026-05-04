FROM python:3.11

ENV PYTHONUNBUFFERED=1
ENV IN_DOCKER=1

WORKDIR /app

# install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# copy project
COPY . /app

# install python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# run migrations + collect static (important for Django/Tabbycat)
RUN python manage.py collectstatic --noinput

# open port
EXPOSE 8000

# start server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
