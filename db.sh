#!/usr/bin/env bash

docker run -p 5432:5432 -d \
    --name keep-db \
    -e POSTGRES_DB=keep_dev \
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_USER=postgres \
    -v /docker/keep/db:/var/lib/postgresql/data \
    postgres:14.1