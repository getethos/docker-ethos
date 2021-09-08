#! /usr/bin/env bash

set -e

source ./util.sh

CONTAINER=$(start_nginx)
trap "docker stop $CONTAINER" EXIT

echo "Waiting for nginx to become ready..."
wait_for_it localhost:8080

HOST="localhost:8080"

test_status_code $HOST                      200
test_status_code $HOST/                     200
test_status_code $HOST/index.html           200
test_status_code $HOST/agents               301
test_status_code $HOST/agents/              200
test_status_code $HOST/foo                  404
test_status_code $HOST/term/preapply/quote  301
test_status_code $HOST/term/preapply/quote/ 301
test_status_code $HOST/unknown              404

test_redirect_url $HOST/foo ""
test_redirect_url $HOST/term/preapply/quote http://localhost:8080/app
test_redirect_url "$HOST/term/preapply/quote?foo=bar&ethos=cool" "http://localhost:8080/app?foo=bar&ethos=cool"
test_redirect_url "$HOST/agents" "http://localhost:8080/agents/"

test_location_header "$HOST/agents" "/agents/"

test_cache_control_header $HOST/index.html "public, max-age=0, must-revalidate, s-maxage=120;"
test_cache_control_header $HOST/page-data/app-data.json "public, max-age=0, must-revalidate, s-maxage=120;"
test_cache_control_header $HOST/page-data/index/page-data.json "public, max-age=0, must-revalidate, s-maxage=120;"
test_cache_control_header $HOST/static/foo.txt "public, max-age=31536000, immutable;"
test_cache_control_header $HOST/component---src-pages-404-js-23c828b1f8a6967959ce.js "public, max-age=31536000, immutable;"

echo "All tests passed."