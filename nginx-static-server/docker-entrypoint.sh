#!/bin/ash

set -e

# Set default values for some required env vars
export CSP_CONNECT_SRC="${CSP_CONNECT_SRC:-""}"
export CSP_STYLE_SRC="${CSP_STYLE_SRC:-""}"
export CSP_SCRIPT_SRC="${CSP_SCRIPT_SRC:-""}"
export CSP_OBJECT_SRC="${CSP_OBJECT_SRC:-""}"
export CSP_FRAME_SRC="${CSP_FRAME_SRC:-""}"
export CSP_FONT_SRC="${CSP_FONT_SRC:-""}"
export CSP_IMG_SRC="${CSP_IMG_SRC:-""}"
export CSP_MEDIA_SRC="${CSP_MEDIA_SRC:-""}"
export CSP_DEFAULT_SRC="${CSP_DEFAULT_SRC:-""}"
export CSP_REPORT_URI="${CSP_REPORT_URI:-""}"

ENVSUBST_SHELL_FORMAT=
if [ -f "/app/envsubst-shell-format" ]
then
  ENVSUBST_SHELL_FORMAT=$(cat /app/envsubst-shell-format)
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