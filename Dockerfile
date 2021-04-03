# Builder
FROM node:14-buster as builder

# Support custom branches of the react-sdk and js-sdk. This also helps us build
# images of element-web develop.
ARG USE_CUSTOM_SDKS=false
ARG REACT_SDK_REPO="https://github.com/matrix-org/matrix-react-sdk.git"
ARG REACT_SDK_BRANCH="master"
ARG JS_SDK_REPO="https://github.com/matrix-org/matrix-js-sdk.git"
ARG JS_SDK_BRANCH="master"

RUN apt-get update && apt-get install -y git \
# These packages are required for building Canvas on architectures like Arm
# See https://www.npmjs.com/package/canvas#compiling
  build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev

WORKDIR /src

COPY . /src
RUN bash /src/scripts/docker-link-repos.sh
RUN yarn --network-timeout=100000 install
RUN yarn build

# Copy the config now so that we don't create another layer in the app image
RUN cp /src/config.sample.json /src/webapp/config.json

# Ensure we populate the version file
RUN bash /src/scripts/docker-write-version.sh

# Pre-compress for gzip_static
RUN find /src/webapp -type f \
    \( -iname '*.css' -o -iname '*.js' -o -iname '*.json' -o -iname '*.html' \
    -o -iname '*.svg' -o -iname '*.ttf' -o -iname '*.wasm' \) \
    -exec gzip -9 -k {} \; -exec touch -r {} {}.gz \;

# App
FROM nginx:alpine

COPY --from=builder /src/webapp /app

# Insert wasm type into Nginx mime.types file so they load correctly.
RUN sed -i '3i\ \ \ \ application/wasm wasm\;' /etc/nginx/mime.types \
 && sed -i '2i\  gzip_static on\;' /etc/nginx/conf.d/default.conf

RUN rm -rf /usr/share/nginx/html \
 && ln -s /app /usr/share/nginx/html
