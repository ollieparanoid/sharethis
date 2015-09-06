#!/bin/bash

WEBROOT="$(pwd -P)"
SHARETHIS="$(cd $(dirname $0); pwd -P)"
NGINX="nginx -c $SHARETHIS/nginx.conf"
CACHE=~/.cache/sharethis

# Check dependencies
DEPENDENCIES="openssl nginx fcgiwrap firejail sha512sum"
for DEPENDENCY in $DEPENDENCIES; do
	type $DEPENDENCY >/dev/null 2>&1 && continue
	echo "Dependency not found:"
	echo "  $DEPENDENCY"
	echo "All dependencies:"
	echo "  "$DEPENDENCIES
	exit 1
done

# Generate certificate
if [ ! -e "$CACHE/server.key" ]; then
	mkdir -p "$CACHE"
	cd "$CACHE"
	openssl req -x509 -newkey rsa:4096 -keyout server.key \
		-out server.cert -days 365 -sha512 -subj "/CN=localhost" \
		-nodes || rm -r "$CACHE"
	
	[ ! -e "$CACHE/server.key" ] && exit 2
fi

# Verify nginx.conf
$NGINX -t -q || exit 3

echo "STUB"
