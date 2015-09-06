#!/bin/bash
#
# Copyright 2015 Oliver Smith
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

PORT=4443
WEBROOT="$(pwd -P)"
SHARETHIS="$(cd $(dirname $0); pwd -P)"
CACHE="$(dirname ~/.cache/sharethis/.)"
NGINX="nginx -c /tmp/nginx.conf"


# Check dependencies
DEPENDENCIES="openssl nginx firejail sed tail"
for DEPENDENCY in $DEPENDENCIES; do
	type $DEPENDENCY >/dev/null 2>&1 && continue
	echo "Dependency not found:"
	echo "  $DEPENDENCY"
	echo "All dependencies:"
	echo "  "$DEPENDENCIES
	exit 1
done


# Sandbox this script
if [ -z "${SHARETHIS_SANDBOXED}" ]; then
	echo "Starting sandbox"
	firejail \
		--quiet \
		--env=SHARETHIS_SANDBOXED=1 \
		--profile=$SHARETHIS/firejail.profile \
		--whitelist=$CACHE \
		--whitelist=$WEBROOT \
		$0
	EXITCODE=$?
	echo ""
	echo "Sandbox stopped"
	exit $EXITCODE
fi


# Generate certificate
if [ ! -e "$CACHE/server.key" ]; then
	mkdir -p "$CACHE"
	cd "$CACHE"
	openssl req -x509 -newkey rsa:4096 -keyout server.key \
		-out server.cert -days 365 -sha512 -subj "/CN=localhost" \
		-nodes || rm -r "$CACHE"
	
	[ ! -e "$CACHE/server.key" ] && exit 2
fi


# Generate and test config
sed -e "s~SHAREME_PORT~$PORT~g" \
	-e "s~SHAREME_CACHE~$CACHE~g" \
	-e "s~SHAREME_WEBROOT~$WEBROOT~g" \
	$SHARETHIS/nginx.conf \
	> /tmp/nginx.conf
$NGINX -t -q || exit 3


# Display summary
echo ""
echo "Port:"
echo $PORT
echo ""
echo "Certificate SHA256:"
openssl x509 -in "$CACHE/server.cert" -noout -sha256 -fingerprint \
	| cut -d '=' -f 2
echo ""
echo "Webroot:"
echo "$WEBROOT"
echo ""
echo "Press ^C to stop"


# Run nginx, follow the logs
$NGINX
tail -f /tmp/nginx.log
