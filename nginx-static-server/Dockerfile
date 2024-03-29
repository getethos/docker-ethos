FROM nginx:1.25.0-alpine

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
# Configure the default 404 page. Most SPAs will just return a 200 and /index.html and then the client side
# routing will take over, but some applications may want to return a page such as 404.html or status code 404.
ENV DEFAULT_NOT_FOUND_PAGE="/index.html"
ENV DEFAULT_NOT_FOUND_STATUS_CODE="200"
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
ENV CSP_FRAME_ANCESTORS=""
ENV X_FRAME_OPTIONS_ADD_HEADER="add_header X-Frame-Options \"SAMEORIGIN\" always;"

# Configure which port nginx listens on. By default just listen on 80
# for regular traffic and 81 for the metrics route
ENV NGINX_LISTEN_PORT="80"
ENV NGINX_METRICS_LISTEN_PORT="81"

WORKDIR /app/dist