# gatsby-static-server

Docker image for hosting static files produed by Gatsby.js. We build both the staging and production bundles of our applications in the same image and configure which bundle we serve at runtime.

The nginx configuration is based on the recommended [Gatsby.js caching guide](https://www.gatsbyjs.com/docs/caching/).

## Usage

Using a multi-stage Docker build, build your gatsby source files. Then in the final Docker build stage, copy the source files for staging and production to `/app/dist/staging` and `/app/dist/production`. At runtime, set `NGINX_SERVE_STATIC_FILES_PATH` env var to choose with bundle to serve.

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