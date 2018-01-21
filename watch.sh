#!/usr/bin/env bash

set -e

# Signal handling for blocking scripts:
#   https://unix.stackexchange.com/a/146770

_term() { 
    echo "Caught SIGTERM signal!" 
    kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

docker-compose run --rm dev "$@" &

child=$! 
wait "$child"

