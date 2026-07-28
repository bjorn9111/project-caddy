#!/bin/bash

source ./common.sh

URL="https://10.1.0.220:8443/"

warmup "$URL" --h1 -k

benchmark "$URL" "rq1/caddy_proxy_tls" --h1