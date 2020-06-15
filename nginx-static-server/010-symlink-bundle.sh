#!/usr/bin/env sh

set -e

DEPLOY_ENVIRONMENT=${DEPLOY_ENVIRONMENT="staging"}

ln -s /app/dist/$DEPLOY_ENVIRONMENT /usr/share/nginx/html