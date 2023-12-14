#!/usr/bin/env bash

if [ -z "$1" ]
then
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION="$1"

docker buildx build --platform linux/amd64,linux/arm64 --build-arg VERSION="$VERSION" --tag "cperezabo/mongors:$VERSION" --push .

# In case of:
# ERROR: multiple platforms feature is currently not supported for docker driver. Please switch to a different driver (eg. "docker buildx create --use")
# Be sure of using a builder instance that supports the specified platforms.
# In my case I just created one using the following command:
# `docker buildx create --name apple-silicon-intel --platform linux/amd64,linux/arm64``
# And made Docker use it by running:
# `docker buildx use apple-silicon-intel`
# Then re-run this script.
