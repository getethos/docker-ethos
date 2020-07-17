#!/usr/bin/env sh

set -e

if [ $DEPLOY_ENVIRONMENT != "staging" ] && [ $DEPLOY_ENVIRONMENT != "production" ]
then
  echo "Allowed values for DEPLOY_ENVIRONMENT are: staging, production"
  exit 1
fi

ln -s /app/dist/$DEPLOY_ENVIRONMENT /usr/share/nginx/html