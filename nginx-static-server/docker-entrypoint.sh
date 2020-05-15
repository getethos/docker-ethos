#!/bin/ash

set -e

ENVSUBST_SHELL_FORMAT=
if [ -f "/etc/ethos/config/envsubst-shell-format" ]
then
  ENVSUBST_SHELL_FORMAT=$(cat /etc/ethos/config/envsubst-shell-format)
fi

# Some snippets files could be .template files that need to be interpolated using envsubst.
# Loop through the files and run envsubst on them
for i in /etc/nginx/snippets/*.template; do
  # make sure the file exists
  [ -f "$i" ] || break;
  echo Templating "$i"...
  envsubst "$ENVSUBST_SHELL_FORMAT" < "$i" > "${i%.template}"
done

# Template all of the files so we don't have to use sub_filter
cd /app/dist
for i in $(find *); do
  echo Templating "$i"...

  # If a directory, create it in the destination directory
  # and skip it because envsubst will error
  if [[ -d "$i" ]]
  then
    mkdir -p /usr/share/nginx/html/"$i"
    continue
  fi

  envsubst "$ENVSUBST_SHELL_FORMAT" < "$i" > /usr/share/nginx/html/"$i"
done

echo "Starting Ethos Nginx Static Server..."

exec "$@"