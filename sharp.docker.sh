#!./dockerize.sh
FROM=wjordan/libvips
TAG=${TAG:-wjordan/sharp}
WORKDIR=/var/cache/dockerize
CACHE=/var/cache/docker
VOLUME="${HOME}/.docker-cache:${CACHE} ${PWD}:${WORKDIR}:ro /tmp"

#!/bin/sh
ln -s ${CACHE}/apk /var/cache/apk
ln -s ${CACHE}/apk /etc/apk/cache
ln -s ${CACHE}/npm /root/.npm
ln -s ${CACHE}/node-gyp /root/.node-gyp

set -e

# Install dependencies
apk --update add --virtual build-dependencies \
  gcc g++ make libc-dev \
  python

apk --update add --virtual dev-dependencies \
  glib-dev \
  libpng-dev \
  libwebp-dev \
  libexif-dev \
  libxml2-dev \
  orc-dev \
  fftw-dev

apk --update add --virtual run-dependencies \
  glib \
  libpng \
  libwebp \
  libexif \
  libxml2 \
  orc \
  fftw

apk --update add nodejs

cd ${WORKDIR}
npm install -g sharp

# Clean up
apk del \
  build-dependencies \
  dev-dependencies

rm /root/.npm
rm /root/.node-gyp
