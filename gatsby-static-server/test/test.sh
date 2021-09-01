#! /usr/bin/env bash

set -e

source ./util.sh

CONTAINER=$(start_nginx)
trap "docker stop $CONTAINER" EXIT

echo "Waiting for nginx to become ready..."
wait_for_it localhost:8080

test_status_code localhost:8080                      200
test_status_code localhost:8080/                     200
test_status_code localhost:8080/index.html           200
test_status_code localhost:8080/agents               301
test_status_code localhost:8080/agents/              200
test_status_code localhost:8080/foo                  404
test_status_code localhost:8080/term/preapply/quote  301
test_status_code localhost:8080/term/preapply/quote/ 301
test_status_code localhost:8080/unknown              404

test_redirect_url localhost:8080/foo ""
test_redirect_url localhost:8080/term/preapply/quote http://localhost:8080/app
test_redirect_url "localhost:8080/term/preapply/quote?foo=bar&ethos=cool" "http://localhost:8080/app?foo=bar&ethos=cool"

echo "All tests passed."