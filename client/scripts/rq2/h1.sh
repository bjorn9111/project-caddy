#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

SERVER="https://10.1.0.220:8443/"
# SERVER="https://127.0.0.1:8443/"

warmup "$SERVER" 10 --h1
benchmark "$SERVER" "rq2/h1/low" 10000 10 --h1

warmup "$SERVER" 50 --h1
benchmark "$SERVER" "rq2/h1/medium" 10000 50 --h1

warmup "$SERVER" 100 --h1
benchmark "$SERVER" "rq2/h1/high" 10000 100 --h1