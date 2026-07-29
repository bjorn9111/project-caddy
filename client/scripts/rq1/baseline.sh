#!/bin/bash

source ./common.sh

URL="http://10.1.0.116:3000/"
# URL="http://127.0.0.1:3000/"

warmup "$URL" --h1

benchmark "$URL" "rq1/baseline" --h1
