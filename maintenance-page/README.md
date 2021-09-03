# nginx-static-server

Docker image for hosting static files such as our frontend applications. We build both the staging and production bundles of our applications in the same image and configure which bundle we serve at runtime.

## Usage

Using a multi-stage Docker build, use webpack (or whatever tool) to bundle your source files. Then in the final Docker build stage, copy the source files for staging and production to `/app/dist/staging` and `/app/dist/production`. At runtime, the `DEPLOYMENT_ENVIRONMENT` variable will toggle which bundle gets served.

An example Dockerfile for an image using this as the base would look like this:

```dockerfile
FROM node:latest as staging

# Build your staging application bundle

FROM node:latest as production

# Build your production application bundle

FROM getethos/nginx-static-server:latest

WORKDIR /app/dist

COPY --from=staging /app/public staging
COPY --from=production /app/public production
```

## Configuration

There are several ways to extend the Nginx configuration.

#### ADDITIONAL_NGINX_CONFIG environment variable

The value for this environment variable will be placed into the main Nginx config as-is. This will be set at runtime, so you can use this to add extra locations that need to be different between staging and production environments.

#### Add .conf files to /etc/nginx/conf.d/includes

A child Docker image can add files to this path and they will be included into the Nginx config as-is. This helps for adding files that are the same between environments.

#### Add .conf files to /etc/nginx/conf.d/mounts

This is intended to be used by Kubernetes to mount files that are different between environments. This helps if the configuration is large and would be hard to manage as a raw environment variable. This allows us to easily include multiple files using Kubernetes ConfigMap volumes.