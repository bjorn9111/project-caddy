#!/bin/bash

IMAGE="tvsjsdock/h2load-http3"

# h2load configuration
THREADS=2
WARMUP_REQUESTS=5000

# Resolve paths relative to this file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULT_ROOT="$SCRIPT_DIR/../../results"


check_server() {
    local URL=$1

    echo "Checking $URL..."

    if ! curl -k -s --connect-timeout 5 "$URL" > /dev/null; then
        echo "Error: Cannot reach $URL"
        echo "Make sure the server is running before starting the benchmark."
        exit 1
    fi
}


warmup() {
    local URL=$1
    local CLIENTS=$2
    shift 2

    check_server "$URL"

    docker run --rm \
        --network=host \
        "$IMAGE" \
        "$@" \
        -t "$THREADS" \
        -n "$WARMUP_REQUESTS" \
        -c "$CLIENTS" \
        "$URL" \
        > /dev/null
}


benchmark() {
    local URL=$1
    local RESULT_DIR=$2
    local REQUESTS=$3
    local CLIENTS=$4
    shift 4

    check_server "$URL"

    mkdir -p "$RESULT_ROOT/$RESULT_DIR"

    docker run --rm \
        --network=host \
        -v "$RESULT_ROOT:/results" \
        "$IMAGE" \
        "$@" \
        -t "$THREADS" \
        -n "$REQUESTS" \
        -c "$CLIENTS" \
        --log-file="/results/$RESULT_DIR/requests.tsv" \
        "$URL" \
    | tee "$RESULT_ROOT/$RESULT_DIR/summary.txt"
}