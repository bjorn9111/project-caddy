#!/bin/bash

IMAGE="tvsjsdock/h2load-http3"

REQUESTS=50000
CLIENTS=32
THREADS=2

check_server() {
    local URL=$1

    echo "Checking $URL..."

    if ! curl -k -s --connect-timeout 5 "$URL" > /dev/null; then
        echo "Error: Unable to reach $URL"
        echo "Make sure the server is running before starting the benchmark."
        exit 1
    fi
}

warmup() {
    local URL=$1
    shift

    check_server "$URL"

    docker run --rm \
        --network=host \
        $IMAGE \
        "$@" \
        -t "$THREADS" \
        -n 20000 \
        -c "$CLIENTS" \
        "$URL" \
        > /dev/null
}

benchmark() {
    local URL=$1
    local RESULT_DIR=$2
    shift 2

    check_server "$URL"

    mkdir -p "../../results/$RESULT_DIR"

    docker run --rm \
        --network=host \
        -v "$PWD/../../results:/results" \
        $IMAGE \
        "$@" \
        -t "$THREADS" \
        -n "$REQUESTS" \
        -c "$CLIENTS" \
        --log-file="/results/$RESULT_DIR/requests.tsv" \
        "$URL" \
    | tee "../../results/$RESULT_DIR/summary.txt"
}
