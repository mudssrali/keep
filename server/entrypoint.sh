#!/usr/bin/env bash

echo "Testing if Postgres is accepting connections. {$DB_HOST} {$DB_PORT} {$DB_USER}"
while ! pg_isready -q -h $DB_HOST -p $DB_PORT -U $DB_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $DB_NAME"` ]]; then
  echo "Database $DB_NAME does not exist. Creating..."
  mix ecto.create
  mix ecto.migrate
  mix run priv/repo/seeds.exs
  echo "Database $DB_NAME created."
fi

exec mix phx.server