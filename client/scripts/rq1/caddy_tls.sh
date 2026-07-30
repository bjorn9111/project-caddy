#!/bin/bash

source ./common.sh

URL="https://10.1.0.116:8443/"
# URL="https://127.0.0.1:8443/"

warmup "$URL" --h1

benchmark "$URL" "rq1/caddy_tls" --h1
