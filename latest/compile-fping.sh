#!/bin/sh

if [[ -f "/usr/local/bin/fping" ]]; then
    echo "fping is already installed. Doing nothing."
else
    echo "Compiling and installing fping..."
    apk add --no-cache build-base
    /usr/libexec/netdata/plugins.d/fping.plugin install
fi
