#!/bin/sh
# wait-for.sh: wait until a host:port is available

HOST="$1"
PORT="$2"
shift 2

echo "Waiting for $HOST:$PORT..."

while ! nc -z "$HOST" "$PORT"; do
    sleep 1
done

echo "$HOST:$PORT is available! Executing command..."
exec "$@"
