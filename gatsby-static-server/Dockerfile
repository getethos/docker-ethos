FROM nginx:stable-alpine

# Delete the default nginx files
RUN rm -r /usr/share/nginx/html \
  /etc/nginx/conf.d/default.conf \
  /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh

RUN mkdir /etc/nginx/conf.d/redirects

# Copy nginx configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY templates /etc/nginx/templates
COPY 010-symlink-bundle.sh /docker-entrypoint.d/010-symlink-bundle.sh

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

# Configure which port nginx listens on. By default just listen on 80
# for regular traffic and 81 for the metrics route
ENV NGINX_LISTEN_PORT="80"
ENV NGINX_METRICS_LISTEN_PORT="81"

WORKDIR /app/dist