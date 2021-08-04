#!/usr/bin/env bash

./rs-initiate.sh &

exec /usr/local/bin/docker-entrypoint.sh "$@"