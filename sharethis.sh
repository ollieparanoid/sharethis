#!/bin/bash

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
