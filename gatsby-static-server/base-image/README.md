In order to support the Brotli compression module, we need to follow the official instructions here: https://github.com/nginxinc/docker-nginx/tree/1.22.1/modules

Basically, I copy/paste the Dockerfile from the tag we are using (currently 1.22.1 as of writing), and build that image with a build arg enabled to install the brotli module. See the link above for more detailed instructions.

### Step 1
Build the docker image in this directory, with the brotli build arg enabled.

`docker build --build-arg ENABLED_MODULES="brotli" -f Dockerfile.alpine -t getethos/gatsby-static-server-base .`

### Step 2
Build the docker image up one level from this directory, making sure it "FROMs" from the image you just built.