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
