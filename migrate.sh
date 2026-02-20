#!/bin/bash

cd /app/
SUPERUSER_EMAIL=${DJANGO_SUPERUSER_EMAIL:-"admin@gmail.com"}
SUPERUSER_USERNAME=${DJANGO_SUPERUSER_USERNAME:-"admin"}

echo "Waiting for DB..."
python wait_for_db.py

echo "Apply migrations"
python manage.py migrate --noinput

echo "Collect static"
python manage.py collectstatic --noinput

echo "Creating Super User"
python manage.py createsuperuser --username $SUPERUSER_USERNAME --noinput || true

