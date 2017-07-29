#!/bin/sh

echo "::patch lantern"
cd lantern
cp -f reverseproxy.go $LANTERN_ROOT/src/github.com/getlantern/flashlight/client
cp -f proxied.go $LANTERN_ROOT/src/github.com/getlantern/flashlight/proxied

