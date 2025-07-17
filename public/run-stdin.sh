#!/usr/bin/env bash

WORKDIR="$(mktemp -d)"
trap 'rm -rf -- "$WORKDIR"' EXIT

cp -rf . "$WORKDIR"
cd "$WORKDIR"
cat - > preloaded-data.json
python3 -m http.server
