ADDITIONAL_NGINX_CONFIG=$(cat <<-EOF
location /life/external-estimate-widget {
  add_header Content-Security-Policy "frame-ancestors: '*';" always;
  try_files /life/external-estimate-widget/index.html =404;
}
EOF
)

start_nginx() {
  docker run -p 8080:8080 \
    -e "NGINX_SERVE_STATIC_FILES_PATH=/app/dist/production" \
    -e "NGINX_LISTEN_PORT=8080" \
    -e "NGINX_METRICS_LISTEN_PORT=8081" \
    -e ADDITIONAL_NGINX_CONFIG="$ADDITIONAL_NGINX_CONFIG" \
    -d \
    -v `pwd`/fixtures/redirects.conf:/etc/nginx/conf.d/redirects/redirects.conf \
    -v `pwd`/fixtures/public:/app/dist/production \
    "$@" \
    getethos/gatsby-static-server:test
}

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

get_cache_control_header() {
  local result=$(curl -sI $1 | tr -d '\r' | sed -En 's/^Cache-Control: (.*)/\1/p')
  echo $result
}

get_location_header() {
  local result=$(curl -sI $1 | tr -d '\r' | sed -En 's/^Location: (.*)/\1/p')
  echo $result
}

get_csp_header() {
  local result=$(curl -sI $1 | tr -d '\r' | sed -En 's/^Content-Security-Policy: (.*)/\1/p')
  echo $result
}

get_content_encoding_header() {
  local result=$(curl -H "Accept-Encoding: $2" -sI $1 | tr -d '\r' | sed -En 's/^Content-Encoding: (.*)/\1/p')
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
  if [[ "$result" != "$expected" ]]; then
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
  if [[ "$result" != "$expected" ]]; then
    echo "$result was not the expected response of $expected. Exiting."
    exit 1
  fi
}

test_cache_control_header() {
  local host=$1
  local expected=$2
  echo "Testing $host for Cache-Control header. Expected value: $expected..."
  local result=$(get_cache_control_header $host)
  echo "Got $result Cache-Control header from $host"
  if [[ "$result" != "$expected" ]]; then
    echo "$result was not the expected response of $expected. Exiting."
    exit 1
  fi
}

test_location_header() {
  local host=$1
  local expected=$2
  echo "Testing $host for Location header. Expected value: $expected..."
  local result=$(get_location_header $host)
  echo "Got $result Location header from $host"
  if [[ "$result" != "$expected" ]]; then
    echo "$result was not the expected response of $expected. Exiting."
    exit 1
  fi
}

test_csp_header() {
  local host=$1
  local expected=$2
  echo "Testing $host for CSP header. Expected value: $expected..."
  local result=$(get_csp_header $host)
  echo "Got $result CSP header from $host"
  if [[ "$result" != "$expected" ]]; then
    echo "$result was not the expected response of $expected. Exiting."
    exit 1
  fi
}

test_content_encoding_header() {
  local host=$1
  local accept=$2
  local expected=$3
  echo "Testing $host for Content-Encoding header. Expected value: $expected..."
  local result=$(get_content_encoding_header $host $accept)
  echo "Got $result Content-Encoding header from $host"
  if [[ "$result" != "$expected" ]]; then
    echo "$result was not the expected response of $expected. Exiting."
    exit 1
  fi
}
