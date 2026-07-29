#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

SERVER="https://10.1.0.116:8443/"
# SERVER="https://10.1.0.116:8443/"
# SERVER="https://127.0.0.1:8443/"

RESULT_FILE="$RESULT_ROOT/rq2/h1/stresstest/stress_scaling_summary.txt"

mkdir -p "$(dirname "$RESULT_FILE")"

echo "H1 stress scaling benchmark" > "$RESULT_FILE"
echo "Date: $(date)" >> "$RESULT_FILE"
echo "=================================" >> "$RESULT_FILE"

for CLIENTS in 2 4 8 16 32 64 128 256
do
    echo "" | tee -a "$RESULT_FILE"
    echo "=================================" | tee -a "$RESULT_FILE"
    echo "Running test with $CLIENTS clients" | tee -a "$RESULT_FILE"
    echo "=================================" | tee -a "$RESULT_FILE"

    warmup "$SERVER" "$CLIENTS" --h1

    benchmark \
        "$SERVER" \
        "rq2/h1/stresstest/client_$CLIENTS" \
        50000 \
        "$CLIENTS" \
        --h1 \
        | tee -a "$RESULT_FILE"
done

echo "" | tee -a "$RESULT_FILE"
echo "Stress test completed" | tee -a "$RESULT_FILE"
