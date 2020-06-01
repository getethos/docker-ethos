# nginx-static-server

Docker image for hosting static files such as our frontend applications.

## Usage

- copy a file to `/etc/ethos/config/envsubst-shell-format` that contains the environment variables you are going to substitute
- copy application source files to `/app/dist` and they will be automatically templated and copied to `/usr/share/nginx/html` where they will be served by nginx
- anything copied into `/etc/nginx/snippets/*.conf` will be included on the default route that handles serving the files. use this to do things add extra headers or whatever manipulation you want to do with nginx
- anything copied into `/etc/nginx/snippets/*.template` will be the same as above, but it will have environment variables templated into it at runtime

An example Dockerfile for an image using this as the base would look like this:

```dockerfile
FROM node:latest as builder

# Build your application bundle

FROM getethos/nginx-static-server:latest

COPY --from=builder /dist /app/dist
```

## Debugging

You can set the environment variable `DEBUG_ENVSUBST_SHELL_FORMAT` to `"true"` and it will print out the interpolated values of environment variables to stdout to help you see what the values actually are in the code.