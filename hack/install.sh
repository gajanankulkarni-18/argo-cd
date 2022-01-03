#!/bin/bash
set -eux -o pipefail

export DOWNLOADS=/tmp/dl
export BIN=${BIN:-/usr/local/bin}

mkdir -p $DOWNLOADS

ARCHITECTURE=""
case $(uname -m) in
    x86_64)                     ARCHITECTURE="amd64" ;;
    arm|armv7l|armv8l|aarch64)  dpkg --print-architecture | grep -q "arm64" && ARCHITECTURE="arm64" || ARCHITECTURE="arm" ;;
    ppc64le)  dpkg --print-architecture | grep -q "ppc64el" && ARCHITECTURE="ppc64le" ;;
esac

if [ -z "$ARCHITECTURE" ]; then
      echo "Could not detect the architecture of the system"
      exit 1
fi

for product in $*; do
  ARCHITECTURE=$ARCHITECTURE "$(dirname $0)/installers/install-${product}.sh"
done
