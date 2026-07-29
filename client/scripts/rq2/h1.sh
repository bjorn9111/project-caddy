#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

SERVER="https://10.1.0.116:8443/"
# SERVER="https://127.0.0.1:8443/"

warmup "$SERVER" 4 --h1
benchmark "$SERVER" "rq2/h1/low_4_clients" 50000 4 --h1

warmup "$SERVER" 32 --h1
benchmark "$SERVER" "rq2/h1/medium_32_clients" 50000 32 --h1

warmup "$SERVER" 128 --h1
benchmark "$SERVER" "rq2/h1/high_128_clients" 50000 128 --h1
