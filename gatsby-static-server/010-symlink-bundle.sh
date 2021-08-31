#!/usr/bin/env sh

set -e

if [ -z $NGINX_SERVE_STATIC_FILES_PATH ]
then
  echo "NGINX_SERVE_STATIC_FILES_PATH is required to be set"
  exit 1
fi

ln -s $NGINX_SERVE_STATIC_FILES_PATH /usr/share/nginx/html