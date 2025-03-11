#!/bin/bash

set -x

nix build .#dockerImage/node \
  && RES=$(docker load -i result) \
  && LOADED="${RES##Loaded image: }" \
  && GITHASH=$(git log -n1 --pretty='%H') \
  && docker tag "$LOADED" kocubinski/cardano-node:dev \
  && docker rmi "$LOADED"

# GITTAG=$(git describe --exact-match --tags $GITHASH)
GITTAG=$(git describe --tags $GITHASH)
if [ $? -eq 0 ]; then
  echo "Current tag: $GITTAG"
  docker tag kocubinski/cardano-node:dev "kocubinski/cardano-node:$GITTAG"
fi
