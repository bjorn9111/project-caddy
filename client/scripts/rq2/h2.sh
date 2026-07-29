#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

SERVER="https://10.1.0.116:8443/"
# SERVER="https://127.0.0.1:8443/"

warmup "$SERVER" 4 --npn-list h2
benchmark "$SERVER" "rq2/h2/low" 50000 4 --npn-list h2 -m 10

warmup "$SERVER" 32 --npn-list h2
benchmark "$SERVER" "rq2/h2/medium" 50000 32 --npn-list h2 -m 10

warmup "$SERVER" 128 --npn-list h2
benchmark "$SERVER" "rq2/h2/high" 50000 128 --npn-list h2 -m 10
