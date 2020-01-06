#!/bin/bash
set -euo pipefail

if [ ! -e index.php ]; then
	user='www-data'
	group='www-data'

	sourceTarArgs=(
		--create
		--file -
		--directory /usr/src/grav-admin
		--owner "$user" --group "$group"
	)
	targetTarArgs=(
		--extract
		--file -
	)
	if [ "$user" != '0' ]; then
		# avoid "tar: .: Cannot utime: Operation not permitted" and "tar: .: Cannot change mode to rwxr-xr-x: Operation not permitted"
		targetTarArgs+=( --no-overwrite-dir )
	fi
	tar "${sourceTarArgs[@]}" . | tar "${targetTarArgs[@]}"
	echo >&2 "Complete! Grav has been successfully copied to $PWD"

	php ./bin/plugin login newuser \
		--user="${ADMIN_USER}" \
		--password="${ADMIN_PASSWORD}" \
		--email="${ADMIN_EMAIL}" \
		--permissions="${ADMIN_PERMISSIONS}" \
		--fullname="${ADMIN_FULLNAME}" \
		--title="${ADMIN_TITLE}"
fi

exec "$@"
