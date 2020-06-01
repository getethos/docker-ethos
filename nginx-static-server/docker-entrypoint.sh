#!/bin/ash

set -e

ENVSUBST_SHELL_FORMAT_FILE_PATH=${ENVSUBST_SHELL_FORMAT_FILE_PATH="/etc/ethos/config/envsubst-shell-format"}
ENVSUBST_SHELL_FORMAT=

if [[ -f "$ENVSUBST_SHELL_FORMAT_FILE_PATH" ]]; then
  ENVSUBST_SHELL_FORMAT=$(cat "$ENVSUBST_SHELL_FORMAT_FILE_PATH")
fi

# Run envsubst on the shell format file itself. This helps with debugging because we 
# can see the rendered output of the environment variables easily.
# This will take the envsubst-shell-format file, run sed to format the file like:
# ...
# API_ROOT_URL=${API_ROOT_URL}
# ...
# then run envsubst on it to get the interpolated variables like:
# ...
# API_ROOT_URL=api.ethoslife.com
# ...
# and print it to stdout
if [[ "$DEBUG_ENVSUBST_SHELL_FORMAT" = "true" ]]; then
  echo '$DEBUG_ENVSUBST_SHELL_FORMAT is set to true. Printing rendered envsubst-shell-format file to stdout.'
  sed 's/${\(\w\+\)}/\1=${\1}/' "$ENVSUBST_SHELL_FORMAT_FILE_PATH" | envsubst "$ENVSUBST_SHELL_FORMAT"
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