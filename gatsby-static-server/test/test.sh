#! /usr/bin/env bash

# adapted from https://serverfault.com/a/919042
# returns the status code from curl'ing an endpoint
get_status_code() {
  local result=$(curl -s -o /dev/null -w "%{http_code}" $1)
  echo $result
}

get_redirect_url() {
  local result=$(curl -s -o /dev/null -w "%{redirect_url}" $1)
  echo $result
}

wait_for_it() {
  until curl --silent $1 > /dev/null; do
    echo "host is unavailable - sleeping"
    sleep 5
  done
}

dcu() {
  docker-compose -f docker-compose.test.yaml up --build -d
}

dcd() {
  docker-compose -f docker-compose.test.yaml down
}

# Checks an expected status code against nginx response
# Takes two parameters:
# - (string) host:port of endpoint to hit
# - (number) expected status code
test_status_code() {
  local host=$1
  local expected=$2
  echo "Testing $host for status code $expected..."
  local result=$(get_status_code $host)
  echo "Got $result response from $host"
  if [[ $result != $expected ]]; then
    echo "$result was not the expected response of $expected. Exiting."
    exit 1
  fi
}

# Checks an expected redirect URL code against nginx response
# Takes two parameters:
# - (string) host:port of endpoint to hit
# - (number) expected redirect URL
test_redirect_url() {
  local host=$1
  local expected=$2
  echo "Testing $host for redirect URL $expected..."
  local result=$(get_redirect_url $host)
  echo "Got $result response from $host"
  if [[ $result != $expected ]]; then
    echo "$result was not the expected response of $expected. Exiting."
    exit 1
  fi
}

dcu
echo "Waiting for nginx to become ready..."
wait_for_it localhost:8080

test_status_code localhost:8080 200
test_status_code localhost:8080/ 200
test_status_code localhost:8080/index.html 200
test_status_code localhost:8080/agents 200
test_status_code localhost:8080/agents/ 200
test_status_code localhost:8080/foo 301
test_redirect_url localhost:8080/foo http://localhost:8080/app
test_status_code localhost:8080/term/preapply/quote 301
test_status_code localhost:8080/term/preapply/quote/ 301
test_status_code localhost:8080/unknown 200

dcd
