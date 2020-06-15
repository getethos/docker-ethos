FROM nginx:1.19.0-alpine

# Delete the default nginx files
RUN rm -r /usr/share/nginx/html \
  /etc/nginx/conf.d/default.conf \
  /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh

# Copy nginx configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY templates /etc/nginx/templates
COPY 010-symlink-bundle.sh /docker-entrypoint.d/010-symlink-bundle.sh

# Default this to a blank string. Users can override if they want additional configuration.
# This will be interpolated into the /etc/nginx/global.conf.template file
# ADDITIONAL_GLOBAL_NGINX_CONFIG will add configuration for every request.
# ADDITIONAL_NGINX_CONFIG is meant to add additional configuration such as more locations
# for redirects.
ENV ADDITIONAL_GLOBAL_NGINX_CONFIG=""
ENV ADDITIONAL_NGINX_CONFIG=""
# Setting default values here so client don't have to set these themselves and 
# they only need to set them if they want.
ENV CSP_CONNECT_SRC=""
ENV CSP_STYLE_SRC=""
ENV CSP_SCRIPT_SRC=""
ENV CSP_OBJECT_SRC=""
ENV CSP_FRAME_SRC=""
ENV CSP_FONT_SRC=""
ENV CSP_IMG_SRC=""
ENV CSP_MEDIA_SRC=""
ENV CSP_DEFAULT_SRC=""
ENV CSP_REPORT_URI=""