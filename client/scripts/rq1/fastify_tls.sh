#!/bin/bash

source ./common.sh

URL="https://10.1.0.116:3443/"
# URL="https://127.0.0.1:3000/"
warmup "$URL" --h1

benchmark "$URL" "rq1/fastify_tls" --h1
