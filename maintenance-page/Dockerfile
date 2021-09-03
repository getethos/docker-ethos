FROM nginx:1.19.0-alpine

# Delete the default nginx files
RUN rm -r /usr/share/nginx/html \
  /etc/nginx/conf.d/default.conf \
  /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh

COPY nginx.conf /etc/nginx/nginx.conf
COPY maintenance.html /usr/share/nginx/html/maintenance.html