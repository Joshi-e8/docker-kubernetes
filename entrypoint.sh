#!/bin/sh
APP_PORT=${PORT:-8000}
cd /app/
gunicorn core.wsgi:application \
  --bind 0.0.0.0:${APP_PORT} \
  --workers 3 \
  --access-logfile - \
  --error-logfile - \
  --log-level info
