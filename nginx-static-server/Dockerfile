FROM nginx:stable-alpine

# Create directory for app files
RUN mkdir -p /app/dist

# Delete the default nginx files
RUN rm -r /usr/share/nginx/html/* /etc/nginx/conf.d/default.conf

# Copy nginx configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d /etc/nginx/conf.d
COPY snippets /etc/nginx/snippets
RUN mkdir -p /etc/nginx/locations

# Start nginx, using a custom entrypoint to template env variables
# Docs: https://success.docker.com/article/use-a-script-to-initialize-stateful-container-data
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
CMD ["/bin/ash", "-c", "nginx -g 'daemon off;'"]